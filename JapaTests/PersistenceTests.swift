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
        store.save(prefs, "preferences")

        let loaded = store.load(Preferences.self, "preferences")
        XCTAssertEqual(loaded, prefs)
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
        let state = ActiveSessionState(target: 108, count: 57, mantraTitle: "Om Namah Shivaya", startedAt: Date())
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
        writer.save(ActiveSessionState(target: 54, count: 12, mantraTitle: "Om", startedAt: Date()))
        writer.flush()

        let reader = ActiveSessionStore(persistence: Persistence(directory: dir))
        let restored = reader.load()
        XCTAssertEqual(restored?.count, 12)
        XCTAssertEqual(restored?.target, 54)
    }

    func testActiveSessionClearRemovesSnapshot() {
        let store = ActiveSessionStore(persistence: Persistence(directory: tempDirectory()))
        store.save(ActiveSessionState(target: 108, count: 5, mantraTitle: "Om", startedAt: Date()))
        store.flush()
        store.clear()
        XCTAssertNil(store.load())
    }

    func testLatestSnapshotWinsAfterRapidSaves() {
        // Mirrors the hot path: many quick saves, then a flush — the last must win.
        let store = ActiveSessionStore(persistence: Persistence(directory: tempDirectory()))
        for count in 1...20 {
            store.save(ActiveSessionState(target: 108, count: count, mantraTitle: "Om", startedAt: Date()))
        }
        store.flush()
        XCTAssertEqual(store.load()?.count, 20)
    }
}
