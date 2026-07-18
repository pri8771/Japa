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
    /// The selected visual/motion style for the practice bead. Defaults to
    /// `.classic`, the original shipped look.
    var malaStyle: MalaStyle

    init(
        defaultTarget: Int = JapaEngine.defaultTarget,
        completionToneEnabled: Bool = true,
        hapticIntensity: Double = 0.85,
        lastMantraID: UUID? = nil,
        hasSeenIntro: Bool = false,
        malaStyle: MalaStyle = .default
    ) {
        self.defaultTarget = JapaEngine.clampTarget(defaultTarget)
        self.completionToneEnabled = completionToneEnabled
        self.hapticIntensity = min(max(hapticIntensity, 0), 1)
        self.lastMantraID = lastMantraID
        self.hasSeenIntro = hasSeenIntro
        self.malaStyle = malaStyle
    }

    /// Common targets offered in settings (fractions and multiples of a mala).
    static let targetChoices = [27, 54, 108, 216, 1080]

    // MARK: Codable

    /// Decodes leniently so preferences saved before a field existed (e.g.
    /// `malaStyle`, added after `hasSeenIntro`) still load instead of the
    /// whole file falling back to fresh defaults and silently discarding the
    /// user's saved target/haptic settings.
    enum CodingKeys: String, CodingKey {
        case defaultTarget, completionToneEnabled, hapticIntensity, lastMantraID, hasSeenIntro, malaStyle
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let fallback = Preferences()
        self.defaultTarget = try container.decodeIfPresent(Int.self, forKey: .defaultTarget) ?? fallback.defaultTarget
        self.completionToneEnabled = try container.decodeIfPresent(Bool.self, forKey: .completionToneEnabled) ?? fallback.completionToneEnabled
        self.hapticIntensity = try container.decodeIfPresent(Double.self, forKey: .hapticIntensity) ?? fallback.hapticIntensity
        self.lastMantraID = try container.decodeIfPresent(UUID.self, forKey: .lastMantraID)
        self.hasSeenIntro = try container.decodeIfPresent(Bool.self, forKey: .hasSeenIntro) ?? fallback.hasSeenIntro
        self.malaStyle = try container.decodeIfPresent(MalaStyle.self, forKey: .malaStyle) ?? fallback.malaStyle
    }
}
