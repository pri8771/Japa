import XCTest

/// UI tests over the core flow: advance → increment, undo → decrement, the
/// completion event, navigation, and settings. Runs against an ephemeral app
/// state (`JAPA_UITEST=1`) with a small target so a full round completes in a
/// few taps. Key screens are captured as attachments.
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

    private func attach(_ app: XCUIApplication, _ name: String) {
        let shot = app.screenshot()
        let attachment = XCTAttachment(screenshot: shot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    private func dismissIntroAndBegin(_ app: XCUIApplication) {
        let introBegin = app.buttons["introBegin"]
        if introBegin.waitForExistence(timeout: 5) {
            attach(app, "01-Intro")
            introBegin.tap()
        }
        attach(app, "02-Home")
        let homeBegin = app.buttons["homeBegin"]
        XCTAssertTrue(homeBegin.waitForExistence(timeout: 5), "Home Begin button should appear")
        homeBegin.tap()
    }

    func testTapAdvancesAndUndoSteps() {
        let app = makeApp(target: 5)
        app.launch()
        dismissIntroAndBegin(app)

        let ring = app.buttons["advanceRing"]
        XCTAssertTrue(ring.waitForExistence(timeout: 5))
        XCTAssertEqual(ring.value as? String, "0 of 5")
        attach(app, "03-Practice-start")

        tapCenter(app)
        XCTAssertEqual(ring.value as? String, "1 of 5")
        tapCenter(app)
        XCTAssertEqual(ring.value as? String, "2 of 5")
        attach(app, "04-Practice-counting")

        app.buttons["Undo"].tap()
        XCTAssertEqual(ring.value as? String, "1 of 5", "Undo steps back one bead")
    }

    func testReachingTargetShowsCompletion() {
        let app = makeApp(target: 5)
        app.launch()
        dismissIntroAndBegin(app)

        let ring = app.buttons["advanceRing"]
        XCTAssertTrue(ring.waitForExistence(timeout: 5))
        for _ in 0..<5 { tapCenter(app) }

        let newRound = app.buttons["newRoundButton"]
        XCTAssertTrue(newRound.waitForExistence(timeout: 5), "Completion view appears at the target")
        XCTAssertTrue(app.staticTexts["Round complete"].exists)
        attach(app, "05-Completion")

        newRound.tap()
        XCTAssertTrue(ring.waitForExistence(timeout: 5), "New round returns to practice")
        XCTAssertEqual(ring.value as? String, "0 of 5")
    }

    func testNavigateSettingsAndHistory() {
        let app = makeApp()
        app.launch()
        let introBegin = app.buttons["introBegin"]
        if introBegin.waitForExistence(timeout: 5) { introBegin.tap() }

        app.buttons["settingsButton"].tap()
        XCTAssertTrue(app.staticTexts["Beads per round"].waitForExistence(timeout: 5))
        attach(app, "06-Settings")
        app.navigationBars.buttons.element(boundBy: 0).tap() // back

        app.buttons["historyButton"].tap()
        XCTAssertTrue(app.staticTexts["Your sessions appear here"].waitForExistence(timeout: 5))
        attach(app, "07-History-empty")
    }
}
