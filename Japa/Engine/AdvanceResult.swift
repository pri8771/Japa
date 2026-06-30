import Foundation

/// The outcome of a single `JapaEngine.advance()` call.
///
/// The result type is how the round-completion *event* is delivered: a single
/// `.completed` is returned exactly once, on the tick where the count reaches
/// the target. Every advance after that returns `.alreadyComplete`. This keeps
/// completion unambiguous without the engine holding any "did I already fire?"
/// flag of its own — the event *is* the return value.
enum AdvanceResult: Equatable {
    /// The count incremented and the round is still in progress.
    case advanced(count: Int)

    /// The count reached the target on this advance. Fires exactly once per round.
    case completed(count: Int)

    /// The round was already complete; this advance was a no-op. The count is
    /// pinned at the target and no new round is started implicitly.
    case alreadyComplete(count: Int)

    /// The count after this advance, regardless of case.
    var count: Int {
        switch self {
        case let .advanced(count), let .completed(count), let .alreadyComplete(count):
            return count
        }
    }
}
