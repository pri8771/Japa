import XCTest

/// Verifies the App Factory deterministic UI-test contract added during Studio OS
/// enrollment: the standard `UI_TEST_MODE` / `UI_FIXTURE` / `UI_RESET_STATE` /
/// `UI_DISABLE_ANIMATIONS` launch arguments drive the same ephemeral, seeded
/// local state that the generated Maestro flows in `quality/ui/` rely on.
final class UITestModeContractTests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    /// `UI_TEST_MODE=1` with `UI_FIXTURE=one-record` must launch into a clean
    /// ephemeral store seeded with exactly one history session, reachable via the
    /// `historyButton` chrome, with the `historyRoot` container present (not the
    /// empty state).
    func testStandardTestModeSeedsHistoryFixture() {
        let app = XCUIApplication()
        app.launchEnvironment["UI_TEST_MODE"] = "1"
        app.launchEnvironment["UI_RESET_STATE"] = "1"
        app.launchEnvironment["UI_FIXTURE"] = "one-record"
        app.launchEnvironment["UI_DISABLE_ANIMATIONS"] = "1"
        app.launch()

        // The first-run intro sheet appears over a fresh store; dismiss it.
        let introBegin = app.buttons["introBegin"]
        if introBegin.waitForExistence(timeout: 8) { introBegin.tap() }

        let historyButton = app.buttons["historyButton"]
        XCTAssertTrue(historyButton.waitForExistence(timeout: 8), "Practice chrome is present")
        historyButton.tap()

        let historyRoot = app.descendants(matching: .any).matching(identifier: "historyRoot").firstMatch
        XCTAssertTrue(historyRoot.waitForExistence(timeout: 8), "History root container is registered and visible")

        // The one-record fixture seeds a real session, so the empty state must
        // NOT be shown.
        XCTAssertFalse(
            app.staticTexts["Your sessions appear here"].exists,
            "one-record fixture shows a seeded session, not the empty state"
        )
        XCTAssertTrue(
            app.staticTexts["Om Namah Shivaya"].firstMatch.waitForExistence(timeout: 4),
            "Seeded session row is visible"
        )
    }
}
