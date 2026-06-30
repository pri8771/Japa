import SwiftUI

/// The eyes-free practice surface.
///
/// The entire screen advances — any tap anywhere counts a bead, so practice
/// works without aiming and without looking. A swipe-down or the small undo
/// control steps back one bead. Only the two controls (close, undo) capture
/// touches; everything else passes through to the whole-screen advance layer.
struct PracticeView: View {
    let controller: PracticeController
    var onClose: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var tapScale: CGFloat = 1

    var body: some View {
        ZStack {
            // Whole-screen advance layer.
            Color.clear
                .contentShape(Rectangle())
                .ignoresSafeArea()
                .onTapGesture { advance() }
                .gesture(
                    DragGesture(minimumDistance: 28)
                        .onEnded { value in
                            if value.translation.height > 36 { controller.undo() }
                        }
                )
                .accessibilityHidden(true)

            VStack(spacing: 0) {
                topBar
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                Spacer()

                BeadRingView(
                    progress: controller.progress,
                    count: controller.count,
                    target: controller.target,
                    isComplete: false,
                    breathing: true
                )
                .frame(width: 268, height: 268)
                .scaleEffect(tapScale)
                .allowsHitTesting(false)
                // Accessibility: the ring is the advance affordance for VoiceOver.
                .accessibilityElement(children: .ignore)
                .accessibilityAddTraits(.isButton)
                .accessibilityLabel("Advance one bead")
                .accessibilityValue("\(controller.count) of \(controller.target)")
                .accessibilityHint("Double-tap to count a bead")
                .accessibilityAction { advance() }
                .accessibilityIdentifier("advanceRing")

                Spacer()

                bottomBar
                    .padding(.bottom, 30)
            }
        }
        .background(Theme.background)
    }

    private var topBar: some View {
        ZStack {
            Text(controller.mantra.title)
                .font(Theme.serif(15))
                .foregroundStyle(Theme.textSecondary)
                .allowsHitTesting(false)

            HStack {
                Button(action: endAndClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(Theme.textMuted)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .accessibilityLabel("End round")
                Spacer()
            }
        }
    }

    private var bottomBar: some View {
        VStack(spacing: 18) {
            Button(action: { controller.undo() }) {
                Label("Undo", systemImage: "arrow.uturn.left")
                    .font(Theme.ui(14, weight: .medium))
                    .foregroundStyle(Theme.textSecondary)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 9)
                    .overlay(
                        Capsule().stroke(Theme.hairline, lineWidth: 1)
                    )
            }
            .accessibilityHint("Steps back one bead")

            Text("Tap anywhere to advance")
                .font(Theme.ui(12))
                .foregroundStyle(Theme.textMuted)
                .allowsHitTesting(false)
        }
    }

    private func advance() {
        controller.advance()
        guard !reduceMotion else { return }
        withAnimation(.easeOut(duration: 0.07)) { tapScale = 0.985 }
        withAnimation(.easeOut(duration: 0.18).delay(0.07)) { tapScale = 1 }
    }

    private func endAndClose() {
        controller.endEarly()
        onClose()
    }
}
