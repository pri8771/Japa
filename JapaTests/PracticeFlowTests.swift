import XCTest
@testable import Japa

/// End-to-end tests over `AppModel` + `PracticeController` using no-op feedback
/// and a temp store — covering completion → history, interruption-resume across
/// a simulated relaunch, partial sessions, preferences/mantra persistence, and a
/// structural guard that no streak concept exists.
@MainActor
final class PracticeFlowTests: XCTestCase {

    private func makeApp() -> AppModel {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent("japa-flow-\(UUID().uuidString)", isDirectory: true)
        return AppModel(persistence: Persistence(directory: dir), haptics: NoopHaptics(), tone: NoopTone())
    }

    func testCompletingRoundRecordsSessionAndClearsResumable() {
        let app = makeApp()
        app.setDefaultTarget(3)
        let controller = app.newPracticeController()
        controller.prepare()

        controller.advance()
        controller.advance()
        XCTAssertEqual(controller.phase, .practicing)
        controller.advance() // reaches target

        XCTAssertEqual(controller.phase, .completed)
        XCTAssertEqual(app.sessions.count, 1)
        XCTAssertTrue(app.sessions.first?.reachedTarget ?? false)
        XCTAssertEqual(app.sessions.first?.completedCount, 3)
        XCTAssertNil(app.resumableState, "A completed round leaves nothing to resume")
    }

    func testInterruptionResumeRestoresExactBeadAcrossRelaunch() {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent("japa-resume-\(UUID().uuidString)", isDirectory: true)
        let persistence = Persistence(directory: dir)

        let app = AppModel(persistence: persistence, haptics: NoopHaptics(), tone: NoopTone())
        app.setDefaultTarget(10)
        let controller = app.newPracticeController()
        controller.prepare()
        for _ in 0..<4 { controller.advance() }
        controller.persistNow() // resign-active backstop / flush

        // Simulated relaunch: a fresh AppModel over the same store.
        let relaunched = AppModel(persistence: persistence, haptics: NoopHaptics(), tone: NoopTone())
        let resumed = relaunched.resumePracticeController()
        XCTAssertNotNil(resumed)
        XCTAssertEqual(resumed?.count, 4, "Exact bead restored — no off-by-one, no reset")
        XCTAssertEqual(resumed?.target, 10)

        // And it counts on to a correct, single completion.
        resumed?.prepare()
        for _ in 4..<10 { resumed?.advance() }
        XCTAssertEqual(resumed?.phase, .completed)
        XCTAssertEqual(relaunched.sessions.count, 1)
    }

    func testEndEarlyRecordsHonestPartial() {
        let app = makeApp()
        app.setDefaultTarget(10)
        let controller = app.newPracticeController()
        controller.prepare()
        controller.advance()
        controller.advance()
        controller.endEarly()

        XCTAssertEqual(app.sessions.count, 1)
        XCTAssertFalse(app.sessions.first?.reachedTarget ?? true)
        XCTAssertEqual(app.sessions.first?.completedCount, 2)
        XCTAssertNil(app.resumableState)
    }

    func testEndEarlyWithZeroCountDiscardsSession() {
        let app = makeApp()
        let controller = app.newPracticeController()
        controller.prepare()
        controller.endEarly()
        XCTAssertTrue(app.sessions.isEmpty, "A zero-count session is not recorded")
    }

    func testHistoryDurationAlwaysIncludesMinutesAndSeconds() {
        let short = PracticeSession(
            startedAt: Date(),
            duration: 9,
            mantraTitle: "Counting",
            target: 5,
            completedCount: 5,
            reachedTarget: true
        )
        let longer = PracticeSession(
            startedAt: Date(),
            duration: 125,
            mantraTitle: "Counting",
            target: 27,
            completedCount: 27,
            reachedTarget: true
        )

        XCTAssertEqual(short.durationText, "0m 9s")
        XCTAssertEqual(longer.durationText, "2m 5s")
    }

    func testSessionDurationExcludesTimeWhileAppIsInactive() {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent("japa-active-duration-\(UUID().uuidString)", isDirectory: true)
        let persistence = Persistence(directory: dir)
        var clock = Date(timeIntervalSince1970: 1_000)
        var recorded: PracticeSession?
        let controller = PracticeController(
            mantra: Mantra.none,
            target: 2,
            startedAt: clock,
            now: { clock },
            preferences: { Preferences() },
            haptics: NoopHaptics(),
            tone: NoopTone(),
            activeStore: ActiveSessionStore(persistence: persistence),
            onFinish: { recorded = $0 }
        )

        controller.prepare()
        clock.addTimeInterval(30)
        controller.advance()
        controller.pauseTiming()

        clock.addTimeInterval(8 * 60 * 60)
        controller.resumeTiming()
        clock.addTimeInterval(15)
        controller.advance()

        XCTAssertNotNil(recorded)
        XCTAssertEqual(recorded!.duration, 45, accuracy: 0.001)
    }

