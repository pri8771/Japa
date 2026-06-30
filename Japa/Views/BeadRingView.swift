import SwiftUI

/// The abstract bead ring — Japa's central visual.
///
/// Deliberately *not* a literal string of beads (that's deferred polish). A thin
/// arc fills as the round progresses, with a soft glow that brightens at
/// completion. The count sits quietly at the center and is never required to
/// read — the haptic is the confirmation.
struct BeadRingView: View {
    var progress: Double
    var count: Int
    var target: Int
    var isComplete: Bool
    var showsCount: Bool = true
    var breathing: Bool = false
    var lineWidth: CGFloat = 3

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var breath = false

    var body: some View {
        ZStack {
            Circle()
                .stroke(Theme.ringTrack, lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: max(0.0001, min(1, progress)))
                .stroke(
                    isComplete ? Theme.accentBright : Theme.accent,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .shadow(color: Theme.accent.opacity(isComplete ? 0.55 : 0.30),
                        radius: isComplete ? 16 : 8)
                .animation(.easeOut(duration: 0.28), value: progress)
                .animation(.easeOut(duration: 0.5), value: isComplete)

            if isComplete {
                Circle()
                    .stroke(Theme.accentSoft, lineWidth: 1)
                    .padding(lineWidth * 5)
            }

            if showsCount {
                VStack(spacing: 2) {
                    Text("\(count)")
                        .font(Theme.serif(count >= 1000 ? 52 : 64, weight: .light))
                        .foregroundStyle(Theme.textPrimary)
                        .monospacedDigit()
                        .contentTransition(.numericText(value: Double(count)))
                    Text("of \(target)")
                        .font(Theme.ui(13))
                        .foregroundStyle(Theme.textMuted)
                }
            }
        }
        .scaleEffect((breath && breathing && !reduceMotion) ? 1.012 : 1)
        .animation(
            (breathing && !reduceMotion)
                ? .easeInOut(duration: 4).repeatForever(autoreverses: true)
                : .default,
            value: breath
        )
        .onAppear { if breathing { breath = true } }
    }
}

#Preview {
    ZStack {
        Theme.background.ignoresSafeArea()
        BeadRingView(progress: 0.53, count: 57, target: 108, isComplete: false, breathing: true)
            .frame(width: 260, height: 260)
    }
}
