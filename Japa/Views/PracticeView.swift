import SwiftUI

/// The app's single main surface: the selected mala fills the screen and the
/// round is always live — the first tap after opening the app counts a bead.
///
/// There is no separate home screen or Begin step. The entire screen advances
/// (a tap on the practice surface counts), a swipe-down or the Undo control steps back one
/// bead, and completion overlays this same surface in place. Mantra, History,
/// and Settings hide behind quiet chrome at the top.
///
/// The selected mala style renders full-bleed behind the chrome — except
/// Classic, which keeps its original centered-ring-on-`Theme.background` look
/// unchanged, since it's the pre-existing shipped default.
struct PracticeView: View {
    let controller: PracticeController

    @Environment(AppModel.self) private var app
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var tapScale: CGFloat = 1
    @State private var showFinishConfirmation = false

    private var style: MalaStyle { app.preferences.malaStyle }
    private var isClassic: Bool { style == .classic }

    var body: some View {
        ZStack {
            if !isClassic {
                // No tap-press scale here: shrinking full-bleed art exposes the
                // black backing as letterbox bars (visible on light styles like
                // Sculptural Monument). Each style's own bead motion is the tap
                // response; the press scale is Classic's centered-ring gesture.
                MalaStyleView(
                    style: style,
                    count: controller.count,
                    target: controller.target,
                    isComplete: controller.isComplete,
                    breathing: true
                )
                .ignoresSafeArea()
                .allowsHitTesting(false)
            }

            // Practice-surface advance layer.
            Color.clear
                .contentShape(Rectangle())
                // Keep the counting gesture out of the chrome bands so the
                // compact navigation and Undo controls always win hit-testing.
                .padding(.top, 100)
                .padding(.bottom, 110)
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

                if isClassic {
                    classicRing
                } else {
                    // The style's own art fills the screen; this is just the
                    // VoiceOver advance affordance in the same central spot.
                    Color.clear
                        .frame(width: 268, height: 268)
                        .advanceAccessibility(controller: controller, action: advance)
                }

                Spacer()

                bottomBar
                    .padding(.bottom, 30)
            }

            if controller.phase == .completed {
                CompletionView(controller: controller, onClose: { controller.startNewRound() })
                    .transition(.opacity)
            }
        }
        .background(isClassic ? Theme.background : Color.black)
        .animation(.easeInOut(duration: 0.4), value: controller.phase)
        .toolbar(.hidden, for: .navigationBar)
        .alert("Finish this round?", isPresented: $showFinishConfirmation) {
            Button("Finish", role: .destructive) { controller.finishEarly() }
            Button("Keep counting", role: .cancel) {}
        } message: {
            Text("Your current count will be saved to History and a fresh round will begin.")
        }
        .onAppear { controller.prepare() }
    }

    private var classicRing: some View {
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
        .advanceAccessibility(controller: controller, action: advance)
    }

    private var topBar: some View {
        ZStack {
            NavigationLink(value: RootView.Route.mantraSelect) {
                Text(controller.mantra.title)
                    .font(Theme.serif(15))
                    .foregroundStyle(isClassic ? Theme.textSecondary : .white.opacity(0.78))
                    .shadow(color: .black.opacity(isClassic ? 0 : 0.4), radius: 4)
            }
            .accessibilityLabel("Mantra: \(controller.mantra.title). Change mantra.")
            .accessibilityIdentifier("mantraRow")

            HStack(spacing: 18) {
                Spacer()
                NavigationLink(value: RootView.Route.history) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 18))
                        .foregroundStyle(isClassic ? Theme.textMuted : .white.opacity(0.62))
                        .shadow(color: .black.opacity(isClassic ? 0 : 0.4), radius: 4)
                }
                .accessibilityLabel("History")
                .accessibilityIdentifier("historyButton")
                NavigationLink(value: RootView.Route.settings) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 18))
                        .foregroundStyle(isClassic ? Theme.textMuted : .white.opacity(0.62))
                        .shadow(color: .black.opacity(isClassic ? 0 : 0.4), radius: 4)
                }
                .accessibilityLabel("Settings")
                .accessibilityIdentifier("settingsButton")
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

            Button(action: { showFinishConfirmation = true }) {
                Text("Finish early")
                    .font(Theme.ui(14, weight: .medium))
                    .foregroundStyle(isClassic ? Theme.textSecondary : .white.opacity(0.88))
                    .padding(.horizontal, 18)
                    .padding(.vertical, 9)
                    .background(Capsule().fill(.black.opacity(isClassic ? 0 : 0.26)))
                    .overlay(
                        Capsule().stroke(isClassic ? Theme.hairline : .white.opacity(0.32), lineWidth: 1)
                    )
            }
            .accessibilityIdentifier("finishEarlyButton")
            .accessibilityHint("Save this partial round to History and start a new round")

            Text("Tap anywhere to advance")
                .font(Theme.ui(12))
                .foregroundStyle(isClassic ? Theme.textMuted : .white.opacity(0.72))
                .shadow(color: .black.opacity(isClassic ? 0 : 0.4), radius: 4)
                .allowsHitTesting(false)
        }
    }

    private func advance() {
        controller.advance()
        // The press scale only drives Classic's centered ring.
        guard isClassic, !reduceMotion else { return }
        withAnimation(.easeOut(duration: 0.07)) { tapScale = 0.985 }
        withAnimation(.easeOut(duration: 0.18).delay(0.07)) { tapScale = 1 }
    }
}

private extension View {
    /// The shared VoiceOver affordance for the advance ring/area.
    func advanceAccessibility(controller: PracticeController, action: @escaping () -> Void) -> some View {
        accessibilityElement(children: .ignore)
            .accessibilityAddTraits(.isButton)
            .accessibilityLabel("Advance one bead")
            .accessibilityValue("\(controller.count) of \(controller.target)")
            .accessibilityHint("Double-tap to count a bead")
            .accessibilityAction { action() }
            .accessibilityIdentifier("advanceRing")
    }
}
