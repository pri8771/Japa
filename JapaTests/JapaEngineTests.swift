import XCTest
@testable import Japa

/// Unit tests for the repetition engine — the named hard gate (F1/B2).
///
/// Covers: counting, exactly-once completion at N only, custom targets,
/// boundary and invalid targets, advance-past-target, undo/decrement floor,
/// reset / explicit new round, and engine reconstruction from persisted state.
final class JapaEngineTests: XCTestCase {

    // MARK: Counting

    func testFreshEngineDefaultsTo108AtZero() {
        let engine = JapaEngine()
        XCTAssertEqual(engine.target, 108)
        XCTAssertEqual(engine.count, 0)
        XCTAssertFalse(engine.isComplete)
    }

    func testAdvanceIncrementsAndDoesNotCompleteBeforeTarget() {
        var engine = JapaEngine(target: 5)
        for k in 1..<5 {
            let result = engine.advance()
            XCTAssertEqual(result, .advanced(count: k))
            XCTAssertEqual(engine.count, k)
            XCTAssertFalse(engine.isComplete, "Completion must not fire before the target")
        }
    }

    func testCountReachesTargetExactly() {
        var engine = JapaEngine(target: 108)
        for _ in 0..<108 { engine.advance() }
        XCTAssertEqual(engine.count, 108)
        XCTAssertTrue(engine.isComplete)
    }

    // MARK: Completion fires exactly once, at N only

    func testCompletionFiresExactlyOnceAtTarget() {
        var engine = JapaEngine(target: 3)
        XCTAssertEqual(engine.advance(), .advanced(count: 1))
        XCTAssertEqual(engine.advance(), .advanced(count: 2))
        XCTAssertEqual(engine.advance(), .completed(count: 3), "Completion fires on the tick count == target")
    }

    func testCompletionCounterAcrossFullRoundFiresOnce() {
        var engine = JapaEngine(target: 108)
        var completions = 0
        for _ in 0..<108 {
            if case .completed = engine.advance() { completions += 1 }
        }
        XCTAssertEqual(completions, 1, "Exactly one completion event across a full round")
    }

    func testTargetOfOneCompletesOnFirstAdvance() {
        var engine = JapaEngine(target: 1)
        XCTAssertEqual(engine.advance(), .completed(count: 1))
    }

    // MARK: Advance past target

    func testAdvancePastTargetReturnsAlreadyCompleteAndPinsCount() {
        var engine = JapaEngine(target: 2)
        engine.advance()
        XCTAssertEqual(engine.advance(), .completed(count: 2))
        XCTAssertEqual(engine.advance(), .alreadyComplete(count: 2))
        XCTAssertEqual(engine.advance(), .alreadyComplete(count: 2))
        XCTAssertEqual(engine.count, 2, "Count pins at target; no over-counting")
    }

    func testAdvancePastTargetNeverFiresASecondCompletion() {
        var engine = JapaEngine(target: 2)
        engine.advance()
        engine.advance() // completes
        var extraCompletions = 0
        for _ in 0..<10 {
            if case .completed = engine.advance() { extraCompletions += 1 }
        }
        XCTAssertEqual(extraCompletions, 0)
    }

    // MARK: Custom / boundary / invalid targets

    func testCustomTargetCounting() {
        var engine = JapaEngine(target: 27)
        for _ in 0..<26 { engine.advance() }
        XCTAssertFalse(engine.isComplete)
        XCTAssertEqual(engine.advance(), .completed(count: 27))
    }

    func testBoundaryTargetsAreValid() {
        XCTAssertTrue(JapaEngine.isValidTarget(JapaEngine.minTarget))
        XCTAssertTrue(JapaEngine.isValidTarget(JapaEngine.maxTarget))
        XCTAssertTrue(JapaEngine.isValidTarget(108))
    }

    func testInvalidTargetsAreRejected() {
        XCTAssertFalse(JapaEngine.isValidTarget(0))
        XCTAssertFalse(JapaEngine.isValidTarget(-5))
        XCTAssertFalse(JapaEngine.isValidTarget(JapaEngine.maxTarget + 1))
    }

