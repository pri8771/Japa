import SwiftUI

/// App navigation root. The practice surface *is* the home screen — opening
/// the app puts the user straight into their (auto-resumed) round, and the
/// first tap counts. History, Settings, Mantra Select, and the mala style
/// picker push onto the stack from the surface's quiet chrome.
struct RootView: View {
    @Environment(AppModel.self) private var app
    @Environment(\.scenePhase) private var scenePhase

    @State private var practice: PracticeController?
    @State private var path: [Route] = []
    @State private var showIntro = false
    @State private var showFinishPrompt = false

    enum Route: Hashable {
        case mantraSelect
        case history
        case settings
        case malaStylePicker
    }

    /// How long a counted-but-untouched round sits before we ask whether the
    /// practitioner is done with it. Overridable for UI tests.
    private var staleThreshold: TimeInterval {
        if let raw = ProcessInfo.processInfo.environment["JAPA_UITEST_STALE_SECONDS"], let value = TimeInterval(raw) {
            return value
        }
        return 30 * 60
    }

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if let controller = practice {
                    PracticeView(controller: controller)
                } else {
                    Theme.background.ignoresSafeArea()
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .mantraSelect: MantraSelectView()
                case .history: HistoryView()
                case .settings: SettingsView()
                case .malaStylePicker: MalaStylePickerView()
                }
            }
        }
        .sheet(isPresented: $showIntro) {
            IntroView { app.markIntroSeen(); showIntro = false }
                .interactiveDismissDisabled(true)
        }
        .alert("Finish this round?", isPresented: $showFinishPrompt) {
            Button("Finish") { practice?.finishEarly() }
            Button("Keep going", role: .cancel) { practice?.touch() }
        } message: {
            if let controller = practice {
                Text("You're at \(controller.count) of \(controller.target) and haven't counted in a while. Finishing saves your progress to history and starts a fresh round.")
            }
        }
        .onAppear {
            if !app.preferences.hasSeenIntro { showIntro = true }
            ensureController()
            promptIfStale()
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                app.refreshResumable()
                ensureController()
                promptIfStale()
            } else {
                practice?.persistNow()
            }
        }
        // Target/mantra changes apply immediately while no beads are counted;
        // mid-round they apply on the next round (the running round keeps its
        // own mantra and target, as before).
        .onChange(of: app.preferences.defaultTarget) { _, _ in refreshIdleController() }
        .onChange(of: app.selectedMantra.id) { _, _ in refreshIdleController() }
    }

    /// Resume the interrupted round if one exists, otherwise start fresh —
    /// either way the surface is live the moment the app opens.
    private func ensureController() {
        guard practice == nil else { return }
        practice = app.resumePracticeController() ?? app.newPracticeController()
    }

    private func refreshIdleController() {
        guard let controller = practice, controller.count == 0, controller.phase == .practicing else { return }
        practice = app.newPracticeController()
    }

    /// If the round has sat counted-but-untouched past the threshold, ask
    /// whether the practitioner is done with it rather than silently keeping
    /// a stale round alive forever.
    private func promptIfStale() {
        guard practice?.isStale(after: staleThreshold) == true else { return }
        showFinishPrompt = true
    }
}
