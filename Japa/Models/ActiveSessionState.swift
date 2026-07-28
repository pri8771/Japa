import Foundation

/// A snapshot of an in-progress round, persisted on every advance and on
/// resign-active so the practitioner's place survives backgrounding, force-quit,
/// and device restart. This is what makes Japa interruption-safe rather than a
/// counter that forgets where you were.
///
/// Only *in-progress* (incomplete) rounds are persisted here; once a round
/// completes it moves to history and this snapshot is cleared, so completion can
/// never double-fire across a relaunch.
struct ActiveSessionState: Codable, Equatable {
    var target: Int
    var count: Int
    var mantraTitle: String
    var startedAt: Date
    /// Foreground time accumulated while the practice round was active.
    var elapsedActiveDuration: TimeInterval
    /// The moment of the last accepted interaction (advance/undo). Drives the
    /// "Finish this round?" prompt after a long gap — deliberately *not*
    /// refreshed by mere launches or persistence flushes, only by real taps.
    var updatedAt: Date

    init(
        target: Int,
        count: Int,
        mantraTitle: String,
        startedAt: Date,
        updatedAt: Date,
        elapsedActiveDuration: TimeInterval = 0
    ) {
        self.target = target
        self.count = count
        self.mantraTitle = mantraTitle
        self.startedAt = startedAt
        self.updatedAt = updatedAt
        self.elapsedActiveDuration = max(0, elapsedActiveDuration)
    }

    /// Rebuilds an engine positioned at the exact persisted bead.
    func makeEngine() -> JapaEngine {
        JapaEngine(target: target, count: count)
    }

    // MARK: Codable

    /// Decodes leniently so snapshots saved before `updatedAt` existed still
    /// load (falling back to `startedAt`) instead of silently dropping the
    /// user's resumable place.
    enum CodingKeys: String, CodingKey {
        case target, count, mantraTitle, startedAt, updatedAt, elapsedActiveDuration
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.target = try container.decode(Int.self, forKey: .target)
        self.count = try container.decode(Int.self, forKey: .count)
        self.mantraTitle = try container.decode(String.self, forKey: .mantraTitle)
        let started = try container.decode(Date.self, forKey: .startedAt)
        self.startedAt = started
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt) ?? started
        // Legacy snapshots contain no reliable active-time value. Preserve the
        // bead count, but reset their timer instead of importing wall-clock
        // hours spent outside the app.
        self.elapsedActiveDuration = max(
            0,
            try container.decodeIfPresent(TimeInterval.self, forKey: .elapsedActiveDuration) ?? 0
        )
    }
}
