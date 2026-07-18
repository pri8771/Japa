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

    @Environment(AppModel.self) private var app
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

            practiceContent
        }
        .background(background)
    }

    @ViewBuilder
    private var practiceContent: some View {
        if app.preferences.malaStyle == .classic {
            VStack(spacing: 0) {
                topBar
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                Spacer()
                classicAdvanceRing
                Spacer()
                bottomBar
                    .padding(.bottom, 30)
            }
        } else {
            ZStack {
                MalaStyleView(
                    style: app.preferences.malaStyle,
                    count: controller.count,
                    target: controller.target,
                    isComplete: false,
                    breathing: true
                )
                .ignoresSafeArea()
                .allowsHitTesting(false)

                VStack(spacing: 0) {
                    topBar
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                    Spacer()
                    fullScreenAdvanceAccessibility
                    Spacer()
                    bottomBar
                        .padding(.bottom, 30)
                }
            }
        }
    }

    private var background: some View {
        Group {
            if app.preferences.malaStyle == .classic {
                Theme.background
            } else {
                Color.black
            }
        }
    }

    private var classicAdvanceRing: some View {
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
    }

    private var fullScreenAdvanceAccessibility: some View {
        Color.clear
            .frame(width: 1, height: 1)
            .accessibilityElement(children: .ignore)
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel("Advance one bead")
            .accessibilityValue("\(controller.count) of \(controller.target)")
            .accessibilityHint("Double-tap to count a bead")
            .accessibilityAction { advance() }
            .accessibilityIdentifier("advanceRing")
    }

    /// Non-classic styles fill the whole screen with their own art, so the
    /// chrome sitting on top needs contrast that holds regardless of what's
    /// underneath — a light scrim plus a shadow, rather than Theme's fixed
    /// light/dark colors which assume Theme.background.
    private var isClassic: Bool { app.preferences.malaStyle == .classic }

    private var topBar: some View {
        ZStack {
            Text(controller.mantra.title)
                .font(Theme.serif(15))
                .foregroundStyle(isClassic ? Theme.textSecondary : .white.opacity(0.78))
                .shadow(color: .black.opacity(isClassic ? 0 : 0.4), radius: 4)
                .allowsHitTesting(false)

            HStack {
                Button(action: endAndClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(isClassic ? Theme.textMuted : .white.opacity(0.85))
                        .shadow(color: .black.opacity(isClassic ? 0 : 0.4), radius: 4)
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
                    .foregroundStyle(isClassic ? Theme.textSecondary : .white.opacity(0.88))
                    .padding(.horizontal, 18)
                    .padding(.vertical, 9)
                    .background(Capsule().fill(.black.opacity(isClassic ? 0 : 0.26)))
                    .overlay(
                        Capsule().stroke(isClassic ? Theme.hairline : .white.opacity(0.32), lineWidth: 1)
                    )
            }
            .accessibilityHint("Steps back one bead")

            Text("Tap anywhere to advance")
                .font(Theme.ui(12))
                .foregroundStyle(isClassic ? Theme.textMuted : .white.opacity(0.72))
                .shadow(color: .black.opacity(isClassic ? 0 : 0.4), radius: 4)
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
