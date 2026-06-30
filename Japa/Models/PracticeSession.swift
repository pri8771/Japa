import Foundation

/// A finished practice session, saved to the quiet local history.
///
/// History is recorded honestly: a session abandoned before the target is stored
/// as `partial` so counts are never silently inflated. There is deliberately **no
/// streak**, no "don't break the chain", and no loss-aversion framing anywhere on
/// this model or the views that render it.
struct PracticeSession: Identifiable, Codable, Hashable {
    let id: UUID
    /// When the session started.
    let startedAt: Date
    /// Wall-clock duration of the session.
    let duration: TimeInterval
    /// The mantra's display title at the time (denormalized so history survives
    /// deletion of a custom mantra).
    let mantraTitle: String
    /// The configured target for the round.
    let target: Int
    /// How many beads were actually counted.
    let completedCount: Int
    /// Whether the round reached its target.
    let reachedTarget: Bool

    init(
        id: UUID = UUID(),
        startedAt: Date,
        duration: TimeInterval,
        mantraTitle: String,
        target: Int,
        completedCount: Int,
        reachedTarget: Bool
    ) {
        self.id = id
        self.startedAt = startedAt
        self.duration = duration
        self.mantraTitle = mantraTitle
        self.target = target
        self.completedCount = completedCount
        self.reachedTarget = reachedTarget
    }
}

extension PracticeSession {
    /// Honest completeness label for the history list.
    var isComplete: Bool { reachedTarget }
}
