import SwiftUI

/// The unmistakable end-of-round screen. Calm confirmation — count, mantra, and
/// time — with no streak, no "come back tomorrow", no pressure.
struct CompletionView: View {
    let controller: PracticeController
    var onClose: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var bloom = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            BeadRingView(
                progress: 1,
                count: controller.target,
                target: controller.target,
                isComplete: true,
                breathing: false
            )
            .frame(width: 248, height: 248)
            .scaleEffect(bloom ? 1 : 0.92)
            .opacity(bloom ? 1 : 0.6)

            VStack(spacing: 8) {
                Text("Round complete")
                    .font(Theme.serif(24))
                    .foregroundStyle(Theme.textPrimary)
                Text(subtitle)
                    .font(Theme.ui(13))
                    .foregroundStyle(Theme.textSecondary)
            }
            .padding(.top, 32)
            .opacity(bloom ? 1 : 0)

            Spacer()

            VStack(spacing: 14) {
                Button(action: { controller.startNewRound() }) {
                    Text("New round")
                }
                .buttonStyle(OutlineButtonStyle())
                .accessibilityIdentifier("newRoundButton")

                Button(action: onClose) {
                    Text("Rest")
                        .font(Theme.ui(15))
                        .foregroundStyle(Theme.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                }
            }
            .padding(.horizontal, 28)
            .padding(.bottom, 28)
            .opacity(bloom ? 1 : 0)
        }
        .onAppear {
            withAnimation(reduceMotion ? .none : .easeOut(duration: 0.6)) { bloom = true }
        }
    }

    private var subtitle: String {
        let mantra = controller.mantra.title
        let minutes = max(1, Int((Date().timeIntervalSince(controller.startedAt) / 60).rounded()))
        return "\(mantra) · \(minutes) min"
    }
}
