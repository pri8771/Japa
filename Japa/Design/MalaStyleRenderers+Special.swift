import SwiftUI

// Styles with a mechanic distinct from "beads around a ring" or "beads along a
// strand": a depth-of-field bead carousel, a worn/polished arc, a filling
// vessel, and a glazed-ceramic carousel.

/// 06 — Semi-3D Sculptural: rendered beads rolling through a plane of focus.
struct MalaRender_Semi3DSculptural: View {
    let count: Int, target: Int, isComplete: Bool, breathing: Bool, reduceMotion: Bool
    var body: some View {
        GeometryReader { geo in
            let c = MalaCanvas(size: geo.size)
            ZStack {
                LinearGradient(colors: [Color(hex: 0xeceae5), Color(hex: 0xd3cdc4), Color(hex: 0xc2bbb0)], startPoint: .top, endPoint: .bottom)
                Ellipse().fill(RadialGradient(colors: [Color(hex: 0x463c30).opacity(0.34), .clear], center: .center, startRadius: 0, endRadius: c.len(75)))
                    .frame(width: c.len(150), height: c.len(30)).blur(radius: c.len(4)).position(c.pt(139, 322))
                ForEach(-3...3, id: \.self) { o in
                    let ao = Double(abs(o))
                    let sc = 1 - ao * 0.23
                    let bl = ao * 2.6
                    let op = max(0, 1 - ao * 0.19)
                    Circle()
                        .fill(RadialGradient(colors: [Color(hex: 0xf4f1ea), Color(hex: 0xcfc7ba), Color(hex: 0x8f887b), Color(hex: 0x5d564b)],
                                              center: UnitPoint(x: 0.33, y: 0.27), startRadius: 0, endRadius: c.len(61)))
                        .frame(width: c.len(122), height: c.len(122))
                        .blur(radius: c.len(bl))
                        .opacity(op)
                        .scaleEffect(sc)
                        .position(c.pt(139 + CGFloat(o) * 74, 238))
                        .zIndex(10 - ao)
                }
                .malaTapTransition(count, reduceMotion: reduceMotion)

                MalaCountBlock(
                    count: count, target: target, topFraction: 0.66,
                    numberFont: .system(size: c.len(66), weight: .light),
                    numberColor: Color(hex: 0x413b32), numberTracking: -1,
                    labelColor: Color(hex: 0x9a9285), labelTracking: 4
                )
            }
        }
    }
}

/// 07 — Painterly Realism: gouache mala, worn smooth by the thumb.
struct MalaRender_PainterlyRealism: View {
    let count: Int, target: Int, isComplete: Bool, breathing: Bool, reduceMotion: Bool
    var body: some View {
        GeometryReader { geo in
            let c = MalaCanvas(size: geo.size)
            let cx: CGFloat = 139, cy: CGFloat = 300, R: CGFloat = 128, a0 = -120.0, a1 = 120.0
            ZStack {
                Color(hex: 0xece0cd)
                RadialGradient(colors: [Color.white.opacity(0.55), .clear], center: UnitPoint(x: 0.22, y: 0.16), startRadius: 0, endRadius: c.len(200))
                RadialGradient(colors: [Color(hex: 0x785032).opacity(0.1), .clear], center: UnitPoint(x: 0.82, y: 0.84), startRadius: 0, endRadius: c.len(220))
                ZStack {
                    Canvas { ctx, _ in
                        for i in 0..<target {
                            let ang = a0 + (a1 - a0) * Double(i) / Double(max(1, target - 1))
                            let p = c.polar(cx: cx, cy: cy, radius: R, degrees: ang)
                            let rad = c.len(6.6)
                            ctx.fill(Path(ellipseIn: CGRect(x: p.x - rad, y: p.y - rad, width: rad * 2, height: rad * 2)),
                                     with: .color(Color(hex: 0xcf9366)))
                            if i < count {
                                ctx.fill(Path(ellipseIn: CGRect(x: p.x - rad, y: p.y - rad, width: rad * 2, height: rad * 2)),
                                         with: .color(Color(hex: 0x7c4a2c)))
                            }
                        }
                    }
                    let ang = a0 + (a1 - a0) * Double(count - 1) / Double(max(1, target - 1))
                    let ap = c.polar(cx: cx, cy: cy, radius: R, degrees: ang)
                    Circle().stroke(Color(hex: 0x8a3b1e).opacity(0.85), lineWidth: c.len(1.6))
                        .frame(width: c.len(21), height: c.len(21))
                        .position(ap)
                        .malaTapTransition(count, reduceMotion: reduceMotion)
                }
                .malaLoop(duration: 7, rotationDegrees: 2.8, active: !reduceMotion)

                MalaCountBlock(
                    count: count, target: target, topFraction: 0.24,
                    numberFont: .system(size: c.len(64), design: .serif).italic(),
                    numberColor: Color(hex: 0x7c3f1e),
                    labelColor: Color(hex: 0xa9764f), labelTracking: 3
                )
            }
        }
    }
}

