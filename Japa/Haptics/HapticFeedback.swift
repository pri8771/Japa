import Foundation

/// The haptic vocabulary of the practice loop. An abstraction so the practice
/// controller never touches Core Haptics directly and tests can substitute a spy.
@MainActor
protocol HapticFeedback: AnyObject {
    /// Warm up the engine so the first tick has no startup latency.
    func prepare()
    /// A crisp per-bead tick. `intensity` is 0...1 (the user's haptic preference).
    func tick(intensity: Double)
    /// The distinct end-of-round pattern — clearly different from a tick.
    func completion()
    /// A soft step-back for undo.
    func back()
}

/// A no-op used in previews and unit tests where no real device feedback exists.
@MainActor
final class NoopHaptics: HapticFeedback {
    func prepare() {}
    func tick(intensity: Double) {}
    func completion() {}
    func back() {}
}
