import SwiftUI

/// Maps the mala styles' design coordinates (fixed 278×604 canvas, matching
/// the source design's phone-frame viewBox) onto whatever size the practice
/// screen actually renders at. Circles stay circular by using a single
/// average scale for lengths/radii rather than stretching independently.
struct MalaCanvas {
    let size: CGSize
    static let designSize = CGSize(width: 278, height: 604)

    private var scaleX: CGFloat { size.width / Self.designSize.width }
    private var scaleY: CGFloat { size.height / Self.designSize.height }
    /// Average scale used for radii/lengths so shapes stay round while the
    /// canvas still fills the frame edge-to-edge, matching the source's intent.
    var scale: CGFloat { (scaleX + scaleY) / 2 }

    func x(_ v: CGFloat) -> CGFloat { v * scaleX }
    func y(_ v: CGFloat) -> CGFloat { v * scaleY }
    func pt(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: self.x(x), y: self.y(y)) }
    func len(_ v: CGFloat) -> CGFloat { v * scale }

    /// Design-space polar coordinate around `center` (design units), converted to canvas points.
    func polar(cx: CGFloat, cy: CGFloat, radius: CGFloat, degrees: Double) -> CGPoint {
        let a = (degrees - 90) * .pi / 180
        return pt(cx + radius * cos(a), cy + radius * sin(a))
    }
}

/// "N" over "of {target}" — every style's count readout, styled per style.
/// Layout position is expressed as a fraction of the frame's height so it
/// scales with the design's per-style vertical placement.
struct MalaCountBlock: View {
    let count: Int
    let target: Int
    var topFraction: CGFloat
    var numberFont: Font
    var numberColor: Color
    var numberTracking: CGFloat = 0
    var labelColor: Color
    var labelTracking: CGFloat = 3
    var glowColor: Color?
    var glowRadius: CGFloat = 16
    var reduceMotion: Bool = false

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 6) {
                Text("\(count)")
                    .font(numberFont)
                    .tracking(numberTracking)
                    .foregroundStyle(numberColor)
                    .monospacedDigit()
                    .contentTransition(reduceMotion ? .identity : .numericText(value: Double(count)))
                    .shadow(color: glowColor ?? .clear, radius: glowColor == nil ? 0 : glowRadius)
                Text("of \(target)")
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(labelTracking)
                    .textCase(.uppercase)
                    .foregroundStyle(labelColor)
            }
            .frame(maxWidth: .infinity)
            .position(x: geo.size.width / 2, y: geo.size.height * topFraction)
            .animation(reduceMotion ? nil : .easeOut(duration: 0.28), value: count)
        }
        .allowsHitTesting(false)
    }
}

/// "tap to advance" — shown until the first tap on a still-unseen style, matching
/// the design's fading hint. Purely decorative chrome for the picker/board, not
/// part of the real practice screen (which already has its own hint text).
struct MalaTapHint: View {
    var color: Color
    var body: some View {
        GeometryReader { geo in
            Text("tap to advance")
                .font(.system(size: 10, weight: .semibold))
                .tracking(2.6)
                .textCase(.uppercase)
                .foregroundStyle(color)
                .position(x: geo.size.width / 2, y: geo.size.height - 32)
                .malaLoop(duration: 1.6, opacity: 0.32, active: true)
        }
        .allowsHitTesting(false)
    }
}

// MARK: - Idle-motion modifiers

/// A generic "peak and settle" loop: animates from identity to the given
/// scale/rotation/offset/opacity and back, forever. Covers the design's
/// j-breathe / j-pulse / j-sway / j-float / j-sheen / j-twinkle / j-idle
/// keyframes, which are all the same shape (ease-in-out, autoreversing).
private struct MalaLoopModifier: ViewModifier {
    var duration: Double
    var scale: CGFloat = 1
    var rotationDegrees: Double = 0
    var yOffset: CGFloat = 0
    var opacity: Double = 1
    var delay: Double = 0
    var active: Bool

    @State private var peaked = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(peaked ? scale : 1)
            .rotationEffect(.degrees(peaked ? rotationDegrees : 0))
            .offset(y: peaked ? yOffset : 0)
            .opacity(peaked ? opacity : 1)
            .onAppear {
                guard active else { return }
                withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true).delay(delay)) {
                    peaked = true
                }
            }
    }
}

/// Continuous one-direction rotation — the design's j-drift keyframe.
private struct MalaSpinModifier: ViewModifier {
    var duration: Double
    var active: Bool
    @State private var spun = false

    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(spun ? 360 : 0))
            .onAppear {
                guard active else { return }
                withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                    spun = true
                }
            }
    }
}

extension View {
    /// Ease-in-out peak-and-settle loop (breathe/pulse/sway/float/sheen/twinkle/idle).
    func malaLoop(
        duration: Double,
        scale: CGFloat = 1,
        rotationDegrees: Double = 0,
        yOffset: CGFloat = 0,
        opacity: Double = 1,
        delay: Double = 0,
        active: Bool
    ) -> some View {
        modifier(MalaLoopModifier(
            duration: duration, scale: scale, rotationDegrees: rotationDegrees,
            yOffset: yOffset, opacity: opacity, delay: delay, active: active
        ))
    }

    /// Continuous one-direction rotation (drift).
    func malaSpin(duration: Double, active: Bool) -> some View {
        modifier(MalaSpinModifier(duration: duration, active: active))
    }

    /// Position/rotation changes animate smoothly on every tap, matching the
    /// design's `.6s cubic-bezier(.22,1,.36,1)` transition; disabled under Reduce Motion.
    func malaTapTransition<V: Equatable>(_ value: V, reduceMotion: Bool) -> some View {
        animation(reduceMotion ? nil : .interpolatingSpring(stiffness: 170, damping: 20), value: value)
    }
}

/// A slow expanding-and-fading ring — the design's j-ripple keyframe (used by Liquid).
struct MalaRipple: View {
    var color: Color
    var lineWidth: CGFloat = 1.2
    var duration: Double = 2.8
    var delay: Double = 0
    var active: Bool

    @State private var expanded = false

    var body: some View {
        Circle()
            .stroke(color, lineWidth: lineWidth)
            .scaleEffect(expanded ? 2.6 : 0.5)
            .opacity(expanded ? 0 : 0.55)
            .onAppear {
                guard active else { return }
                withAnimation(.easeOut(duration: duration).repeatForever(autoreverses: false).delay(delay)) {
                    expanded = true
                }
            }
    }
}

/// A soft blurred blob drifting slowly — the design's j-fog keyframe.
struct MalaFogBlob: View {
    var color: Color
    var diameter: CGFloat
    var duration: Double
    var active: Bool

    @State private var drifted = false

    var body: some View {
        Circle()
            .fill(RadialGradient(colors: [color, color.opacity(0)], center: .center, startRadius: 0, endRadius: diameter / 2))
            .frame(width: diameter, height: diameter)
            .blur(radius: 14)
            .offset(x: drifted ? 10 : -10, y: drifted ? -12 : 12)
            .scaleEffect(drifted ? 1.08 : 1)
            .onAppear {
                guard active else { return }
                withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true)) {
                    drifted = true
                }
            }
    }
}
