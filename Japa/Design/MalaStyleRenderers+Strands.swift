import SwiftUI

// Strand-arrangement styles: beads laid along a line that slides so the
// current bead sits in a fixed on-screen spot.
//
// The visible beads are individual SwiftUI views (not Canvas) in a window
// around the active bead, so the one-step slide on each tap actually
// animates — a Canvas redraw snaps instantly and can't. The window is wide
// enough to cover the screen plus one step of travel; beads entering or
// leaving do so offscreen. The final (target) bead renders red so the
// practitioner can see the round's end approaching.

/// 02 — Warm & Tactile: sandalwood strand sliding through warm light.
struct MalaRender_WarmTactile: View {
    let count: Int, target: Int, isComplete: Bool, breathing: Bool, reduceMotion: Bool
    var body: some View {
        GeometryReader { geo in
            let c = MalaCanvas(size: geo.size)
            let y: CGFloat = 270, sp: CGFloat = 34
            let active = count - 1
            ZStack {
                RadialGradient(colors: [Color(hex: 0xf5e8d3), Color(hex: 0xe2ccaa)], center: UnitPoint(x: 0.5, y: 0.2), startRadius: 0, endRadius: c.len(300))
                Ellipse().fill(Color(hex: 0x5a3a1e).opacity(0.2)).frame(width: c.len(70), height: c.len(15)).position(c.pt(139, y + 22))
                Rectangle().fill(Color(hex: 0x6b4a2b).opacity(0.5))
                    .frame(width: geo.size.width + c.len(120), height: c.len(5))
                    .position(x: geo.size.width / 2, y: c.y(y))

                ForEach(strandWindow(active: active, target: target, halfWidth: 8), id: \.self) { idx in
                    ZStack {
                        Circle()
                            .fill(idx == target - 1 ? Color.malaFinalBead : Color(hex: 0x7c4a24))
                            .frame(width: c.len(32), height: c.len(32))
                        Ellipse().fill(Color.white.opacity(0.26))
                            .frame(width: c.len(10), height: c.len(6.8))
                            .offset(x: -c.len(4.5), y: -c.len(5.5))
                    }
                    .position(x: c.x(139) + c.x(sp) * CGFloat(idx - active), y: c.y(y))
                    .malaTapTransition(count, reduceMotion: reduceMotion)
                }

                // Fixed warm spotlight + the settled active bead at center.
                Circle()
                    .fill(active == target - 1 ? Color.malaFinalBead : Color(hex: 0x7c4a24))
                    .frame(width: c.len(41), height: c.len(41)).position(c.pt(139, y))
                Ellipse().fill(Color.white.opacity(0.3)).frame(width: c.len(13), height: c.len(8.8)).position(c.pt(133, y - 7))
                Circle().fill(RadialGradient(colors: [Color(hex: 0xfff6e8).opacity(0.6), Color(hex: 0xfff6e8).opacity(0.14), Color(hex: 0xfff6e8).opacity(0)], center: .center, startRadius: 0, endRadius: c.len(30)))
                    .frame(width: c.len(60), height: c.len(60)).position(c.pt(139, y)).blendMode(.screen)

                MalaCountBlock(
                    count: count, target: target, topFraction: 0.62,
                    numberFont: .custom("Georgia", size: c.len(70)),
                    numberColor: Color(hex: 0x5b3720),
                    labelColor: Color(hex: 0xa07a55), labelTracking: 3
                )
            }
            .clipped()
        }
    }
}