    func testNewRoundResetsDurationOrigin() {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent("japa-new-round-duration-\(UUID().uuidString)", isDirectory: true)
        let persistence = Persistence(directory: dir)
        var clock = Date(timeIntervalSince1970: 2_000)
        var recorded: [PracticeSession] = []
        let controller = PracticeController(
            mantra: Mantra.none,
            target: 1,
            startedAt: clock,
            now: { clock },
            preferences: { Preferences() },
            haptics: NoopHaptics(),
            tone: NoopTone(),
            activeStore: ActiveSessionStore(persistence: persistence),
            onFinish: { recorded.append($0) }
        )

        controller.prepare()
        clock.addTimeInterval(12)
        controller.advance()
        clock.addTimeInterval(3_600)
        controller.startNewRound()
        clock.addTimeInterval(8)
        controller.advance()

        XCTAssertEqual(recorded.map(\.duration), [12, 8])
        XCTAssertEqual(recorded[1].startedAt, Date(timeIntervalSince1970: 5_612))
    }

    func testUndoStepsBackAndDoesNotComplete() {
        let app = makeApp()
        app.setDefaultTarget(2)
        let controller = app.newPracticeController()
        controller.prepare()
        controller.advance()
        controller.undo()
        XCTAssertEqual(controller.count, 0)
        controller.advance()
        XCTAssertEqual(controller.phase, .practicing, "Back at 1 of 2, not complete")
    }

    func testStartNewRoundReturnsToPracticing() {
        let app = makeApp()
        app.setDefaultTarget(1)
        let controller = app.newPracticeController()
        controller.prepare()
        controller.advance() // completes immediately
        XCTAssertEqual(controller.phase, .completed)
        controller.startNewRound()
        XCTAssertEqual(controller.phase, .practicing)
        XCTAssertEqual(controller.count, 0)
    }

    func testCustomMantraPersistsAcrossRelaunch() {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent("japa-mantra-\(UUID().uuidString)", isDirectory: true)
        let persistence = Persistence(directory: dir)
        let app = AppModel(persistence: persistence, haptics: NoopHaptics(), tone: NoopTone())
        let mantra = app.addCustomMantra(title: "My practice", script: "abc")
        XCTAssertNotNil(mantra)

        let relaunched = AppModel(persistence: persistence, haptics: NoopHaptics(), tone: NoopTone())
        XCTAssertTrue(relaunched.customMantras.contains { $0.title == "My practice" })
    }

    func testBlankCustomMantraIsRejected() {
        let app = makeApp()
        XCTAssertNil(app.addCustomMantra(title: "   "))
        XCTAssertTrue(app.customMantras.isEmpty)
    }

    func testSelectedMantraPersists() {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent("japa-sel-\(UUID().uuidString)", isDirectory: true)
        let persistence = Persistence(directory: dir)
        let app = AppModel(persistence: persistence, haptics: NoopHaptics(), tone: NoopTone())
        let target = app.addCustomMantra(title: "My selected practice")!
        app.select(target)

        let relaunched = AppModel(persistence: persistence, haptics: NoopHaptics(), tone: NoopTone())
        XCTAssertEqual(relaunched.selectedMantra.id, target.id)
    }

    // MARK: Preferences & resumable state

    func testPreferenceSettersPersist() {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent("japa-prefs-\(UUID().uuidString)", isDirectory: true)
        let persistence = Persistence(directory: dir)
        let app = AppModel(persistence: persistence, haptics: NoopHaptics(), tone: NoopTone())
        app.setDefaultTarget(27)
        app.setCompletionToneEnabled(false)
        app.setHapticIntensity(0.3)
        app.setMalaStyle(.zenInk)

        let relaunched = AppModel(persistence: persistence, haptics: NoopHaptics(), tone: NoopTone())
        XCTAssertEqual(relaunched.preferences.defaultTarget, 27)
        XCTAssertFalse(relaunched.preferences.completionToneEnabled)
        XCTAssertEqual(relaunched.preferences.hapticIntensity, 0.3, accuracy: 0.0001)
        XCTAssertEqual(relaunched.preferences.malaStyle, .zenInk)
    }

    func testSetDefaultTargetClampsOutOfRange() {
        let app = makeApp()
        app.setDefaultTarget(99999)
        XCTAssertEqual(app.preferences.defaultTarget, JapaEngine.maxTarget)
        app.setDefaultTarget(0)
        XCTAssertEqual(app.preferences.defaultTarget, JapaEngine.minTarget)
    }

    func testRefreshResumableReflectsInProgressRound() {
        let app = makeApp()
        app.setDefaultTarget(10)
        XCTAssertNil(app.resumableState)
        let controller = app.newPracticeController()
        controller.prepare()
        controller.advance()
        controller.advance()
        controller.persistNow()

        app.refreshResumable()
        XCTAssertEqual(app.resumableState?.count, 2)

        // Completing the round clears the resumable snapshot.
        for _ in 0..<8 { controller.advance() }
        app.refreshResumable()
        XCTAssertNil(app.resumableState)
    }

