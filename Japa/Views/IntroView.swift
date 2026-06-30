import SwiftUI

/// A brief, skippable first-run explainer. No accounts, no permission walls, no
/// notification prompt — just the one thing to know before practicing.
struct IntroView: View {
    var onContinue: () -> Void

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer()

                BeadRingView(progress: 0.28, count: 30, target: 108, isComplete: false, breathing: true)
                    .frame(width: 168, height: 168)
                    .accessibilityHidden(true)

                VStack(spacing: 14) {
                    Text("Welcome to Japa")
                        .font(Theme.serif(26))
                        .foregroundStyle(Theme.textPrimary)
                    Text("Tap anywhere to advance a bead. Feel each one — you can keep your eyes closed. A distinct buzz tells you the round is complete.")
                        .font(Theme.ui(15))
                        .foregroundStyle(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 32)
                }
                .padding(.top, 36)

                Spacer()

                Button(action: onContinue) {
                    Text("Begin")
                }
                .buttonStyle(OutlineButtonStyle())
                .accessibilityIdentifier("introBegin")
                .padding(.horizontal, 40)
                .padding(.bottom, 36)
            }
        }
    }
}

#Preview {
    IntroView(onContinue: {})
}
