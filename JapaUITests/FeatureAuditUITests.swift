import XCTest

/// Feature-level audit: drives each remaining feature end-to-end in the running
/// app — the flagship resume-after-interruption flow, mantra selection + custom
/// authoring, history recording + deletion, and settings.
final class FeatureAuditUITests: XCTestCase {

    override func setUp() { continueAfterFailure = false }

    // MARK: Helpers

    private func ephemeralApp(target: Int = 5) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchEnvironment["JAPA_UITEST"] = "1"
        app.launchEnvironment["JAPA_UITEST_TARGET"] = String(target)
        return app
    }

    private func dismissIntro(_ app: XCUIApplication) {
        let introBegin = app.buttons["introBegin"]
        if introBegin.waitForExistence(timeout: 8) { introBegin.tap() }
    }

    private func tapCenter(_ app: XCUIApplication) {
        app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.45)).tap()
    }

    @discardableResult
    private func waitForRingValue(_ ring: XCUIElement, _ expected: String, timeout: TimeInterval = 3) -> Bool {
        let predicate = NSPredicate(format: "value == %@", expected)
        return XCTWaiter().wait(for: [XCTNSPredicateExpectation(predicate: predicate, object: ring)], timeout: timeout) == .completed
    }

    private func advance(_ app: XCUIApplication, _ ring: XCUIElement, to expected: String, maxTaps: Int = 8) {
        var taps = 0
        while (ring.value as? String) != expected && taps < maxTaps {
            tapCenter(app)
            taps += 1
            _ = waitForRingValue(ring, expected, timeout: 2)
        }
        XCTAssertEqual(ring.value as? String, expected)
    }

    private func completeRound(_ app: XCUIApplication) {
        let newRound = app.buttons["newRoundButton"]
        var taps = 0
        while !newRound.exists && taps < 15 {
            tapCenter(app)
            taps += 1
            _ = newRound.waitForExistence(timeout: 1)
        }
        XCTAssertTrue(newRound.exists)
    }

    // MARK: Flagship — resume after interruption

    func testResumeAfterInterruptionRestoresExactBead() {
        let dir = NSTemporaryDirectory() + "japa-ui-resume-\(UUID().uuidString)"
        let app = XCUIApplication()
        app.launchEnvironment["JAPA_UITEST"] = "1"
        app.launchEnvironment["JAPA_UITEST_DIR"] = dir
        app.launchEnvironment["JAPA_UITEST_TARGET"] = "8"
        app.launchEnvironment["JAPA_UITEST_RESET"] = "1"
        app.launch()

        dismissIntro(app)
        app.buttons["homeBegin"].tap()
        let ring = app.buttons["advanceRing"]
        XCTAssertTrue(ring.waitForExistence(timeout: 8))
        advance(app, ring, to: "3 of 8")

        // Interruption: background the app (persists the place), then terminate.
        XCUIDevice.shared.press(.home)
        Thread.sleep(forTimeInterval: 1.0)
        app.terminate()

        // Relaunch against the same store, without resetting it.
        app.launchEnvironment["JAPA_UITEST_RESET"] = "0"
        app.launch()

        let resume = app.buttons["resumeCard"]
        XCTAssertTrue(resume.waitForExistence(timeout: 8), "Resume card appears after an interruption")
        resume.tap()

        let ring2 = app.buttons["advanceRing"]
        XCTAssertTrue(ring2.waitForExistence(timeout: 8))
        XCTAssertTrue(waitForRingValue(ring2, "3 of 8"), "Exact bead restored — the flagship promise")
    }

    // MARK: Mantra selection + custom authoring

    func testMantraSelectionAndCustomCreation() {
        let app = ephemeralApp()
        app.launch()
        dismissIntro(app)

        // Switch to a different seed mantra.
        app.buttons["mantraRow"].tap()
        let seed = app.buttons["mantra-Om Mani Padme Hum"]
        XCTAssertTrue(seed.waitForExistence(timeout: 8))
        seed.tap()
        XCTAssertTrue(app.staticTexts["Om Mani Padme Hum"].waitForExistence(timeout: 8), "Home reflects the chosen mantra")

        // Create a custom free-text mantra.
        app.buttons["mantraRow"].tap()
        let addButton = app.buttons["addMantraButton"]
        // "Add your own" sits below the seed list; scroll it into view.
        var scrolls = 0
        while !addButton.isHittable && scrolls < 5 {
            app.swipeUp()
            scrolls += 1
        }
        addButton.tap()
        let field = app.textFields["mantraNameField"]
        XCTAssertTrue(field.waitForExistence(timeout: 8))
        field.tap()
        field.typeText("My test mantra")
        app.buttons["Save"].tap()

        let customRow = app.buttons["mantra-My test mantra"]
        XCTAssertTrue(customRow.waitForExistence(timeout: 8), "Custom mantra is saved and listed")
        customRow.tap()
        XCTAssertTrue(app.staticTexts["My test mantra"].waitForExistence(timeout: 8), "Home reflects the custom mantra")
    }

    // MARK: History records + deletes

    func testHistoryRecordsCompletedRoundAndDeletes() {
        let app = ephemeralApp(target: 5)
        app.launch()
        dismissIntro(app)

        app.buttons["homeBegin"].tap()
        XCTAssertTrue(app.buttons["advanceRing"].waitForExistence(timeout: 8))
        completeRound(app)
        app.buttons["Rest"].tap()

        app.buttons["historyButton"].tap()
        XCTAssertTrue(app.staticTexts["5 / 5"].waitForExistence(timeout: 8), "Completed round is recorded")
        XCTAssertTrue(app.staticTexts["Om Namah Shivaya"].exists)

        // Swipe to delete the entry.
        app.cells.element(boundBy: 0).swipeLeft()
        app.buttons["Delete"].tap()
        XCTAssertTrue(app.staticTexts["Your sessions appear here"].waitForExistence(timeout: 8), "History empties after delete")
    }

    // MARK: Settings

    func testSettingsToneToggle() {
        let app = ephemeralApp()
        app.launch()
        dismissIntro(app)

        app.buttons["settingsButton"].tap()
        let toggle = app.switches["Completion tone"]
        XCTAssertTrue(toggle.waitForExistence(timeout: 8))
        let before = toggle.value as? String
        // Tap the trailing knob region rather than the row center (the label).
        toggle.coordinate(withNormalizedOffset: CGVector(dx: 0.92, dy: 0.5)).tap()
        let changed = XCTWaiter().wait(
            for: [XCTNSPredicateExpectation(
                predicate: NSPredicate(format: "value != %@", before ?? ""),
                object: toggle)],
            timeout: 3) == .completed
        XCTAssertTrue(changed, "Completion-tone toggle flips")
    }
}