/// 03 — Softly Spiritual: ascending light through dusk.
struct MalaRender_SoftlySpiritual: View {
    let count: Int, target: Int, isComplete: Bool, breathing: Bool, reduceMotion: Bool
    var body: some View {
        GeometryReader { geo in
            let c = MalaCanvas(size: geo.size)
            let x: CGFloat = 139, cy: CGFloat = 296, sp: CGFloat = 30
            let active = count - 1
            ZStack {
                RadialGradient(colors: [Color(hex: 0x4c3b66), Color(hex: 0x241a34), Color(hex: 0x1a1327)], center: UnitPoint(x: 0.5, y: 0.34), startRadius: 0, endRadius: c.len(400))

                ForEach(strandWindow(active: active, target: target, halfWidth: 14), id: \.self) { idx in
                    ZStack {
                        Circle().fill(RadialGradient(colors: [Color(hex: 0xf6d9c0).opacity(0.5), Color(hex: 0xd98ba0).opacity(0.18), Color(hex: 0xd98ba0).opacity(0)], center: .center, startRadius: 0, endRadius: c.len(13)))
                            .frame(width: c.len(26), height: c.len(26))
                        Circle()
                            .fill(idx == target - 1 ? Color.malaFinalBead : Color(hex: 0xf0c39c))
                            .frame(width: c.len(13), height: c.len(13))
                    }
                    .position(x: c.x(x), y: c.y(cy) + c.y(sp) * CGFloat(idx - active))
                    .malaTapTransition(count, reduceMotion: reduceMotion)
                }

                Circle().fill(RadialGradient(colors: [Color(hex: 0xffe9d6).opacity(0.85), Color(hex: 0xf3b98f).opacity(0.3), Color(hex: 0xf3b98f).opacity(0)], center: .center, startRadius: 0, endRadius: c.len(30)))
                    .frame(width: c.len(60), height: c.len(60))
                    .position(c.pt(x, cy))
                    .malaLoop(duration: 3.6, scale: 1.22, opacity: 0.85, active: !reduceMotion)

                MalaCountBlock(
                    count: count, target: target, topFraction: 0.83,
                    numberFont: .system(size: c.len(76), weight: .light, design: .serif),
                    numberColor: Color(hex: 0xf6dcc4),
                    labelColor: Color(hex: 0xc79a94), labelTracking: 4
                )
            }
            .clipped()
        }
    }
}

/// 08 — Dark & Meditative: one ember handing off between beads.
struct MalaRender_DarkMeditative: View {
    let count: Int, target: Int, isComplete: Bool, breathing: Bool, reduceMotion: Bool
    var body: some View {
        GeometryReader { geo in
            let c = MalaCanvas(size: geo.size)
            let x: CGFloat = 139, cy: CGFloat = 300, sp: CGFloat = 26
            let active = count - 1
            ZStack {
                RadialGradient(colors: [Color(hex: 0x0e0b08), Color.black], center: UnitPoint(x: 0.5, y: 0.46), startRadius: 0, endRadius: c.len(400))

                ForEach(strandWindow(active: active, target: target, halfWidth: 14), id: \.self) { idx in
                    Circle()
                        .fill(idx == target - 1 ? Color.malaFinalBead.opacity(0.85) : Color(hex: 0x28211a))
                        .frame(width: c.len(12), height: c.len(12))
                        .position(x: c.x(x), y: c.y(cy) + c.y(sp) * CGFloat(idx - active))
                        .malaTapTransition(count, reduceMotion: reduceMotion)
                }

                Circle().fill(RadialGradient(colors: [Color(hex: 0xffd9a0).opacity(0.95), Color(hex: 0xe07d2a).opacity(0.5), Color(hex: 0xe07d2a).opacity(0)], center: .center, startRadius: 0, endRadius: c.len(34)))
                    .frame(width: c.len(68), height: c.len(68))
                    .position(c.pt(x, cy))
                    .malaLoop(duration: 3.8, scale: 1.1, opacity: 0.8, active: !reduceMotion)
                Circle().fill(RadialGradient(colors: [Color(hex: 0xfff1d4), Color(hex: 0xf0a544), Color(hex: 0xc96a1e)], center: UnitPoint(x: 0.4, y: 0.34), startRadius: 0, endRadius: c.len(7)))
                    .frame(width: c.len(14), height: c.len(14))
                    .position(c.pt(x, cy))

                MalaCountBlock(
                    count: count, target: target, topFraction: 0.75,
                    numberFont: .system(size: c.len(52), weight: .light),
                    numberColor: Color(hex: 0xe79a4e), numberTracking: 1,
                    labelColor: Color(hex: 0x8a6234), labelTracking: 5,
                    glowColor: Color(hex: 0xe07d2a).opacity(0.55)
                )
            }
            .clipped()
        }
    }
}

