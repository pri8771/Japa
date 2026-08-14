import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

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

    /// Builds the app model. Under UI testing it uses an ephemeral store so every
    /// run starts from a clean slate, with an optional target override so a full
    /// round is reachable in a few taps.
    ///
    /// Two equivalent activation contracts are honored:
    ///   * the app's original `JAPA_UITEST=1` (+ `JAPA_UITEST_DIR` /
    ///     `JAPA_UITEST_RESET` / `JAPA_UITEST_TARGET`), used by the XCUITest suite;
    ///   * the App Factory standard `UI_TEST_MODE=1` (+ `UI_RESET_STATE`,
    ///     `UI_FIXTURE`, `UI_DISABLE_ANIMATIONS`), used by generated Maestro flows.
    ///
    /// Both map to the same deterministic, network-free, secret-free local state.
    @MainActor
    private static func makeModel() -> AppModel {
        let env = ProcessInfo.processInfo.environment
        let testMode = env["JAPA_UITEST"] == "1" || env["UI_TEST_MODE"] == "1"
        guard testMode else { return AppModel() }

        if env["UI_DISABLE_ANIMATIONS"] == "1" {
            // Disables UIKit-backed animations for deterministic Maestro/XCUITest
            // timing. (SwiftUI explicit animations are additionally suppressed on
            // devices with Reduce Motion enabled — see the follow-up in
            // quality/ui/README.md.)
            #if canImport(UIKit)
            UIView.setAnimationsEnabled(false)
            #endif
        }

        let dir: URL
        if let fixed = env["JAPA_UITEST_DIR"] {
            dir = URL(fileURLWithPath: fixed, isDirectory: true)
        } else {
            dir = FileManager.default.temporaryDirectory
                .appendingPathComponent("japa-uitest-\(UUID().uuidString)", isDirectory: true)
        }
        if env["JAPA_UITEST_RESET"] == "1" || env["UI_RESET_STATE"] == "1" {
            try? FileManager.default.removeItem(at: dir)
        }

        let model = AppModel(persistence: Persistence(directory: dir))
        if let raw = env["JAPA_UITEST_TARGET"], let target = Int(raw) {
            model.setDefaultTarget(target)
        }
        applyFixture(env["UI_FIXTURE"], to: model)
        return model
    }

    /// Seeds a deterministic local fixture state. Only fixtures that map to real
    /// Japa state are implemented; `error`, `offline`, and `permission-denied`
    /// from the standard fixture vocabulary are not applicable to this local-first
    /// app (no network, no OS permission surface) and are intentionally omitted.
    @MainActor
    private static func applyFixture(_ fixture: String?, to model: AppModel) {
        guard let fixture else { return }
        switch fixture {
        case "empty":
            break // Clean store is the empty fixture.
        case "one-record":
            model.record(sampleSession(daysAgo: 1, completed: true))
        case "app-store-history":
            model.record(PracticeSession(
                startedAt: Date(timeIntervalSince1970: 1_785_971_400),
                duration: 540,
                mantraTitle: "Counting",
                target: 108,
                completedCount: 108,
                reachedTarget: true
            ))
        case "many-records":
            for day in 1...12 {
                model.record(sampleSession(daysAgo: day, completed: day % 3 != 0))
            }
        case "long-text":
            let long = "Om Namah Shivaya Om Namah Shivaya Om Namah Shivaya — a deliberately long mantra title for text-layout testing"
            if let mantra = model.addCustomMantra(title: long) {
                model.select(mantra)
            }
        default:
            break // Unknown fixture: fall back to whatever the store holds.
        }
    }

    @MainActor
    private static func sampleSession(daysAgo: Int, completed: Bool) -> PracticeSession {
        let started = Date(timeIntervalSince1970: 1_700_000_000 - Double(daysAgo) * 86_400)
        return PracticeSession(
            startedAt: started,
            duration: completed ? 540 : 120,
            mantraTitle: "Om Namah Shivaya",
            target: 108,
            completedCount: completed ? 108 : 34,
            reachedTarget: completed
        )
    }
}
