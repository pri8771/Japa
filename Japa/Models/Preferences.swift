import Foundation

/// Minimal practice preferences, persisted locally.
struct Preferences: Codable, Equatable {
    /// Default target for new sessions (one mala = 108).
    var defaultTarget: Int
    /// Whether the single gentle completion tone plays at the target.
    /// The completion *haptic* always fires regardless of this setting.
    var completionToneEnabled: Bool
    /// Per-bead haptic strength, 0...1. Honored where the hardware supports
    /// variable intensity; ignored gracefully elsewhere.
    var hapticIntensity: Double
    /// The id of the last-used mantra, restored on next launch.
    var lastMantraID: UUID?
    /// Whether the brief first-run explainer has been seen.
    var hasSeenIntro: Bool

    init(
        defaultTarget: Int = JapaEngine.defaultTarget,
        completionToneEnabled: Bool = true,
        hapticIntensity: Double = 0.85,
        lastMantraID: UUID? = nil,
        hasSeenIntro: Bool = false
    ) {
        self.defaultTarget = JapaEngine.clampTarget(defaultTarget)
        self.completionToneEnabled = completionToneEnabled
        self.hapticIntensity = min(max(hapticIntensity, 0), 1)
        self.lastMantraID = lastMantraID
        self.hasSeenIntro = hasSeenIntro
    }

    /// Common targets offered in settings (fractions and multiples of a mala).
    static let targetChoices = [27, 54, 108, 216, 1080]
}
