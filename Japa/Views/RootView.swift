import SwiftUI

/// App navigation root. Home is the base; History, Settings, and Mantra Select
/// push onto the stack; Practice is presented immersively as a full-screen cover.
struct RootView: View {
    @Environment(AppModel.self) private var app
    @Environment(\.scenePhase) private var scenePhase

    @State private var practice: PracticeController?
    @State private var path: [Route] = []
    @State private var showIntro = false

    enum Route: Hashable {
        case mantraSelect
        case history
        case settings
    }

    var body: some View {
        NavigationStack(path: $path) {
            HomeView(
                onBegin: beginNewRound,
                onResume: resumeRound
            )
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .mantraSelect: MantraSelectView()
                case .history: HistoryView()
                case .settings: SettingsView()
                }
            }
        }
        .fullScreenCover(item: $practice, onDismiss: { app.refreshResumable() }) { controller in
            PracticeContainerView(controller: controller) { practice = nil }
                .environment(app)
        }
        .sheet(isPresented: $showIntro) {
            IntroView { app.markIntroSeen(); showIntro = false }
                .interactiveDismissDisabled(true)
        }
        .onAppear {
            if !app.preferences.hasSeenIntro { showIntro = true }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                app.refreshResumable()
            } else {
                practice?.persistNow()
            }
        }
    }

    private func beginNewRound() {
        practice = app.newPracticeController()
    }

    private func resumeRound() {
        if let controller = app.resumePracticeController() {
            practice = controller
        }
    }
}

extension PracticeController: Identifiable {
    nonisolated var id: ObjectIdentifier { ObjectIdentifier(self) }
}
