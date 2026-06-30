import SwiftUI

@main
struct JapaApp: App {
    @State private var app = JapaApp.makeModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(app)
                .tint(Theme.accent)
        }
    }

    /// Builds the app model. Under UI testing (`JAPA_UITEST=1`) it uses an
    /// ephemeral store so every run starts from a clean slate, with an optional
    /// target override so a full round is reachable in a few taps.
    @MainActor
    private static func makeModel() -> AppModel {
        let env = ProcessInfo.processInfo.environment
        guard env["JAPA_UITEST"] == "1" else { return AppModel() }

        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent("japa-uitest-\(UUID().uuidString)", isDirectory: true)
        let model = AppModel(persistence: Persistence(directory: dir))
        if let raw = env["JAPA_UITEST_TARGET"], let target = Int(raw) {
            model.setDefaultTarget(target)
        }
        return model
    }
}
