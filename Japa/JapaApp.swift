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
    ///
    /// A test can pass `JAPA_UITEST_DIR` to pin the store to a fixed directory
    /// that persists across relaunches (so the resume-after-interruption flow can
    /// be exercised end-to-end), and `JAPA_UITEST_RESET=1` to wipe it first.
    @MainActor
    private static func makeModel() -> AppModel {
        let env = ProcessInfo.processInfo.environment
        guard env["JAPA_UITEST"] == "1" else { return AppModel() }

        let dir: URL
        if let fixed = env["JAPA_UITEST_DIR"] {
            dir = URL(fileURLWithPath: fixed, isDirectory: true)
        } else {
            dir = FileManager.default.temporaryDirectory
                .appendingPathComponent("japa-uitest-\(UUID().uuidString)", isDirectory: true)
        }
        if env["JAPA_UITEST_RESET"] == "1" {
            try? FileManager.default.removeItem(at: dir)
        }
        let model = AppModel(persistence: Persistence(directory: dir))
        if let raw = env["JAPA_UITEST_TARGET"], let target = Int(raw) {
            model.setDefaultTarget(target)
        }
        return model
    }
}
