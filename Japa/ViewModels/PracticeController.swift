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
    let startedAt: Date

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

    init(
        mantra: Mantra,
        target: Int,
        restoredCount: Int? = nil,
        startedAt: Date = Date(),
        preferences: @escaping () -> Preferences,
        haptics: HapticFeedback,
        tone: TonePlaying,
        activeStore: ActiveSessionStore,
        onFinish: @escaping (PracticeSession) -> Void
    ) {
        self.mantra = mantra
        self.startedAt = startedAt
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
            haptics.tick(intensity: preferences().hapticIntensity)
            persistActive()
        case .completed:
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
            haptics.back()
            persistActive()
        }
    }

    /// Start a fresh round at the same target (the explicit "new round" path).
    func startNewRound() {
        engine.startNewRound()
        phase = .practicing
        persistActive()
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

    /// Resign-active backstop: ensure the latest place is flushed to disk.
    func persistNow() {
        persistActive()
        activeStore.flush()
    }

    // MARK: - Internals

    private func complete() {
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
                startedAt: startedAt
            )
        )
    }

    private func makeSession(reached: Bool) -> PracticeSession {
        PracticeSession(
            startedAt: startedAt,
            duration: Date().timeIntervalSince(startedAt),
            mantraTitle: mantra.title,
            target: engine.target,
            completedCount: engine.count,
            reachedTarget: reached
        )
    }
}