/// 09 — Light & Airy: weightless pearls at sunrise.
struct MalaRender_LightAiry: View {
    let count: Int, target: Int, isComplete: Bool, breathing: Bool, reduceMotion: Bool
    var body: some View {
        GeometryReader { geo in
            let c = MalaCanvas(size: geo.size)
            let y: CGFloat = 302, sp: CGFloat = 30
            let active = count - 1
            ZStack {
                LinearGradient(colors: [Color(hex: 0xfde8d4), Color(hex: 0xf6dbe0), Color(hex: 0xdfeaf4)], startPoint: .top, endPoint: .bottom)

                ForEach(strandWindow(active: active, target: target, halfWidth: 8), id: \.self) { idx in
                    ZStack {
                        Circle()
                            .fill(idx == target - 1 ? Color.malaFinalBead.opacity(0.9) : Color(hex: 0xfce7dd))
                            .frame(width: c.len(26), height: c.len(26))
                        Ellipse().fill(Color.white.opacity(0.7))
                            .frame(width: c.len(9), height: c.len(6))
                            .offset(x: -c.len(4), y: -c.len(5))
                    }
                    .position(x: c.x(139) + c.x(sp) * CGFloat(idx - active), y: c.y(y))
                    .malaTapTransition(count, reduceMotion: reduceMotion)
                }

                Circle().stroke(Color.white.opacity(0.5), lineWidth: c.len(2)).frame(width: c.len(52), height: c.len(52))
                    .position(c.pt(139, 264))
                    .malaLoop(duration: 3.4, scale: 1.22, opacity: 0.85, active: !reduceMotion)
                ZStack {
                    Circle()
                        .fill(active == target - 1 ? Color.malaFinalBead.opacity(0.9) : Color(hex: 0xfff0ea))
                        .frame(width: c.len(32), height: c.len(32))
                    Ellipse().fill(Color.white.opacity(0.85)).frame(width: c.len(11), height: c.len(7.2)).offset(x: -c.len(5), y: -c.len(6))
                }
                .position(c.pt(139, 264))
                .malaLoop(duration: 4.5, yOffset: -c.len(7), active: !reduceMotion)

                MalaCountBlock(
                    count: count, target: target, topFraction: 0.3,
                    numberFont: .system(size: c.len(68), weight: .ultraLight),
                    numberColor: Color(hex: 0x6b5560),
                    labelColor: Color(hex: 0xb598a0), labelTracking: 5
                )
            }
            .clipped()
        }
    }
}

/// The visible bead-index window around the active bead. Clamped to the real
/// bead range and guaranteed non-empty (count 0 → active -1 still yields a
/// valid leading window).
func strandWindow(active: Int, target: Int, halfWidth: Int) -> ClosedRange<Int> {
    let lower = max(0, active - halfWidth)
    let upper = min(target - 1, active + halfWidth)
    return lower...max(lower, upper)
}

