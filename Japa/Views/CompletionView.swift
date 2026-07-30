import SwiftUI

/// The unmistakable end-of-round screen. Calm confirmation — count, mantra, and
/// time — with no streak, no "come back tomorrow", no pressure.
struct CompletionView: View {
    let controller: PracticeController
    var onClose: () -> Void

    @Environment(AppModel.self) private var app
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var bloom = false

    var body: some View {
        ZStack {
            if app.preferences.malaStyle != .classic {
                MalaStyleView(
                    style: app.preferences.malaStyle,
                    count: controller.target,
                    target: controller.target,
                    isComplete: true,
                    breathing: false
                )
                .ignoresSafeArea()
                .allowsHitTesting(false)
            }

            VStack(spacing: 0) {
                Spacer()

                if app.preferences.malaStyle == .classic {
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

                    confirmationText
                        .padding(.top, 32)
                        .opacity(bloom ? 1 : 0)

                    Spacer()
                } else {
                    Spacer()
                }

                if app.preferences.malaStyle != .classic {
                    confirmationText
                        .shadow(color: .black.opacity(0.45), radius: 12)
                        .padding(.bottom, 22)
                        .opacity(bloom ? 1 : 0)
                }

                VStack(spacing: 14) {
                    Button(action: { controller.startNewRound() }) {
                        Text("New round")
                    }
                    .buttonStyle(app.preferences.malaStyle == .classic ? OutlineButtonStyle() : OutlineButtonStyle(onDark: true))
                    .accessibilityIdentifier("newRoundButton")

                    Button(action: onClose) {
                        Text("Rest")
                            .font(Theme.ui(15))
                            .foregroundStyle(app.preferences.malaStyle == .classic ? Theme.textSecondary : Color.white.opacity(0.72))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                    }
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 28)
                .opacity(bloom ? 1 : 0)
            }
        }
        .background(app.preferences.malaStyle == .classic ? Theme.background : Color.black)
        .onAppear {
            withAnimation(reduceMotion ? .none : .easeOut(duration: 0.6)) { bloom = true }
        }
    }

    private var confirmationText: some View {
        VStack(spacing: 8) {
            Text("Round complete")
                .font(Theme.serif(24))
                .foregroundStyle(app.preferences.malaStyle == .classic ? Theme.textPrimary : Color.white)
            Text(subtitle)
                .font(Theme.ui(13))
                .foregroundStyle(app.preferences.malaStyle == .classic ? Theme.textSecondary : Color.white.opacity(0.68))
        }
    }

    private var subtitle: String {
        let mantra = controller.mantra.title
        let minutes = max(1, Int((controller.elapsedActiveDuration / 60).rounded()))
        return "\(mantra) · \(minutes) min"
    }
}
