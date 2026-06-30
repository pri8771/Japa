import Foundation

/// The pure repetition core of Japa.
///
/// This is the product's differentiator distilled to UI-independent logic:
/// counting toward a target, exactly-once round completion, explicit new
/// rounds, and an undo that never over- or under-counts. It is deliberately a
/// value type with no knowledge of haptics, audio, persistence, beads, or any
/// specific input gesture — *any* gesture calls the same `advance()`.
///
/// ## Frozen v1 contract (from the product thread)
/// - `advance()` increments while `count < target`.
/// - The completion event fires **exactly once**, on the tick `count` reaches `target`.
/// - `advance()` after completion is a no-op that returns `.alreadyComplete`; it
///   never silently starts a new round and never over-counts. The count pins at `target`.
/// - `startNewRound()` / `reset()` are the only paths back to an active count.
/// - No auto-loop in v1: reaching the target stops; a new round is explicit.
struct JapaEngine: Equatable {

    /// One full mala.
    static let defaultTarget = 108
    /// Smallest valid target. A target of 0 or less is meaningless for a count.
    static let minTarget = 1
    /// Ten malas. A sane ceiling that still allows long continuous practice.
    static let maxTarget = 1080

    /// The configured target for the current round. Always within `[minTarget, maxTarget]`.
    private(set) var target: Int

    /// The current bead within the round. Always within `[0, target]`.
    private(set) var count: Int

    /// Whether the round has reached its target.
    var isComplete: Bool { count >= target }

    /// Fractional progress through the round, clamped to `0...1`.
    var progress: Double {
        guard target > 0 else { return 0 }
        return min(1, Double(count) / Double(target))
    }

    /// How many advances remain before completion.
    var remaining: Int { max(0, target - count) }

    /// A target is valid if it is a positive count no larger than `maxTarget`.
    static func isValidTarget(_ value: Int) -> Bool {
        value >= minTarget && value <= maxTarget
    }

    /// Clamps any integer into the valid target range.
    static func clampTarget(_ value: Int) -> Int {
        min(max(value, minTarget), maxTarget)
    }

    /// Creates an engine, clamping `target` into range and `count` into `0...target`.
    ///
    /// `count` is accepted (and clamped) so a persisted in-progress round can be
    /// restored exactly — this is how interruption-resume reconstructs state.
    init(target: Int = JapaEngine.defaultTarget, count: Int = 0) {
        let clampedTarget = JapaEngine.clampTarget(target)
        self.target = clampedTarget
        self.count = min(max(count, 0), clampedTarget)
    }

    /// Advances by one bead.
    ///
    /// - Returns: `.advanced` while in progress, `.completed` exactly once on the
    ///   tick the target is reached, and `.alreadyComplete` for any advance after that.
    @discardableResult
    mutating func advance() -> AdvanceResult {
        guard count < target else {
            return .alreadyComplete(count: count)
        }
        count += 1
        return count == target ? .completed(count: count) : .advanced(count: count)
    }

    /// Steps back one bead (an accidental-tap undo).
    ///
    /// Decrements toward a floor of 0 and **never** fires completion — undoing
    /// from the target bead simply re-opens the round at `target - 1`.
    ///
    /// - Returns: `true` if the count actually decremented, `false` if already at 0.
    @discardableResult
    mutating func undo() -> Bool {
        guard count > 0 else { return false }
        count -= 1
        return true
    }

    /// Begins a fresh round at count 0, keeping the current target.
    mutating func startNewRound() {
        count = 0
    }

    /// Alias for `startNewRound()` — resets the count without touching the target.
    mutating func reset() {
        count = 0
    }

    /// Changes the target for subsequent counting.
    ///
    /// Invalid targets (≤ 0, or above `maxTarget`) are **rejected** and leave the
    /// engine unchanged. If the new target is below the current count, the count
    /// is pulled down to the new target (which immediately completes the round).
    ///
    /// - Returns: `true` if the target was applied, `false` if it was rejected.
    @discardableResult
    mutating func configure(target newTarget: Int) -> Bool {
        guard JapaEngine.isValidTarget(newTarget) else { return false }
        target = newTarget
        if count > target { count = target }
        return true
    }
}
