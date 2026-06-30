import XCTest

/// UI tests over the core flow: advance → increment, undo → decrement, the
/// completion event, navigation, and settings. Runs against an ephemeral app
/// state (`JAPA_UITEST=1`) with a small target so a full round completes in a
/// few taps. Key screens are captured as attachments.
///
/// Taps are confirmed by waiting on the ring's accessibility value rather than
/// assuming each coordinate tap lands instantly — a tap delivered during the
/// full-screen-cover transition would otherwise drop and flake the test.
final class JapaUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    private func makeApp(target: Int = 5) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchEnvironment["JAPA_UITEST"] = "1"
        app.launchEnvironment["JAPA_UITEST_TARGET"] = String(target)
        return app
    }

    private func tapCenter(_ app: XCUIApplication) {
        app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.45)).tap()
    }

    /// Waits until the ring reports the expected accessibility value.
    @discardableResult
    private func waitForRingValue(_ ring: XCUIElement, _ expected: String, timeout: TimeInterval = 3) -> Bool {
        let predicate = NSPredicate(format: "value == %@", expected)
        let exp = XCTNSPredicateExpectation(predicate: predicate, object: ring)
        return XCTWaiter().wait(for: [exp], timeout: timeout) == .completed
    }

    /// Taps the advance area until the ring reaches `expected`, retrying if a tap
    /// is dropped during the present transition. Re-checks before each tap so it
    /// can never overshoot.
    private func advance(_ app: XCUIApplication, _ ring: XCUIElement, to expected: String, maxTaps: Int = 6) {
        var taps = 0
        while (ring.value as? String) != expected && taps < maxTaps {
            tapCenter(app)
            taps += 1
            _ = waitForRingValue(ring, expected, timeout: 2)
        }
        XCTAssertEqual(ring.value as? String, expected)
    }

    private func attach(_ app: XCUIApplication, _ name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    private func dismissIntroAndBegin(_ app: XCUIApplication) {
        let introBegin = app.buttons["introBegin"]
        if introBegin.waitForExistence(timeout: 8) {
            attach(app, "01-Intro")
            introBegin.tap()
        }
        let homeBegin = app.buttons["homeBegin"]
        XCTAssertTrue(homeBegin.waitForExistence(timeout: 8), "Home Begin button should appear")
        attach(app, "02-Home")
        homeBegin.tap()
    }

    func testTapAdvancesAndUndoSteps() {
        let app = makeApp(target: 5)
        app.launch()
        dismissIntroAndBegin(app)

        let ring = app.buttons["advanceRing"]
        XCTAssertTrue(ring.waitForExistence(timeout: 8))
        XCTAssertTrue(waitForRingValue(ring, "0 of 5"), "Practice screen settled at 0")
        attach(app, "03-Practice-start")

        advance(app, ring, to: "1 of 5")
        advance(app, ring, to: "2 of 5")
        attach(app, "04-Practice-counting")

        app.buttons["Undo"].tap()
        XCTAssertTrue(waitForRingValue(ring, "1 of 5"), "Undo steps back one bead")
    }

    func testReachingTargetShowsCompletion() {
        let app = makeApp(target: 5)
        app.launch()
        dismissIntroAndBegin(app)

        let ring = app.buttons["advanceRing"]
        XCTAssertTrue(ring.waitForExistence(timeout: 8))
        XCTAssertTrue(waitForRingValue(ring, "0 of 5"), "Practice screen settled at 0")

        // Tap until completion appears, tolerant of an occasional dropped tap
        // during the present transition (bounded well above the target of 5).
        let newRound = app.buttons["newRoundButton"]
        var taps = 0
        while !newRound.exists && taps < 15 {
            tapCenter(app)
            taps += 1
            _ = newRound.waitForExistence(timeout: 1)
        }

        XCTAssertTrue(newRound.exists, "Completion view appears at the target")
        XCTAssertTrue(app.staticTexts["Round complete"].exists)
        attach(app, "05-Completion")

        newRound.tap()
        XCTAssertTrue(ring.waitForExistence(timeout: 8), "New round returns to practice")
        XCTAssertTrue(waitForRingValue(ring, "0 of 5"))
    }

    func testNavigateSettingsAndHistory() {
        let app = makeApp()
        app.launch()
        let introBegin = app.buttons["introBegin"]
        if introBegin.waitForExistence(timeout: 8) { introBegin.tap() }

        XCTAssertTrue(app.buttons["settingsButton"].waitForExistence(timeout: 8))
        app.buttons["settingsButton"].tap()
        XCTAssertTrue(app.staticTexts["Beads per round"].waitForExistence(timeout: 8))
        attach(app, "06-Settings")
        app.navigationBars.buttons.element(boundBy: 0).tap() // back

        XCTAssertTrue(app.buttons["historyButton"].waitForExistence(timeout: 8))
        app.buttons["historyButton"].tap()
        XCTAssertTrue(app.staticTexts["Your sessions appear here"].waitForExistence(timeout: 8))
        attach(app, "07-History-empty")
    }
}
