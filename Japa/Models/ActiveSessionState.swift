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

    /// Rebuilds an engine positioned at the exact persisted bead.
    func makeEngine() -> JapaEngine {
        JapaEngine(target: target, count: count)
    }
}
