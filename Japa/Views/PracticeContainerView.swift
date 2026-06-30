import SwiftUI

/// Hosts a single round, swapping between the practice surface and the completion
/// view as the round's phase changes.
struct PracticeContainerView: View {
    let controller: PracticeController
    var onClose: () -> Void

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            switch controller.phase {
            case .practicing:
                PracticeView(controller: controller, onClose: onClose)
                    .transition(.opacity)
            case .completed:
                CompletionView(controller: controller, onClose: onClose)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: controller.phase)
        .onAppear { controller.prepare() }
        .statusBarHidden(true)
    }
}