/// 14 — Zen Ink: sumi-e ink dots along an open enso.
struct MalaRender_ZenInk: View {
    let count: Int, target: Int, isComplete: Bool, breathing: Bool, reduceMotion: Bool
    var body: some View {
        GeometryReader { geo in
            let c = MalaCanvas(size: geo.size)
            let cx: CGFloat = 139, cy: CGFloat = 256, R: CGFloat = 98
            let a0 = -160.0, span = 320.0
            let step = target > 1 ? span / Double(target - 1) : 0
            ZStack {
                RadialGradient(colors: [Color(hex: 0xf3ecdd), Color(hex: 0xe5dbc5)], center: UnitPoint(x: 0.3, y: 0.22), startRadius: 0, endRadius: c.len(300))
                Path { p in
                    p.addArc(center: c.pt(cx, cy), radius: c.len(R), startAngle: .degrees(a0), endAngle: .degrees(a0 + Double(target - 1) * step), clockwise: false)
                }
                .stroke(Color(hex: 0x1a1712).opacity(0.14), style: StrokeStyle(lineWidth: c.len(2.5), lineCap: .round))
                Canvas { ctx, _ in
                    for i in 0..<target {
                        let ang = a0 + Double(i) * step
                        let p = c.polar(cx: cx, cy: cy, radius: R, degrees: ang)
                        let rad: CGFloat = i < count ? c.len(3.4) : c.len(2.4)
                        let color: Color = i == target - 1
                            ? .malaFinalBead
                            : Color(hex: 0x1a1712).opacity(i < count ? 0.9 : 0.3)
                        ctx.fill(Path(ellipseIn: CGRect(x: p.x - rad, y: p.y - rad, width: rad * 2, height: rad * 2)),
                                 with: .color(color))
                    }
                }
                let aPt = c.polar(cx: cx, cy: cy, radius: R, degrees: a0 + Double(count - 1) * step)
                ZStack {
                    Circle().fill(Color(hex: 0x1a1712).opacity(0.1)).frame(width: c.len(22), height: c.len(22))
                    Circle().fill(Color(hex: 0x0f0d0a)).frame(width: c.len(10), height: c.len(10))
                }
                .position(aPt)
                .malaTapTransition(count, reduceMotion: reduceMotion)

                MalaCountBlock(
                    count: count, target: target, topFraction: 0.41,
                    numberFont: .system(size: c.len(66), weight: .light, design: .serif).italic(),
                    numberColor: Color(hex: 0x1a1712),
                    labelColor: Color(hex: 0x8a8069), labelTracking: 5
                )
            }
        }
    }
}

/// 18 — Aurora: a light node gliding an aurora ribbon.
struct MalaRender_Aurora: View {
    let count: Int, target: Int, isComplete: Bool, breathing: Bool, reduceMotion: Bool
    private func px(_ t: CGFloat) -> CGFloat { 18 + t * 242 }
    private func py(_ t: CGFloat) -> CGFloat { 300 + sin(t * .pi * 3) * 74 }

    var body: some View {
        GeometryReader { geo in
            let c = MalaCanvas(size: geo.size)
            ZStack {
                RadialGradient(colors: [Color(hex: 0x0d223a), Color(hex: 0x060f1e)], center: UnitPoint(x: 0.5, y: 0.40), startRadius: 0, endRadius: c.len(400))
                LinearGradient(colors: [.clear, Color(hex: 0x5ae6a0).opacity(0.5), Color(hex: 0xb478f0).opacity(0.4), .clear], startPoint: .leading, endPoint: .trailing)
                    .frame(height: c.len(130)).blur(radius: c.len(28)).rotationEffect(.degrees(-6)).position(c.pt(139, 200))
                    .malaLoop(duration: 15, opacity: 0.6, active: !reduceMotion)
                LinearGradient(colors: [.clear, Color(hex: 0x78c8ff).opacity(0.4), Color(hex: 0x5af0be).opacity(0.35), .clear], startPoint: .leading, endPoint: .trailing)
                    .frame(height: c.len(96)).blur(radius: c.len(24)).rotationEffect(.degrees(5)).position(c.pt(139, 300))
                    .malaLoop(duration: 19, opacity: 0.6, delay: 2, active: !reduceMotion)
                Canvas { ctx, _ in
                    for i in 0..<target {
                        let t = target > 1 ? CGFloat(i) / CGFloat(target - 1) : 0
                        let p = c.pt(px(t), py(t))
                        let r = c.len(2.2)
                        let color: Color = i == target - 1
                            ? .malaFinalBead
                            : Color(hex: 0xbff0d2).opacity(i < count ? 0.8 : 0.28)
                        ctx.fill(Path(ellipseIn: CGRect(x: p.x - r, y: p.y - r, width: r * 2, height: r * 2)),
                                 with: .color(color))
                    }
                }
                let at = target > 1 ? CGFloat(count - 1) / CGFloat(target - 1) : 0
                ZStack {
                    Circle().fill(RadialGradient(colors: [Color(hex: 0xeafff2), Color(hex: 0x8ff0c0).opacity(0.95), Color(hex: 0x3ba58a).opacity(0)], center: .center, startRadius: 0, endRadius: c.len(14)))
                        .frame(width: c.len(28), height: c.len(28))
                        .malaLoop(duration: 3, scale: 1.16, active: !reduceMotion)
                    Circle().fill(Color(hex: 0xeafff2)).frame(width: c.len(10), height: c.len(10))
                }
                .position(c.pt(px(at), py(at)))
                .malaTapTransition(count, reduceMotion: reduceMotion)

                MalaCountBlock(
                    count: count, target: target, topFraction: 0.3,
                    numberFont: .system(size: c.len(58), weight: .ultraLight),
                    numberColor: Color(hex: 0xeafff4), numberTracking: 2,
                    labelColor: Color(hex: 0x7fc3a6), labelTracking: 6,
                    glowColor: Color(hex: 0x78f0be).opacity(0.5)
                )
            }
            .clipped()
        }
    }
}

