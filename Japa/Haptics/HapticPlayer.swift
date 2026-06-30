import CoreHaptics
import UIKit

/// The real haptic engine.
///
/// On devices with the Taptic Engine it uses Core Haptics for a crisp per-bead
/// transient and a *perceptibly distinct* completion pattern (a short rising
/// swell capped by a firm transient — felt as "round done", not "another bead").
/// On devices without Core Haptics it falls back to `UIFeedbackGenerator`.
///
/// All paths fire independently of the silent switch — haptics are tactile, not
/// audio — which is exactly what eyes-free, screen-off practice needs.
@MainActor
final class HapticPlayer: HapticFeedback {

    private let supportsHaptics = CHHapticEngine.capabilitiesForHardware().supportsHaptics
    private var engine: CHHapticEngine?

    // Fallback generators (also used as a belt-and-braces secondary cue).
    private let impactLight = UIImpactFeedbackGenerator(style: .rigid)
    private let impactSoft = UIImpactFeedbackGenerator(style: .soft)
    private let notification = UINotificationFeedbackGenerator()

    func prepare() {
        guard supportsHaptics else {
            impactLight.prepare()
            notification.prepare()
            return
        }
        startEngineIfNeeded()
    }

    private func startEngineIfNeeded() {
        guard supportsHaptics, engine == nil else { return }
        do {
            let engine = try CHHapticEngine()
            engine.isAutoShutdownEnabled = true
            // Core Haptics stops the engine on interruptions; restart it so the
            // next bead still fires.
            engine.resetHandler = { [weak self] in
                try? self?.engine?.start()
            }
            engine.stoppedHandler = { _ in }
            try engine.start()
            self.engine = engine
        } catch {
            engine = nil // fall back to UIFeedbackGenerator
        }
    }

    // MARK: Per-bead tick

    func tick(intensity: Double) {
        let clamped = Float(min(max(intensity, 0), 1))
        guard supportsHaptics, let engine else {
            impactLight.impactOccurred(intensity: CGFloat(max(0.25, clamped)))
            impactLight.prepare()
            return
        }
        let event = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: clamped),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.75)
            ],
            relativeTime: 0
        )
        play(events: [event], on: engine)
    }

    // MARK: Distinct completion

    func completion() {
        guard supportsHaptics, let engine else {
            notification.notificationOccurred(.success)
            notification.prepare()
            return
        }
        // A short rising swell, then a firm transient — deliberately unlike a tick.
        let swell = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.6),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
            ],
            relativeTime: 0,
            duration: 0.32
        )
        let cap = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.6)
            ],
            relativeTime: 0.34
        )
        let rise = CHHapticParameterCurve(
            parameterID: .hapticIntensityControl,
            controlPoints: [
                .init(relativeTime: 0, value: 0.2),
                .init(relativeTime: 0.32, value: 1.0)
            ],
            relativeTime: 0
        )
        play(events: [swell, cap], curves: [rise], on: engine)
    }

    // MARK: Undo

    func back() {
        guard supportsHaptics, let engine else {
            impactSoft.impactOccurred(intensity: 0.5)
            impactSoft.prepare()
            return
        }
        let event = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.45),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.25)
            ],
            relativeTime: 0
        )
        play(events: [event], on: engine)
    }

    // MARK: Engine plumbing

    private func play(events: [CHHapticEvent], curves: [CHHapticParameterCurve] = [], on engine: CHHapticEngine) {
        do {
            let pattern = try CHHapticPattern(events: events, parameterCurves: curves)
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
        } catch {
            // If a play fails (engine reset mid-interaction), restart and drop this
            // one event rather than stalling the loop.
            self.engine = nil
            startEngineIfNeeded()
        }
    }
}