    func testInitClampsOutOfRangeTarget() {
        XCTAssertEqual(JapaEngine(target: 0).target, JapaEngine.minTarget)
        XCTAssertEqual(JapaEngine(target: -10).target, JapaEngine.minTarget)
        XCTAssertEqual(JapaEngine(target: 999_999).target, JapaEngine.maxTarget)
    }

    func testConfigureRejectsInvalidTargetAndKeepsState() {
        var engine = JapaEngine(target: 108)
        engine.advance()
        XCTAssertFalse(engine.configure(target: 0))
        XCTAssertFalse(engine.configure(target: -1))
        XCTAssertFalse(engine.configure(target: JapaEngine.maxTarget + 100))
        XCTAssertEqual(engine.target, 108, "Rejected configure must not change the target")
        XCTAssertEqual(engine.count, 1)
    }

    func testConfigureAppliesValidTarget() {
        var engine = JapaEngine(target: 108)
        XCTAssertTrue(engine.configure(target: 27))
        XCTAssertEqual(engine.target, 27)
    }

    func testConfigureBelowCurrentCountPullsCountDownToTarget() {
        var engine = JapaEngine(target: 108)
        for _ in 0..<50 { engine.advance() }
        XCTAssertTrue(engine.configure(target: 27))
        XCTAssertEqual(engine.count, 27)
        XCTAssertTrue(engine.isComplete)
    }

    // MARK: Undo / decrement

    func testUndoDecrementsByOne() {
        var engine = JapaEngine(target: 108)
        engine.advance(); engine.advance(); engine.advance()
        XCTAssertTrue(engine.undo())
        XCTAssertEqual(engine.count, 2)
    }

    func testUndoFloorsAtZero() {
        var engine = JapaEngine(target: 108)
        XCTAssertFalse(engine.undo(), "Undo at zero is a no-op")
        XCTAssertEqual(engine.count, 0)
    }

    func testUndoFromTargetReopensRoundWithoutCompletion() {
        var engine = JapaEngine(target: 3)
        engine.advance(); engine.advance(); engine.advance() // complete
        XCTAssertTrue(engine.isComplete)
        XCTAssertTrue(engine.undo())
        XCTAssertEqual(engine.count, 2)
        XCTAssertFalse(engine.isComplete, "Undo re-opens the round")
        // Re-advancing fires completion again (a fresh, legitimate completion tick).
        XCTAssertEqual(engine.advance(), .completed(count: 3))
    }

    // MARK: Reset / new round

    func testResetReturnsToZeroKeepingTarget() {
        var engine = JapaEngine(target: 27)
        for _ in 0..<27 { engine.advance() }
        engine.reset()
        XCTAssertEqual(engine.count, 0)
        XCTAssertEqual(engine.target, 27)
        XCTAssertFalse(engine.isComplete)
    }

    func testStartNewRoundFromCompletedAllowsCountingAgain() {
        var engine = JapaEngine(target: 2)
        engine.advance(); engine.advance() // complete
        engine.startNewRound()
        XCTAssertEqual(engine.count, 0)
        XCTAssertEqual(engine.advance(), .advanced(count: 1))
    }

    // MARK: Derived values

    func testProgressAndRemaining() {
        var engine = JapaEngine(target: 4)
        XCTAssertEqual(engine.progress, 0)
        XCTAssertEqual(engine.remaining, 4)
        engine.advance(); engine.advance()
        XCTAssertEqual(engine.progress, 0.5, accuracy: 0.0001)
        XCTAssertEqual(engine.remaining, 2)
    }

    // MARK: Reconstruction from persisted state (interruption-resume support)

    func testReconstructFromPersistedCountRestoresExactBead() {
        // Simulates relaunch: rebuild the engine from a persisted (target, count).
        let restored = JapaEngine(target: 108, count: 57)
        XCTAssertEqual(restored.count, 57)
        XCTAssertEqual(restored.target, 108)
        XCTAssertFalse(restored.isComplete)
        // And it continues correctly toward completion with no off-by-one.
        var engine = restored
        for _ in 57..<108 { engine.advance() }
        XCTAssertTrue(engine.isComplete)
        XCTAssertEqual(engine.count, 108)
    }

    func testReconstructClampsCountIntoRange() {
        XCTAssertEqual(JapaEngine(target: 10, count: 999).count, 10)
        XCTAssertEqual(JapaEngine(target: 10, count: -5).count, 0)
    }
}
