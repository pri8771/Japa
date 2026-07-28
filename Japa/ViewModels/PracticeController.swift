import Foundation
import Observation

/// Drives one practice round, wiring the pure engine to haptics, the completion
/// tone, and interruption-safe persistence.
///
/// The hot path is ordered deliberately: advance in-memory state, fire the
/// haptic, *then* persist. Storage never sits between the tap and the tactile
/// confirmation (see `ActiveSessionStore`).
@MainActor
@Observable
final class PracticeController {

    enum Phase: Equatable {
        case practicing
        case completed
    }

    private(set) var engine: JapaEngine
    private(set) var phase: Phase = .practicing

    let mantra: Mantra
    private(set) var startedAt: Date
    /// The last accepted interaction (advance/undo/new round). Restored from
    /// the persisted snapshot on resume so a round left untouched for a long
    /// time can be recognized as stale across relaunches. Not refreshed by
    /// launches or persistence flushes — only by real interactions (or an
    /// explicit "keep going" answer to the stale prompt via `touch()`).
    private(set) var lastInteractionAt: Date
    private(set) var accumulatedActiveDuration: TimeInterval
    private var activeSince: Date?

    private let now: () -> Date
    private let haptics: HapticFeedback
    private let tone: TonePlaying
    private let activeStore: ActiveSessionStore
    private let preferences: () -> Preferences
    private let onFinish: (PracticeSession) -> Void

    var count: Int { engine.count }
    var target: Int { engine.target }
    var progress: Double { engine.progress }
    var remaining: Int { engine.remaining }
    var isComplete: Bool { engine.isComplete }
    /// Whether there is a place worth resuming (used to gate the resume prompt).
    var hasProgress: Bool { engine.count > 0 }
    /// Foreground practice time only; suspended and terminated intervals are
    /// deliberately excluded.
    var elapsedActiveDuration: TimeInterval {
        accumulatedActiveDuration + activeSegmentDuration(at: now())
    }

    init(
        mantra: Mantra,
        target: Int,
        restoredCount: Int? = nil,
        startedAt: Date = Date(),
        restoredUpdatedAt: Date? = nil,
        restoredActiveDuration: TimeInterval = 0,
        now: @escaping () -> Date = Date.init,
        preferences: @escaping () -> Preferences,
        haptics: HapticFeedback,
        tone: TonePlaying,
        activeStore: ActiveSessionStore,
        onFinish: @escaping (PracticeSession) -> Void
    ) {
        self.mantra = mantra
        self.startedAt = startedAt
        self.now = now
        let current = now()
        self.lastInteractionAt = restoredUpdatedAt ?? current
        self.accumulatedActiveDuration = max(0, restoredActiveDuration)
        self.activeSince = current
        self.engine = JapaEngine(target: target, count: restoredCount ?? 0)
        self.preferences = preferences
        self.haptics = haptics
        self.tone = tone
        self.activeStore = activeStore
        self.onFinish = onFinish
        self.phase = engine.isComplete ? .completed : .practicing
    }

    /// Warm up feedback engines and persist the starting place.
    func prepare() {
        haptics.prepare()
        if preferences().completionToneEnabled { tone.prepare() }
        persistActive()
    }

    /// Advance one bead. Any gesture calls this — the engine is input-agnostic.
    func advance() {
        guard phase == .practicing else { return }
        switch engine.advance() {
        case .advanced:
            lastInteractionAt = now()
            haptics.tick(intensity: preferences().hapticIntensity)
            persistActive()
        case .completed:
            lastInteractionAt = now()
            haptics.completion()
            if preferences().completionToneEnabled { tone.play() }
            complete()
        case .alreadyComplete:
            break
        }
    }

    /// Step back one bead after an accidental tap.
    func undo() {
        guard phase == .practicing else { return }
        if engine.undo() {
            lastInteractionAt = now()
            haptics.back()
            persistActive()
        }
    }

    /// Start a fresh round at the same target (the explicit "new round" path).
    func startNewRound() {
        let current = now()
        engine.startNewRound()
        phase = .practicing
        startedAt = current
        lastInteractionAt = current
        accumulatedActiveDuration = 0
        activeSince = current
        persistActive()
    }

    // MARK: - Stale-round handling

    /// Whether the round has been sitting untouched long enough to ask the
    /// practitioner whether they're done with it. Only a real in-progress
    /// round can be stale — a fresh (zero-count) or completed round never is.
    func isStale(after threshold: TimeInterval) -> Bool {
        phase == .practicing
            && engine.count > 0
            && !engine.isComplete
            && now().timeIntervalSince(lastInteractionAt) >= threshold
    }

    /// The practitioner answered "keep going" to the stale prompt — treat that
    /// as an interaction so the prompt doesn't immediately re-fire.
    func touch() {
        lastInteractionAt = now()
        persistActive()
    }

    /// The practitioner answered "finish" — record the honest partial to
    /// history and start a fresh round in place.
    func finishEarly() {
        guard phase == .practicing else { return }
        if engine.count > 0 {
            onFinish(makeSession(reached: false))
        }
        startNewRound()
    }

    /// Leave before reaching the target. Records an honest partial session if any
    /// beads were counted; a zero-count session is simply discarded.
    func endEarly() {
        guard phase == .practicing else { return }
        activeStore.clear()
        if engine.count > 0 {
            onFinish(makeSession(reached: false))
        }
    }

    /// Pause the foreground stopwatch and synchronously save before suspend.
    func pauseTiming() {
        accumulateActiveTime()
        persistActive()
        activeStore.flush()
    }

    /// Begin a new foreground timing segment after the app becomes active.
    func resumeTiming() {
        guard phase == .practicing, activeSince == nil else { return }
        activeSince = now()
    }

    /// Compatibility entry point used by existing lifecycle tests.
    func persistNow() {
        pauseTiming()
    }

    // MARK: - Internals

    private func complete() {
        accumulateActiveTime()
        phase = .completed
        activeStore.clear() // round done — nothing in-progress to resume
        onFinish(makeSession(reached: true))
    }

    private func persistActive() {
        guard phase == .practicing else { return }
        activeStore.save(
            ActiveSessionState(
                target: engine.target,
                count: engine.count,
                mantraTitle: mantra.title,
                startedAt: startedAt,
                // Deliberately the last *interaction*, not "now": launches and
                // flushes must not mask how long the round has sat untouched.
                updatedAt: lastInteractionAt,
                elapsedActiveDuration: elapsedActiveDuration
            )
        )
    }

    private func makeSession(reached: Bool) -> PracticeSession {
        PracticeSession(
            startedAt: startedAt,
            duration: elapsedActiveDuration,
            mantraTitle: mantra.title,
            target: engine.target,
            completedCount: engine.count,
            reachedTarget: reached
        )
    }

    private func activeSegmentDuration(at date: Date) -> TimeInterval {
        guard let activeSince else { return 0 }
        return max(0, date.timeIntervalSince(activeSince))
    }

    private func accumulateActiveTime() {
        let current = now()
        accumulatedActiveDuration += activeSegmentDuration(at: current)
        activeSince = nil
    }
}
