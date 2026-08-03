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

    private func attach(_ app: XCUIApplication, _ name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
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
        let ring = app.buttons["advanceRing"]
        XCTAssertTrue(ring.waitForExistence(timeout: 8))
        advance(app, ring, to: "3 of 8")

        // Interruption: background the app (persists the place), then terminate.
        XCUIDevice.shared.press(.home)
        Thread.sleep(forTimeInterval: 1.0)
        app.terminate()

        // Relaunch against the same store, without resetting it. The surface
        // auto-resumes in place — no resume card, no Begin step.
        app.launchEnvironment["JAPA_UITEST_RESET"] = "0"
        app.launch()

        let ring2 = app.buttons["advanceRing"]
        XCTAssertTrue(ring2.waitForExistence(timeout: 8))
        XCTAssertTrue(waitForRingValue(ring2, "3 of 8", timeout: 8), "Exact bead restored in place — the flagship promise")
    }

    // MARK: Mantra selection + custom authoring

    func testMantraSelectionAndCustomCreation() {
        let app = ephemeralApp()
        app.launch()
        dismissIntro(app)

        // Create a custom free-text mantra.
        app.buttons["mantraRow"].tap()
        let addButton = app.buttons["addMantraButton"]
        // Scroll if needed to keep this resilient if the selection screen grows.
        var scrolls = 0
        while !addButton.isHittable && scrolls < 5 {
            app.swipeUp()
            scrolls += 1
        }
        addButton.tap()
        let field = app.textFields["mantraNameField"]
        XCTAssertTrue(field.waitForExistence(timeout: 8))
        field.tap()
        field.typeText("Morning gratitude")
        app.buttons["Save"].tap()

        let customRow = app.buttons["mantra-Morning gratitude"]
        XCTAssertTrue(customRow.waitForExistence(timeout: 8), "Custom mantra is saved and listed")
        attach(app, "03-Personal-label")
        customRow.tap()
        XCTAssertTrue(surfaceShowsMantra(app, "Morning gratitude"), "Surface reflects the custom mantra")
    }

    // MARK: Stale round → Finish prompt

    func testStaleRoundPromptsFinishAndRecordsPartial() {
        let dir = NSTemporaryDirectory() + "japa-ui-stale-\(UUID().uuidString)"
        let app = XCUIApplication()
        app.launchEnvironment["JAPA_UITEST"] = "1"
        app.launchEnvironment["JAPA_UITEST_DIR"] = dir
        app.launchEnvironment["JAPA_UITEST_TARGET"] = "8"
        app.launchEnvironment["JAPA_UITEST_RESET"] = "1"
        app.launchEnvironment["JAPA_UITEST_STALE_SECONDS"] = "1"
        app.launch()

        dismissIntro(app)
        let ring = app.buttons["advanceRing"]
        XCTAssertTrue(ring.waitForExistence(timeout: 8))
        advance(app, ring, to: "3 of 8")

        // Leave the round untouched past the (test-shortened) threshold.
        XCUIDevice.shared.press(.home)
        Thread.sleep(forTimeInterval: 1.5)
        app.terminate()
        app.launchEnvironment["JAPA_UITEST_RESET"] = "0"
        app.launch()

        // Returning after the gap asks whether the round is done.
        let alert = app.alerts["Finish this round?"]
        XCTAssertTrue(alert.waitForExistence(timeout: 8), "Stale round prompts Finish")
        alert.buttons["Finish"].tap()

        // Finish records the honest partial and starts fresh in place.
        XCTAssertTrue(ring.waitForExistence(timeout: 8))
        XCTAssertTrue(waitForRingValue(ring, "0 of 8", timeout: 8), "Fresh round after finishing")
        app.buttons["historyButton"].tap()
        XCTAssertTrue(app.staticTexts["3 / 8"].waitForExistence(timeout: 8), "Partial recorded to history")
    }

    func testExplicitFinishEarlyRecordsPartialAndStartsFresh() {
        let app = ephemeralApp(target: 8)
        app.launch()
        dismissIntro(app)

        let ring = app.buttons["advanceRing"]
        XCTAssertTrue(ring.waitForExistence(timeout: 8))
        advance(app, ring, to: "3 of 8")

        let finishEarly = app.buttons["finishEarlyButton"]
        XCTAssertTrue(finishEarly.waitForExistence(timeout: 8))
        finishEarly.tap()

        let alert = app.alerts["Finish this round?"]
        XCTAssertTrue(alert.waitForExistence(timeout: 8))
        alert.buttons["Finish"].tap()

        XCTAssertTrue(waitForRingValue(ring, "0 of 8", timeout: 8), "Fresh round after explicit finish")
        app.buttons["historyButton"].tap()
        XCTAssertTrue(app.staticTexts["3 / 8"].waitForExistence(timeout: 8), "Partial recorded to history")
    }

    /// The practice surface exposes the current mantra through the mantraRow
    /// button's accessibility label ("Mantra: <title>. Change mantra.").
    private func surfaceShowsMantra(_ app: XCUIApplication, _ title: String, timeout: TimeInterval = 8) -> Bool {
        let row = app.buttons["mantraRow"]
        guard row.waitForExistence(timeout: timeout) else { return false }
        let predicate = NSPredicate(format: "label CONTAINS %@", title)
        return XCTWaiter().wait(for: [XCTNSPredicateExpectation(predicate: predicate, object: row)], timeout: timeout) == .completed
    }

    // MARK: History records + deletes

    func testHistoryRecordsCompletedRoundAndDeletes() {
        let app = ephemeralApp(target: 5)
        app.launch()
        dismissIntro(app)

        XCTAssertTrue(app.buttons["advanceRing"].waitForExistence(timeout: 8))
        completeRound(app)
        let rest = app.buttons["Rest"]
        XCTAssertTrue(rest.waitForExistence(timeout: 8))
        rest.tap()
        XCTAssertTrue(
            XCTWaiter().wait(for: [XCTNSPredicateExpectation(
                predicate: NSPredicate(format: "exists == false"),
                object: app.buttons["newRoundButton"]
            )], timeout: 8) == .completed,
            "Completion overlay closes before navigating"
        )

        let historyButton = app.buttons["historyButton"]
        XCTAssertTrue(historyButton.waitForExistence(timeout: 8))
        XCTAssertTrue(
            XCTWaiter().wait(for: [XCTNSPredicateExpectation(
                predicate: NSPredicate(format: "isHittable == true"),
                object: historyButton
            )], timeout: 8) == .completed,
            "History control is tappable after the completion overlay closes"
        )
        var navigationAttempts = 0
        let historyMarker = app.buttons["Clear"]
        while !historyMarker.exists && navigationAttempts < 3 {
            app.buttons["historyButton"].press(forDuration: 0.1)
            navigationAttempts += 1
            _ = historyMarker.waitForExistence(timeout: 3)
        }
        XCTAssertTrue(historyMarker.exists, "History opens")
        let completedCount = app.staticTexts
            .matching(NSPredicate(format: "label == %@ OR label == %@", "5 / 5", "5  5"))
            .firstMatch
        XCTAssertTrue(completedCount.exists, "Completed round is recorded")
        XCTAssertTrue(app.staticTexts["Counting"].exists)
        attach(app, "05-History")

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

    // MARK: Mala style picker

    func testMalaStylePickerNavigateAndApply() {
        let app = ephemeralApp()
        app.launch()
        dismissIntro(app)

        app.buttons["settingsButton"].tap()
        let styleRow = app.buttons["malaStyleRow"]
        XCTAssertTrue(styleRow.waitForExistence(timeout: 8))
        XCTAssertTrue(app.staticTexts["Classic"].exists, "Classic is the default style shown in Settings")
        styleRow.tap()

        // The picker opens live on Classic (the currently applied style).
        XCTAssertTrue(app.staticTexts["Classic"].waitForExistence(timeout: 8))
        let applyButton = app.buttons["malaApplyButton"]
        XCTAssertTrue(applyButton.waitForExistence(timeout: 8))
        XCTAssertEqual(applyButton.label, "Current mala", "Classic starts as the current mala")

        // Step to the next style and confirm the name/apply-state update live.
        // A tap can drop during a first-launch hitch, so retry — but only while
        // the overlay still shows Classic, so a registered tap never overshoots.
        let nextStyleTitle = app.staticTexts["Ultra Minimal"]
        var stepAttempts = 0
        while !nextStyleTitle.exists && stepAttempts < 4 {
            app.buttons["Next style"].tap()
            stepAttempts += 1
            _ = nextStyleTitle.waitForExistence(timeout: 3)
        }
        XCTAssertTrue(nextStyleTitle.exists, "Picker advances to the next style")
        attach(app, "04-Mala-style")
        XCTAssertTrue(
            XCTWaiter().wait(for: [XCTNSPredicateExpectation(
                predicate: NSPredicate(format: "label == %@", "Apply this mala"), object: applyButton)], timeout: 3) == .completed,
            "A not-yet-applied style offers Apply"
        )

        // Live-preview tap: the bead area is tappable and doesn't crash the style.
        app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.45)).tap()

        // Apply it, then confirm Settings reflects the change.
        applyButton.tap()
        XCTAssertTrue(
            XCTWaiter().wait(for: [XCTNSPredicateExpectation(
                predicate: NSPredicate(format: "label == %@", "Applied ✓"), object: applyButton)], timeout: 3) == .completed,
            "Apply confirms with 'Applied ✓'"
        )

        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(app.staticTexts["Ultra Minimal"].waitForExistence(timeout: 8), "Settings shows the newly applied style")
    }
}