/// 20 — Woven Textile: knotted beads on a draped, swaying cord.
struct MalaRender_WovenTextile: View {
    let count: Int, target: Int, isComplete: Bool, breathing: Bool, reduceMotion: Bool
    private func dropX(_ t: CGFloat) -> CGFloat { 24 + t * 230 }
    private func py(_ t: CGFloat) -> CGFloat { 206 + pow((t - 0.5) * 2, 2) * 150 }

    var body: some View {
        GeometryReader { geo in
            let c = MalaCanvas(size: geo.size)
            ZStack {
                RadialGradient(colors: [Color(hex: 0xd8cbb9), Color(hex: 0xb8a894)], center: UnitPoint(x: 0.5, y: 0.3), startRadius: 0, endRadius: c.len(360))
                Path { p in
                    p.move(to: c.pt(dropX(0), py(0)))
                    p.addQuadCurve(to: c.pt(dropX(1), py(1)), control: c.pt(139, py(0.5) + 44))
                }
                .stroke(Color(hex: 0x7a5a3a).opacity(0.55), lineWidth: c.len(2))
                .malaLoop(duration: 6, rotationDegrees: 1.4, active: !reduceMotion)

                Canvas { ctx, _ in
                    for i in 0..<target {
                        let t = target > 1 ? CGFloat(i) / CGFloat(target - 1) : 0
                        let p = c.pt(dropX(t), py(t))
                        let rad = c.len(5.5)
                        let color: Color = i == target - 1 ? .malaFinalBead : Color(hex: 0x8a4a30)
                        ctx.fill(Path(ellipseIn: CGRect(x: p.x - rad, y: p.y - rad, width: rad * 2, height: rad * 2)),
                                 with: .color(color))
                    }
                }
                .malaLoop(duration: 6, rotationDegrees: 1.4, active: !reduceMotion)

                let at = target > 1 ? CGFloat(count - 1) / CGFloat(target - 1) : 0
                ZStack {
                    Circle().fill(RadialGradient(colors: [Color(hex: 0xe0a06a), Color(hex: 0xb45f3c), Color(hex: 0x7a3a22)], center: UnitPoint(x: 0.36, y: 0.3), startRadius: 0, endRadius: c.len(9)))
                        .frame(width: c.len(18), height: c.len(18))
                    Circle().stroke(Color.white.opacity(0.25), lineWidth: c.len(1)).frame(width: c.len(26), height: c.len(26))
                }
                .position(c.pt(dropX(at), py(at)))
                .malaTapTransition(count, reduceMotion: reduceMotion)

                MalaCountBlock(
                    count: count, target: target, topFraction: 0.22,
                    numberFont: .custom("Georgia", size: c.len(60)),
                    numberColor: Color(hex: 0x5a3624),
                    labelColor: Color(hex: 0x9a7658), labelTracking: 4
                )
            }
        }
    }
}
