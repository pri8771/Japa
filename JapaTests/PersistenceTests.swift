import XCTest
@testable import Japa

final class PersistenceTests: XCTestCase {

    private func tempDirectory() -> URL {
        FileManager.default.temporaryDirectory
            .appendingPathComponent("japa-tests-\(UUID().uuidString)", isDirectory: true)
    }

    // MARK: Codable round-trips

    func testPreferencesRoundTrip() {
        let store = Persistence(directory: tempDirectory())
        var prefs = Preferences()
        prefs.defaultTarget = 27
        prefs.completionToneEnabled = false
        prefs.hapticIntensity = 0.4
        prefs.malaStyle = .templeBrass
        store.save(prefs, "preferences")

        let loaded = store.load(Preferences.self, "preferences")
        XCTAssertEqual(loaded, prefs)
    }

    func testOldPreferencesWithoutMalaStyleDecodeToClassic() throws {
        let json = """
        {
          "defaultTarget": 54,
          "completionToneEnabled": false,
          "hapticIntensity": 0.35,
          "hasSeenIntro": true
        }
        """
        let prefs = try JSONDecoder().decode(Preferences.self, from: Data(json.utf8))
        XCTAssertEqual(prefs.defaultTarget, 54)
        XCTAssertFalse(prefs.completionToneEnabled)
        XCTAssertEqual(prefs.hapticIntensity, 0.35, accuracy: 0.0001)
        XCTAssertTrue(prefs.hasSeenIntro)
        XCTAssertEqual(prefs.malaStyle, .classic)
    }

    func testUnknownMalaStyleFallsBackWithoutDiscardingPreferences() throws {
        // An unrecognized malaStyle raw value (e.g. an app downgrade, or a style
        // removed/renumbered in a future build) must fall back to the default
        // style while preserving every other saved preference — it must NOT throw
        // and wipe the whole file back to fresh defaults.
        let json = """
        {
          "defaultTarget": 216,
          "completionToneEnabled": false,
          "hapticIntensity": 0.42,
          "hasSeenIntro": true,
          "malaStyle": 9999
        }
        """
        let prefs = try JSONDecoder().decode(Preferences.self, from: Data(json.utf8))
        XCTAssertEqual(prefs.defaultTarget, 216)
        XCTAssertFalse(prefs.completionToneEnabled)
        XCTAssertEqual(prefs.hapticIntensity, 0.42, accuracy: 0.0001)
        XCTAssertTrue(prefs.hasSeenIntro)
        XCTAssertEqual(prefs.malaStyle, Preferences().malaStyle)
    }

    func testSessionsRoundTrip() {
        let store = Persistence(directory: tempDirectory())
        let sessions = [
            PracticeSession(startedAt: Date(timeIntervalSince1970: 1000), duration: 120, mantraTitle: "Om", target: 108, completedCount: 108, reachedTarget: true),
            PracticeSession(startedAt: Date(timeIntervalSince1970: 2000), duration: 30, mantraTitle: "Custom", target: 27, completedCount: 9, reachedTarget: false)
        ]
        store.save(sessions, "sessions")
        XCTAssertEqual(store.load([PracticeSession].self, "sessions"), sessions)
    }

    func testLoadMissingFileReturnsNil() {
        let store = Persistence(directory: tempDirectory())
        XCTAssertNil(store.load(Preferences.self, "nope"))
    }

    func testDeleteRemovesFile() {
        let store = Persistence(directory: tempDirectory())
        store.save(Preferences(), "preferences")
        store.delete("preferences")
        XCTAssertNil(store.load(Preferences.self, "preferences"))
    }

    // MARK: Active-session store (interruption safety)

    func testActiveSessionSaveFlushLoadReconstructsExactBead() {
        let store = ActiveSessionStore(persistence: Persistence(directory: tempDirectory()))
        let state = ActiveSessionState(target: 108, count: 57, mantraTitle: "Prior label", startedAt: Date(), updatedAt: Date())
        store.save(state)
        store.flush()

        let restored = store.load()
        XCTAssertEqual(restored?.count, 57)
        XCTAssertEqual(restored?.target, 108)
        XCTAssertEqual(restored?.makeEngine().count, 57)
    }

    func testActiveSessionSurvivesAcrossNewStoreInstance() {
        // Simulates force-quit + relaunch: a brand-new store reading the same dir.
        let dir = tempDirectory()
        let writer = ActiveSessionStore(persistence: Persistence(directory: dir))
        writer.save(ActiveSessionState(target: 54, count: 12, mantraTitle: "Om", startedAt: Date(), updatedAt: Date()))
        writer.flush()

        let reader = ActiveSessionStore(persistence: Persistence(directory: dir))
        let restored = reader.load()
        XCTAssertEqual(restored?.count, 12)
        XCTAssertEqual(restored?.target, 54)
    }

    func testActiveSessionClearRemovesSnapshot() {
        let store = ActiveSessionStore(persistence: Persistence(directory: tempDirectory()))
        store.save(ActiveSessionState(target: 108, count: 5, mantraTitle: "Om", startedAt: Date(), updatedAt: Date()))
        store.flush()
        store.clear()
        XCTAssertNil(store.load())
    }

    func testLegacyActiveSnapshotWithoutUpdatedAtStillDecodes() throws {
        // Snapshots saved before `updatedAt` existed must still load, falling
        // back to `startedAt`, so an in-flight round survives the app update.
        let json = """
        {
          "target": 54,
          "count": 12,
          "mantraTitle": "Om",
          "startedAt": "2026-07-17T10:00:00Z"
        }
        """
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let state = try decoder.decode(ActiveSessionState.self, from: Data(json.utf8))
        XCTAssertEqual(state.count, 12)
        XCTAssertEqual(state.updatedAt, state.startedAt, "Legacy snapshots treat the start as the last interaction")
    }

    func testLatestSnapshotWinsAfterRapidSaves() {
        // Mirrors the hot path: many quick saves, then a flush — the last must win.
        let store = ActiveSessionStore(persistence: Persistence(directory: tempDirectory()))
        for count in 1...20 {
            store.save(ActiveSessionState(target: 108, count: count, mantraTitle: "Om", startedAt: Date(), updatedAt: Date()))
        }
        store.flush()
        XCTAssertEqual(store.load()?.count, 20)
    }
}
