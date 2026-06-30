import SwiftUI

extension Color {
    /// Hex initializer (RRGGBB).
    init(hex: UInt32) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: 1
        )
    }

    /// A color that resolves differently in light and dark mode.
    init(light: UInt32, dark: UInt32) {
        self.init(uiColor: UIColor { traits in
            let hex = traits.userInterfaceStyle == .dark ? dark : light
            return UIColor(
                red: CGFloat((hex >> 16) & 0xFF) / 255,
                green: CGFloat((hex >> 8) & 0xFF) / 255,
                blue: CGFloat(hex & 0xFF) / 255,
                alpha: 1
            )
        })
    }
}

/// Japa's visual language: quiet, warm, devotional, abstract. Dark-first because
/// practice often happens in low light or with the screen off; the palette stays
/// calm and legible in both modes.
enum Theme {
    // Surfaces
    static let background = Color(light: 0xF6F0E4, dark: 0x171310)
    static let surface = Color(light: 0xFCF8EF, dark: 0x221B14)
    static let surfaceElevated = Color(light: 0xFFFFFF, dark: 0x2A2219)

    // Accent (muted, dignified gold). In light mode the *bright* role is the
    // deep gold used for text/CTAs (it must read on cream, so it's darker, not
    // lighter); `accent` is the stroke gold. In dark mode both brighten. Tuned
    // for WCAG AA contrast against the surfaces they sit on.
    static let accent = Color(light: 0xA66E22, dark: 0xD9A24B)
    static let accentBright = Color(light: 0x8A5512, dark: 0xE8B567)
    static let accentSoft = Color(light: 0xE3D2B2, dark: 0x4A3A21)

    // Text
    static let textPrimary = Color(light: 0x2A2118, dark: 0xF2EBDD)
    static let textSecondary = Color(light: 0x645840, dark: 0xB0A48E)
    static let textMuted = Color(light: 0x6E6450, dark: 0x847862)

    // Lines
    static let ringTrack = Color(light: 0xE6DCC8, dark: 0x2E2619)
    static let hairline = Color(light: 0xE2D8C4, dark: 0x332A1E)

    // Typography
    static func serif(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .serif)
    }

    static func ui(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .default)
    }

    // Layout
    static let corner: CGFloat = 16
    static let cornerSmall: CGFloat = 13
}

// MARK: - Reusable styling

/// A calm primary action — gold outline on the warm background.
struct OutlineButtonStyle: ButtonStyle {
    var prominent: Bool = true
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Theme.ui(16, weight: .medium))
            .foregroundStyle(prominent ? Theme.accentBright : Theme.textSecondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: Theme.cornerSmall, style: .continuous)
                    .stroke(prominent ? Theme.accent : Theme.hairline, lineWidth: 1)
            )
            .contentShape(Rectangle())
            .opacity(configuration.isPressed ? 0.6 : 1)
            .scaleEffect(configuration.isPressed ? 0.99 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

extension View {
    /// Standard inset card surface.
    func cardSurface() -> some View {
        self
            .background(Theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: Theme.corner, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.corner, style: .continuous)
                    .stroke(Theme.hairline, lineWidth: 1)
            )
    }
}
