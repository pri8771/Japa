import SwiftUI

// Ring/circular-arrangement styles: beads placed evenly around a circle, the
// "active" bead rotates to the current position each tap. Bulk beads draw via
// Canvas (cheap even at large targets); the one active/foreground element is a
// real animated SwiftUI shape so its motion and glow can animate smoothly.

/// 00 — Classic, full-bleed variant. Used only by the picker (the live app
/// screens keep today's exact BeadRingView-on-Theme.background look for this
/// style — see MalaStyleView).
struct MalaRender_Classic: View {
    let count: Int, target: Int, isComplete: Bool, breathing: Bool, reduceMotion: Bool
    var body: some View {
        GeometryReader { geo in
            let c = MalaCanvas(size: geo.size)
            let cx: CGFloat = 139, cy: CGFloat = 250, r: CGFloat = 104
            let prog = Double(count) / Double(target)
            ZStack {
                RadialGradient(colors: [Color(hex: 0x1b1815), Color(hex: 0x0b0a09)], center: UnitPoint(x: 0.5, y: 0.32), startRadius: 0, endRadius: c.len(340))
                ZStack {
                    Circle().stroke(Color(hex: 0x3a352b).opacity(0.55), lineWidth: c.len(1.6))
                    Circle()
                        .trim(from: 0, to: max(0.0008, prog))
                        .stroke(Color(hex: 0xf0c179).opacity(0.1 + prog * 0.35), style: StrokeStyle(lineWidth: c.len(8), lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .blur(radius: c.len(5))
                    Circle()
                        .trim(from: 0, to: max(0.0008, prog))
                        .stroke(Color(hex: 0xf4d29a), style: StrokeStyle(lineWidth: c.len(2.6), lineCap: .round))
                        .rotationEffect(.degrees(-90))
                }
                .frame(width: c.len(r * 2), height: c.len(r * 2))
                .position(c.pt(cx, cy))
                .malaLoop(duration: 5.5, scale: 1.02, active: breathing && !reduceMotion)

                let dotPt = c.polar(cx: cx, cy: cy, radius: r, degrees: prog * 360)
                ZStack {
                    Circle().fill(Color(hex: 0xffdf9e).opacity(0.18)).frame(width: c.len(22), height: c.len(22))
                    Circle().fill(Color(hex: 0xffe9c6)).frame(width: c.len(9), height: c.len(9))
                }
                .position(dotPt)
                .malaTapTransition(count, reduceMotion: reduceMotion)

                MalaCountBlock(
                    count: count, target: target, topFraction: 0.43,
                    numberFont: .system(size: c.len(84), weight: .light, design: .serif),
                    numberColor: Color(hex: 0xf2dcb6),
                    labelColor: Color(hex: 0x9a8256)
                )
            }
        }
    }
}

/// 01 — Ultra Minimal.
struct MalaRender_UltraMinimal: View {
    let count: Int, target: Int, isComplete: Bool, breathing: Bool, reduceMotion: Bool
    var body: some View {
        GeometryReader { geo in
            let c = MalaCanvas(size: geo.size)
            let cx: CGFloat = 139, cy: CGFloat = 250, r: CGFloat = 112
            let step = 360.0 / Double(target)
            ZStack {
                Color(hex: 0xf6f4ef)
                Canvas { ctx, _ in
                    for i in 0..<target {
                        let p = c.polar(cx: cx, cy: cy, radius: r, degrees: Double(i) * step)
                        let dotR: CGFloat = i < count ? c.len(2.5) : c.len(2)
                        ctx.fill(Path(ellipseIn: CGRect(x: p.x - dotR, y: p.y - dotR, width: dotR * 2, height: dotR * 2)),
                                 with: .color(Color(hex: 0x161512).opacity(i < count ? 0.5 : 0.17)))
                    }
                }
                let activePt = c.polar(cx: cx, cy: cy, radius: r, degrees: Double(count - 1) * step)
                ZStack {
                    Circle().fill(Color(hex: 0xb45309).opacity(0.15)).frame(width: c.len(26), height: c.len(26))
                    Circle().fill(Color(hex: 0xb45309)).frame(width: c.len(12), height: c.len(12))
                }
                .position(activePt)
                .malaTapTransition(count, reduceMotion: reduceMotion)

                MalaCountBlock(
                    count: count, target: target, topFraction: 0.45,
                    numberFont: .system(size: c.len(84), weight: .light),
                    numberColor: Color(hex: 0x161512), numberTracking: -3,
                    labelColor: Color(hex: 0xb0a99d)
                )
            }
        }
    }
}

/// 04 — Modern Luxury: onyx & gold loop.
struct MalaRender_ModernLuxury: View {
    let count: Int, target: Int, isComplete: Bool, breathing: Bool, reduceMotion: Bool
    var body: some View {
        GeometryReader { geo in
            let c = MalaCanvas(size: geo.size)
            let cx: CGFloat = 139, cy: CGFloat = 252, R: CGFloat = 106
            let step = 360.0 / Double(target)
            ZStack {
                RadialGradient(colors: [Color(hex: 0x1b1712), Color(hex: 0x0a0807)], center: UnitPoint(x: 0.5, y: 0.26), startRadius: 0, endRadius: c.len(320))
                Circle().stroke(Color(hex: 0x8a6a2e).opacity(0.7), lineWidth: c.len(1.4)).frame(width: c.len(R * 2), height: c.len(R * 2)).position(c.pt(cx, cy))
                Canvas { ctx, _ in
                    for i in 0..<target {
                        let p = c.polar(cx: cx, cy: cy, radius: R, degrees: Double(i) * step)
                        let rad = c.len(5.4)
                        ctx.fill(Path(ellipseIn: CGRect(x: p.x - rad, y: p.y - rad, width: rad * 2, height: rad * 2)),
                                 with: .color(Color(hex: 0x22242c)))
                    }
                }
                let activeAngle = Double(count - 1) * step
                let activePt = c.polar(cx: cx, cy: cy, radius: R, degrees: activeAngle)
                ZStack {
                    Circle().fill(RadialGradient(colors: [Color(hex: 0xf6e2b0).opacity(0.8), Color(hex: 0xc79a45).opacity(0)], center: .center, startRadius: 0, endRadius: c.len(17)))
                        .frame(width: c.len(34), height: c.len(34))
                        .malaLoop(duration: 3.4, scale: 1.1, active: !reduceMotion)
                    Circle().fill(Color(hex: 0x5a5a63)).frame(width: c.len(19), height: c.len(19))
                    Circle().fill(Color.white.opacity(0.85)).frame(width: c.len(5.2), height: c.len(5.2)).offset(x: -c.len(3), y: -c.len(3.4))
                }
                .position(activePt)
                .malaTapTransition(count, reduceMotion: reduceMotion)
                .rotationEffect(.degrees(activeAngle), anchor: UnitPoint(x: 0.5, y: 0.5))

                RadialGradient(colors: [.clear, Color.black.opacity(0.55)], center: UnitPoint(x: 0.5, y: 0.42), startRadius: c.len(90), endRadius: c.len(220))
                    .allowsHitTesting(false)

                MalaCountBlock(
                    count: count, target: target, topFraction: 0.4,
                    numberFont: .system(size: c.len(74), weight: .light, design: .serif),
                    numberColor: Color(hex: 0xecd39a),
                    labelColor: Color(hex: 0x9c8452), labelTracking: 5
                )
            }
        }
    }
}

/// 05 — Abstract & Atmospheric: orbs adrift in fog.
struct MalaRender_AbstractAtmospheric: View {
    let count: Int, target: Int, isComplete: Bool, breathing: Bool, reduceMotion: Bool
    var body: some View {
        GeometryReader { geo in
            let c = MalaCanvas(size: geo.size)
            let cx: CGFloat = 139, cy: CGFloat = 268, R: CGFloat = 104
            let step = 360.0 / Double(target)
            ZStack {
                RadialGradient(colors: [Color(hex: 0x123840), Color(hex: 0x08171b), Color(hex: 0x051013)], center: UnitPoint(x: 0.5, y: 0.42), startRadius: 0, endRadius: c.len(360))
                MalaFogBlob(color: Color(hex: 0x287882).opacity(0.5), diameter: c.len(220), duration: 16, active: !reduceMotion).position(c.pt(20, 108))
                MalaFogBlob(color: Color(hex: 0x3c96a0).opacity(0.32), diameter: c.len(200), duration: 20, active: !reduceMotion).position(c.pt(150, 48))
                MalaFogBlob(color: Color(hex: 0x1e5a6e).opacity(0.4), diameter: c.len(240), duration: 24, active: !reduceMotion).position(c.pt(75, 350))

                ZStack {
                    Canvas { ctx, _ in
                        for i in 0..<target {
                            let p = c.polar(cx: cx, cy: cy, radius: R, degrees: Double(i) * step)
                            let rad = c.len(3.6)
                            ctx.fill(Path(ellipseIn: CGRect(x: p.x - rad, y: p.y - rad, width: rad * 2, height: rad * 2)),
                                     with: .color(Color(hex: 0x4fc3d4).opacity(0.85)))
                        }
                    }
                    let activePt = c.polar(cx: cx, cy: cy, radius: R, degrees: Double(count - 1) * step)
                    ZStack {
                        Circle().fill(Color(hex: 0x8ef0ff).opacity(0.55)).frame(width: c.len(32), height: c.len(32))
                            .malaLoop(duration: 3, scale: 1.16, active: !reduceMotion)
                        Circle().fill(Color.white).frame(width: c.len(13), height: c.len(13))
                    }
                    .position(activePt)
                    .malaTapTransition(count, reduceMotion: reduceMotion)
                }
                .malaSpin(duration: 90, active: !reduceMotion)

                MalaCountBlock(
                    count: count, target: target, topFraction: 0.44,
                    numberFont: .system(size: c.len(62), weight: .ultraLight),
                    numberColor: Color(hex: 0xe6feff), numberTracking: 1,
                    labelColor: Color(hex: 0x7fb9c2), labelTracking: 5,
                    glowColor: Color(hex: 0x78e6f0).opacity(0.5), glowRadius: 18
                )
            }
        }
    }
}

/// 10 — Sculptural Monument.
struct MalaRender_SculpturalMonument: View {
    let count: Int, target: Int, isComplete: Bool, breathing: Bool, reduceMotion: Bool
    var body: some View {
        GeometryReader { geo in
            let c = MalaCanvas(size: geo.size)
            let cx: CGFloat = 139, cy: CGFloat = 204, R: CGFloat = 89
            let prog = Double(count) / Double(target)
            ZStack {
                LinearGradient(colors: [Color(hex: 0xece7de), Color(hex: 0xd6ccbe)], startPoint: .top, endPoint: .bottom)
                Ellipse().fill(Color(hex: 0x6f6554).opacity(0.24)).frame(width: c.len(R * 1.6), height: c.len(26)).blur(radius: c.len(4)).position(c.pt(cx, cy + R + 14))
                Circle().stroke(Color(hex: 0xc7bdac).opacity(0.5), lineWidth: c.len(2)).frame(width: c.len((R + 16) * 2), height: c.len((R + 16) * 2)).position(c.pt(cx, cy))
                Circle()
                    .trim(from: 0, to: max(0.0008, prog))
                    .stroke(Color(hex: 0x4a463d), style: StrokeStyle(lineWidth: c.len(3), lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: c.len((R + 16) * 2), height: c.len((R + 16) * 2))
                    .position(c.pt(cx, cy))
                Circle()
                    .fill(RadialGradient(colors: [Color(hex: 0xfbf8f2), Color(hex: 0xe0d7c9), Color(hex: 0xbcb2a1), Color(hex: 0x8c8171)],
                                          center: UnitPoint(x: 0.38, y: 0.30), startRadius: 0, endRadius: c.len(R)))
                    .overlay(Circle().stroke(Color.white.opacity(0.28), lineWidth: c.len(1)))
                    .frame(width: c.len(R * 2), height: c.len(R * 2))
                    .position(c.pt(cx, cy))
                    .rotationEffect(.degrees(prog * 360))
                    .malaTapTransition(count, reduceMotion: reduceMotion)

                MalaCountBlock(
                    count: count, target: target, topFraction: 0.63,
                    numberFont: .system(size: c.len(102), weight: .light, design: .serif),
                    numberColor: Color(hex: 0x3a362e), numberTracking: -1,
                    labelColor: Color(hex: 0x9c9282), labelTracking: 6
                )
            }
        }
    }
}

/// 11 — Liquid: water droplets on a still pool.
struct MalaRender_Liquid: View {
    let count: Int, target: Int, isComplete: Bool, breathing: Bool, reduceMotion: Bool
    var body: some View {
        GeometryReader { geo in
            let c = MalaCanvas(size: geo.size)
            let cx: CGFloat = 139, cy: CGFloat = 262, R: CGFloat = 100
            let step = 360.0 / Double(target)
            ZStack {
                RadialGradient(colors: [Color(hex: 0x17506b), Color(hex: 0x0a2740), Color(hex: 0x061a2c)], center: UnitPoint(x: 0.5, y: 0.30), startRadius: 0, endRadius: c.len(360))
                Canvas { ctx, _ in
                    for i in 0..<target {
                        let p = c.polar(cx: cx, cy: cy, radius: R, degrees: Double(i) * step)
                        let rad = c.len(3.8)
                        ctx.fill(Path(ellipseIn: CGRect(x: p.x - rad, y: p.y - rad, width: rad * 2, height: rad * 2)),
                                 with: .color(Color(hex: 0x5fb6d6).opacity(0.9)))
                    }
                }
                let activePt = c.polar(cx: cx, cy: cy, radius: R, degrees: Double(count - 1) * step)
                ZStack {
                    MalaRipple(color: Color(hex: 0xbfeeff), duration: 2.8, active: !reduceMotion)
                        .frame(width: c.len(18), height: c.len(18))
                    MalaRipple(color: Color(hex: 0xbfeeff), duration: 2.8, delay: 1.4, active: !reduceMotion)
                        .frame(width: c.len(18), height: c.len(18))
                    Circle().fill(Color(hex: 0x9fe4f5)).frame(width: c.len(19), height: c.len(19))
                    Ellipse().fill(Color.white.opacity(0.85)).frame(width: c.len(5.2), height: c.len(3.6)).offset(x: -c.len(3), y: -c.len(3.4))
                }
                .position(activePt)
                .malaTapTransition(count, reduceMotion: reduceMotion)

                MalaCountBlock(
                    count: count, target: target, topFraction: 0.43,
                    numberFont: .system(size: c.len(64), weight: .ultraLight),
                    numberColor: Color(hex: 0xdff4ff), numberTracking: 1,
                    labelColor: Color(hex: 0x78b4cc), labelTracking: 5,
                    glowColor: Color(hex: 0x78d2f0).opacity(0.5)
                )
            }
        }
    }
}

/// 12 — Crystalline: faceted gems.
struct MalaRender_Crystalline: View {
    let count: Int, target: Int, isComplete: Bool, breathing: Bool, reduceMotion: Bool
    var body: some View {
        GeometryReader { geo in
            let c = MalaCanvas(size: geo.size)
            let cx: CGFloat = 139, cy: CGFloat = 258, R: CGFloat = 102
            let step = 360.0 / Double(target)
            ZStack {
                RadialGradient(colors: [Color(hex: 0x2b2740), Color(hex: 0x14121f)], center: UnitPoint(x: 0.5, y: 0.28), startRadius: 0, endRadius: c.len(340))
                Canvas { ctx, _ in
                    for i in 0..<target {
                        let p = c.polar(cx: cx, cy: cy, radius: R, degrees: Double(i) * step)
                        let s = c.len(4.4)
                        var path = Path()
                        path.move(to: CGPoint(x: p.x, y: p.y - s))
                        path.addLine(to: CGPoint(x: p.x + s, y: p.y))
                        path.addLine(to: CGPoint(x: p.x, y: p.y + s))
                        path.addLine(to: CGPoint(x: p.x - s, y: p.y))
                        path.closeSubpath()
                        ctx.fill(path, with: .color(Color(hex: 0xa9c4e6)))
                    }
                }
                let activeAngle = Double(count - 1) * step
                let activePt = c.polar(cx: cx, cy: cy, radius: R, degrees: activeAngle)
                ZStack {
                    Circle().fill(RadialGradient(colors: [Color.white, Color(hex: 0xd6c2ff).opacity(0.9), Color(hex: 0x8a7fd6).opacity(0)], center: .center, startRadius: 0, endRadius: c.len(15)))
                        .frame(width: c.len(30), height: c.len(30))
                        .malaLoop(duration: 2.6, opacity: 0.4, active: !reduceMotion)
                    Diamond().fill(Color(hex: 0xeaf4ff)).frame(width: c.len(16), height: c.len(16))
                }
                .position(activePt)
                .malaTapTransition(count, reduceMotion: reduceMotion)

                MalaCountBlock(
                    count: count, target: target, topFraction: 0.4,
                    numberFont: .system(size: c.len(66), weight: .light, design: .serif),
                    numberColor: Color(hex: 0xeaf1ff),
                    labelColor: Color(hex: 0x9a93c4), labelTracking: 5
                )
            }
        }
    }
}

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        p.closeSubpath()
        return p
    }
}

/// 13 — Celestial: planets on a slow orbit through starlight.
struct MalaRender_Celestial: View {
    let count: Int, target: Int, isComplete: Bool, breathing: Bool, reduceMotion: Bool
    var body: some View {
        GeometryReader { geo in
            let c = MalaCanvas(size: geo.size)
            let cx: CGFloat = 139, cy: CGFloat = 262, R: CGFloat = 100
            let step = 360.0 / Double(target)
            ZStack {
                RadialGradient(colors: [Color(hex: 0x1c2148), Color(hex: 0x0a0d20), Color(hex: 0x05060f)], center: UnitPoint(x: 0.5, y: 0.26), startRadius: 0, endRadius: c.len(380))
                Canvas { ctx, size in
                    for i in 0..<46 {
                        let x = CGFloat((i * 53) % 278) / 278 * size.width
                        let y = CGFloat((i * 97) % 604) / 604 * size.height
                        let s: CGFloat = i % 3 == 0 ? c.len(1.3) : c.len(0.8)
                        ctx.fill(Path(ellipseIn: CGRect(x: x - s, y: y - s, width: s * 2, height: s * 2)),
                                 with: .color(Color(hex: 0xdfe6ff).opacity(0.3 + Double((i * 13) % 5) / 10)))
                    }
                }
                Circle().stroke(Color(hex: 0x4a5a9a).opacity(0.4), style: StrokeStyle(lineWidth: c.len(0.6), dash: [c.len(1), c.len(4)]))
                    .frame(width: c.len(R * 2), height: c.len(R * 2)).position(c.pt(cx, cy))
                ZStack {
                    Canvas { ctx, _ in
                        for i in 0..<target {
                            let p = c.polar(cx: cx, cy: cy, radius: R, degrees: Double(i) * step)
                            let rad = c.len(2.6)
                            ctx.fill(Path(ellipseIn: CGRect(x: p.x - rad, y: p.y - rad, width: rad * 2, height: rad * 2)),
                                     with: .color(Color(hex: 0xb9c6f0)))
                        }
                    }
                    let activePt = c.polar(cx: cx, cy: cy, radius: R, degrees: Double(count - 1) * step)
                    ZStack {
                        Circle().fill(RadialGradient(colors: [Color(hex: 0xfff6e0), Color(hex: 0xffd27a).opacity(0.95), Color(hex: 0xc8862f).opacity(0)], center: .center, startRadius: 0, endRadius: c.len(16)))
                            .frame(width: c.len(32), height: c.len(32))
                            .malaLoop(duration: 3.4, scale: 1.14, active: !reduceMotion)
                        Circle().fill(Color(hex: 0xffe6a6)).frame(width: c.len(11), height: c.len(11))
                    }
                    .position(activePt)
                    .malaTapTransition(count, reduceMotion: reduceMotion)
                }
                .malaSpin(duration: 120, active: !reduceMotion)

                MalaCountBlock(
                    count: count, target: target, topFraction: 0.44,
                    numberFont: .system(size: c.len(60), weight: .ultraLight),
                    numberColor: Color(hex: 0xeef2ff), numberTracking: 2,
                    labelColor: Color(hex: 0x8b96c8), labelTracking: 6,
                    glowColor: Color(hex: 0x96aaff).opacity(0.5)
                )
            }
        }
    }
}

/// 15 — Botanical: rudraksha seeds on a living vine.
struct MalaRender_Botanical: View {
    let count: Int, target: Int, isComplete: Bool, breathing: Bool, reduceMotion: Bool
    var body: some View {
        GeometryReader { geo in
            let c = MalaCanvas(size: geo.size)
            let cx: CGFloat = 139, cy: CGFloat = 286, R: CGFloat = 112
            let step = 360.0 / Double(target)
            ZStack {
                RadialGradient(colors: [Color(hex: 0x6f7a45), Color(hex: 0x47502a), Color(hex: 0x333a1e)], center: UnitPoint(x: 0.5, y: 0.26), startRadius: 0, endRadius: c.len(340))
                Circle().stroke(Color(hex: 0x6b6a3a).opacity(0.4), lineWidth: c.len(1)).frame(width: c.len(R * 2), height: c.len(R * 2)).position(c.pt(cx, cy))
                ZStack {
                    Canvas { ctx, _ in
                        for i in 0..<target {
                            let p = c.polar(cx: cx, cy: cy, radius: R, degrees: Double(i) * step)
                            let rad = c.len(5.2)
                            ctx.fill(Path(ellipseIn: CGRect(x: p.x - rad, y: p.y - rad, width: rad * 2, height: rad * 2)),
                                     with: .color(Color(hex: 0x8a6a33)))
                        }
                    }
                    let activePt = c.polar(cx: cx, cy: cy, radius: R, degrees: Double(count - 1) * step)
                    ZStack {
                        Circle().fill(Color(hex: 0xa97f3c)).frame(width: c.len(19), height: c.len(19))
                        Ellipse().fill(Color.white.opacity(0.4)).frame(width: c.len(5.2), height: c.len(3.6)).offset(x: -c.len(3), y: -c.len(3.4))
                    }
                    .position(activePt)
                    .malaTapTransition(count, reduceMotion: reduceMotion)
                }
                .malaLoop(duration: 8, rotationDegrees: 2, active: !reduceMotion)

                MalaCountBlock(
                    count: count, target: target, topFraction: 0.63,
                    numberFont: .system(size: c.len(62), design: .serif),
                    numberColor: Color(hex: 0xece2c0),
                    labelColor: Color(hex: 0xb7b184), labelTracking: 4
                )
            }
        }
    }
}

/// 16 — Temple Brass: aged engraved metal.
struct MalaRender_TempleBrass: View {
    let count: Int, target: Int, isComplete: Bool, breathing: Bool, reduceMotion: Bool
    var body: some View {
        GeometryReader { geo in
            let c = MalaCanvas(size: geo.size)
            let cx: CGFloat = 139, cy: CGFloat = 256, R: CGFloat = 102
            let step = 360.0 / Double(target)
            ZStack {
                RadialGradient(colors: [Color(hex: 0x3a2f1c), Color(hex: 0x1a140b)], center: UnitPoint(x: 0.5, y: 0.28), startRadius: 0, endRadius: c.len(340))
                Circle().stroke(Color(hex: 0x5a4a24).opacity(0.6), lineWidth: c.len(1)).frame(width: c.len(R * 2), height: c.len(R * 2)).position(c.pt(cx, cy))
                Canvas { ctx, _ in
                    for i in 0..<target {
                        let p = c.polar(cx: cx, cy: cy, radius: R, degrees: Double(i) * step)
                        let rad = c.len(5)
                        ctx.fill(Path(ellipseIn: CGRect(x: p.x - rad, y: p.y - rad, width: rad * 2, height: rad * 2)),
                                 with: .color(Color(hex: 0xc79a3e)))
                    }
                }
                let activeAngle = Double(count - 1) * step
                let activePt = c.polar(cx: cx, cy: cy, radius: R, degrees: activeAngle)
                ZStack {
                    Circle().fill(Color(hex: 0xf0c766).opacity(0.14)).frame(width: c.len(32), height: c.len(32))
                        .malaLoop(duration: 3, opacity: 0.5, active: !reduceMotion)
                    Circle().fill(RadialGradient(colors: [Color(hex: 0xfff4c8), Color(hex: 0xe0b453), Color(hex: 0x96702c), Color(hex: 0x4d3714)], center: UnitPoint(x: 0.34, y: 0.26), startRadius: 0, endRadius: c.len(10)))
                        .frame(width: c.len(20), height: c.len(20))
                    Circle().fill(Color(hex: 0xfff8dc).opacity(0.85)).frame(width: c.len(4.8), height: c.len(4.8)).offset(x: -c.len(3.2), y: -c.len(3.6))
                        .malaLoop(duration: 3, opacity: 0.3, active: !reduceMotion)
                }
                .position(activePt)
                .malaTapTransition(count, reduceMotion: reduceMotion)

                MalaCountBlock(
                    count: count, target: target, topFraction: 0.4,
                    numberFont: .system(size: c.len(64), design: .serif),
                    numberColor: Color(hex: 0xf0cf86),
                    labelColor: Color(hex: 0xa5813f), labelTracking: 5
                )
            }
        }
    }
}