    func testDiscardResumableClearsCacheAndDisk() {
        let app = makeApp()
        app.setDefaultTarget(10)
        let controller = app.newPracticeController()
        controller.prepare()
        controller.advance()
        controller.persistNow()
        app.refreshResumable()
        XCTAssertNotNil(app.resumableState)

        app.discardResumable()
        XCTAssertNil(app.resumableState)
        app.refreshResumable()
        XCTAssertNil(app.resumableState, "Cleared on disk too")
    }

    func testDeletingSelectedCustomMantraResetsSelection() {
        let app = makeApp()
        let mantra = app.addCustomMantra(title: "Temp")!
        app.select(mantra)
        XCTAssertEqual(app.selectedMantra.id, mantra.id)
        app.deleteCustomMantra(mantra)
        XCTAssertNotEqual(app.selectedMantra.id, mantra.id, "Selection falls back to the neutral default")
        XCTAssertTrue(app.selectedMantra.isSeed)
    }

    // MARK: Tone gate (no streaks anywhere)

    func testModelsHaveNoStreakOrChainConcept() {
        let session = PracticeSession(startedAt: Date(), duration: 1, mantraTitle: "Om", target: 108, completedCount: 108, reachedTarget: true)
        assertNoStreakProperties(in: session)
        assertNoStreakProperties(in: Preferences())
        assertNoStreakProperties(in: Mantra(title: "Om"))
    }

    private func assertNoStreakProperties(in value: Any) {
        for child in Mirror(reflecting: value).children {
            let name = (child.label ?? "").lowercased()
            XCTAssertFalse(name.contains("streak"), "Found a streak property: \(name)")
            XCTAssertFalse(name.contains("chain"), "Found a chain property: \(name)")
        }
    }

    // MARK: Stale-round finish prompt

    func testStalenessSurvivesRelaunchAndTracksInteraction() {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent("japa-stale-\(UUID().uuidString)", isDirectory: true)
        let persistence = Persistence(directory: dir)

        let app = AppModel(persistence: persistence, haptics: NoopHaptics(), tone: NoopTone())
        app.setDefaultTarget(10)
        let controller = app.newPracticeController()
        controller.prepare()
        controller.advance()
        controller.advance()
        XCTAssertFalse(controller.isStale(after: 60), "Just interacted — not stale")
        XCTAssertTrue(controller.isStale(after: 0), "Zero threshold means any counted round is stale")
        controller.persistNow()

        // Relaunch restores the *interaction* timestamp, not "now" — a round
        // left overnight is recognized as stale even across a force-quit.
        let relaunched = AppModel(persistence: persistence, haptics: NoopHaptics(), tone: NoopTone())
        let resumed = relaunched.resumePracticeController()
        XCTAssertNotNil(resumed)
        XCTAssertTrue(resumed!.isStale(after: 0))
        XCTAssertFalse(resumed!.isStale(after: 3600))
    }

    func testFreshAndCompletedRoundsAreNeverStale() {
        let app = makeApp()
        app.setDefaultTarget(2)
        let controller = app.newPracticeController()
        controller.prepare()
        XCTAssertFalse(controller.isStale(after: 0), "A zero-count round is never stale")
        controller.advance()
        controller.advance() // completes
        XCTAssertEqual(controller.phase, .completed)
        XCTAssertFalse(controller.isStale(after: 0), "A completed round is never stale")
    }

    func testFinishEarlyRecordsHonestPartialAndStartsFresh() {
        let app = makeApp()
        app.setDefaultTarget(10)
        let controller = app.newPracticeController()
        controller.prepare()
        for _ in 0..<3 { controller.advance() }

        controller.finishEarly()

        XCTAssertEqual(app.sessions.count, 1)
        XCTAssertEqual(app.sessions.first?.completedCount, 3)
        XCTAssertFalse(app.sessions.first?.reachedTarget ?? true, "Finish records an honest partial")
        XCTAssertEqual(controller.count, 0, "Finish starts a fresh round in place")
        XCTAssertEqual(controller.phase, .practicing)
    }

    func testTouchClearsStalenessAfterKeepGoing() {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent("japa-touch-\(UUID().uuidString)", isDirectory: true)
        let persistence = Persistence(directory: dir)

        // Persist a round whose last interaction was an hour ago.
        let store = ActiveSessionStore(persistence: persistence)
        store.save(ActiveSessionState(
            target: 10, count: 4, mantraTitle: "Om",
            startedAt: Date(timeIntervalSinceNow: -7200),
            updatedAt: Date(timeIntervalSinceNow: -3600)
        ))
        store.flush()

        let app = AppModel(persistence: persistence, haptics: NoopHaptics(), tone: NoopTone())
        let resumed = app.resumePracticeController()
        XCTAssertNotNil(resumed)
        XCTAssertTrue(resumed!.isStale(after: 1800), "An hour-old interaction is stale past 30 min")

        resumed!.touch() // "Keep going"
        XCTAssertFalse(resumed!.isStale(after: 1800), "Keep going counts as an interaction")
    }
}