/// 17 — Amber Resin: light rising through a vessel of honey.
struct MalaRender_AmberResin: View {
    let count: Int, target: Int, isComplete: Bool, breathing: Bool, reduceMotion: Bool
    var body: some View {
        GeometryReader { geo in
            let c = MalaCanvas(size: geo.size)
            let vx: CGFloat = 139, vtop: CGFloat = 140, vbot: CGFloat = 372, vw: CGFloat = 128
            let vh = vbot - vtop
            let levelFrac = min(1, max(0, Double(count) / Double(target)))
            let levelY = vbot - vh * CGFloat(levelFrac)
            ZStack {
                RadialGradient(colors: [Color(hex: 0x6b3d0e), Color(hex: 0x351a05)], center: UnitPoint(x: 0.5, y: 0.4), startRadius: 0, endRadius: c.len(300))
                RoundedRectangle(cornerRadius: c.len(vw / 2)).stroke(Color(hex: 0xc98a2e).opacity(0.4), lineWidth: c.len(1.4))
                    .frame(width: c.len(vw), height: c.len(vh)).position(c.pt(vx, (vtop + vbot) / 2))
                RoundedRectangle(cornerRadius: c.len(vw / 2))
                    .fill(LinearGradient(colors: [Color(hex: 0xffe28a), Color(hex: 0xf0a63c), Color(hex: 0xb4610f)], startPoint: .top, endPoint: .bottom))
                    .frame(width: c.len(vw), height: max(0, c.len(vbot - levelY)))
                    .position(c.pt(vx, (levelY + vbot) / 2))
                    .clipShape(RoundedRectangle(cornerRadius: c.len(vw / 2)))
                    .mask(RoundedRectangle(cornerRadius: c.len(vw / 2)).frame(width: c.len(vw), height: c.len(vh)).position(c.pt(vx, (vtop + vbot) / 2)))
                    .malaTapTransition(count, reduceMotion: reduceMotion)
                ForEach(0..<5, id: \.self) { i in
                    Circle().fill(Color(hex: 0xffe6a6).opacity(0.5))
                        .frame(width: c.len(CGFloat(2 + i % 2) * 2), height: c.len(CGFloat(2 + i % 2) * 2))
                        .position(c.pt(vx - 30 + CGFloat(i) * 15, vbot - 18))
                        .malaLoop(duration: Double(4 + i), yOffset: -c.len(10), delay: Double(i) * 0.8, active: !reduceMotion)
                }
                Ellipse().fill(RadialGradient(colors: [Color(hex: 0xffd98a).opacity(0.7), Color(hex: 0xf0a63c).opacity(0.2), Color(hex: 0xf0a63c).opacity(0)], center: .center, startRadius: 0, endRadius: c.len(38)))
                    .frame(width: c.len(76), height: c.len(44))
                    .position(c.pt(vx, levelY))
                    .malaLoop(duration: 3.6, scale: 1.08, active: !reduceMotion)
                    .malaTapTransition(count, reduceMotion: reduceMotion)
                Ellipse().fill(Color.white.opacity(0.14)).frame(width: c.len(22), height: c.len(60)).position(c.pt(vx - 26, vtop + 42))

                MalaCountBlock(
                    count: count, target: target, topFraction: 0.72,
                    numberFont: .system(size: c.len(68), weight: .light, design: .serif),
                    numberColor: Color(hex: 0xffdf9e),
                    labelColor: Color(hex: 0xc58a3e), labelTracking: 4,
                    glowColor: Color(hex: 0xf0a63c).opacity(0.5)
                )
            }
        }
    }
}

/// 19 — Ceramic Glaze: matte celadon carousel with a fine craquelure sheen.
struct MalaRender_CeramicGlaze: View {
    let count: Int, target: Int, isComplete: Bool, breathing: Bool, reduceMotion: Bool
    var body: some View {
        GeometryReader { geo in
            let c = MalaCanvas(size: geo.size)
            ZStack {
                LinearGradient(colors: [Color(hex: 0xe8ebe4), Color(hex: 0xd3d8ce), Color(hex: 0xc3cabf)], startPoint: .top, endPoint: .bottom)
                Ellipse().fill(RadialGradient(colors: [Color(hex: 0x465648).opacity(0.28), .clear], center: .center, startRadius: 0, endRadius: c.len(60)))
                    .frame(width: c.len(120), height: c.len(22)).blur(radius: c.len(4)).position(c.pt(139, 312))
                ForEach(-3...3, id: \.self) { o in
                    let ao = Double(abs(o))
                    let sc = 1 - ao * 0.14
                    let op = max(0, 1 - ao * 0.22)
                    ZStack {
                        Circle()
                            .fill(RadialGradient(colors: [Color(hex: 0xeef3ea), Color(hex: 0xcdd8cb), Color(hex: 0xa7b6a6), Color(hex: 0x7f9080)],
                                                  center: UnitPoint(x: 0.38, y: 0.32), startRadius: 0, endRadius: c.len(48)))
                            .frame(width: c.len(96), height: c.len(96))
                        if o == 0 {
                            Ellipse().fill(Color.white.opacity(0.5)).frame(width: c.len(26), height: c.len(16))
                                .offset(x: -c.len(18), y: -c.len(28))
                                .blur(radius: c.len(3))
                                .malaLoop(duration: 3.4, opacity: 0.5, active: !reduceMotion)
                        }
                    }
                    .rotationEffect(.degrees(Double(o) * 10))
                    .scaleEffect(sc)
                    .opacity(op)
                    .position(c.pt(139 + CGFloat(o) * 80, 250))
                    .zIndex(10 - ao)
                }
                .malaTapTransition(count, reduceMotion: reduceMotion)

                MalaCountBlock(
                    count: count, target: target, topFraction: 0.62,
                    numberFont: .system(size: c.len(64), weight: .light, design: .serif),
                    numberColor: Color(hex: 0x4b574a),
                    labelColor: Color(hex: 0x8ea08c), labelTracking: 5
                )
            }
        }
    }
}
