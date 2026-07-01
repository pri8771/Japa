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
///
/// Reliability matters here more than anywhere: japa taps can be seconds apart,
/// and interruptions (a phone call) are the exact scenario this app is built
/// around. So the engine keeps auto-shutdown **off** (it must not stop itself
/// between slow taps), restarts proactively when the app returns to the
/// foreground, and — if a play still fails mid-round — restarts and retries once
/// rather than dropping the bead's confirmation.
@MainActor
final class HapticPlayer: HapticFeedback {

    private let supportsHaptics = CHHapticEngine.capabilitiesForHardware().supportsHaptics
    private var engine: CHHapticEngine?

    // Fallback generators (also used as a belt-and-braces secondary cue).
    private let impactLight = UIImpactFeedbackGenerator(style: .rigid)
    private let impactSoft = UIImpactFeedbackGenerator(style: .soft)
    private let notification = UINotificationFeedbackGenerator()

    init() {
        // Resume the engine when the app returns to the foreground — iOS stops
        // Core Haptics while suspended (a call, backgrounding), and we must not
        // drop the first tap after the interruption this app exists to survive.
        NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            MainActor.assumeIsolated { self?.resume() }
        }
    }

    func prepare() {
        guard supportsHaptics else {
            impactLight.prepare()
            impactSoft.prepare()
            notification.prepare()
            return
        }
        startEngineIfNeeded()
    }

    /// Restart the engine after a foreground transition.
    private func resume() {
        guard supportsHaptics else { return }
        if engine == nil {
            startEngineIfNeeded()
        } else {
            try? engine?.start()
        }
    }

    private func startEngineIfNeeded() {
        guard supportsHaptics, engine == nil else { return }
        do {
            let engine = try CHHapticEngine()
            // Keep the engine alive between taps — japa taps are slow, and
            // auto-shutdown would stop it and drop the next bead's haptic.
            engine.isAutoShutdownEnabled = false
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
        guard supportsHaptics else {
            impactLight.impactOccurred(intensity: CGFloat(max(0.25, clamped)))
            impactLight.prepare()
            return
        }
        play([
            CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: clamped),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.75)
                ],
                relativeTime: 0
            )
        ], fallback: {
            self.impactLight.impactOccurred(intensity: CGFloat(max(0.25, clamped)))
            self.impactLight.prepare()
        })
    }

    // MARK: Distinct completion

    func completion() {
        guard supportsHaptics else {
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
        play([swell, cap], curves: [rise], fallback: {
            self.notification.notificationOccurred(.success)
            self.notification.prepare()
        })
    }

    // MARK: Undo

    func back() {
        guard supportsHaptics else {
            impactSoft.impactOccurred(intensity: 0.5)
            impactSoft.prepare()
            return
        }
        play([
            CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.45),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.25)
                ],
                relativeTime: 0
            )
        ], fallback: {
            self.impactSoft.impactOccurred(intensity: 0.5)
            self.impactSoft.prepare()
        })
    }

    // MARK: Engine plumbing

    /// Plays a pattern, restarting the engine and retrying once if the first
    /// attempt fails (e.g. the engine was stopped by an interruption). Only if
    /// the retry also fails do we drop to the `UIFeedbackGenerator` fallback, so
    /// a bead is never left entirely unconfirmed.
    private func play(_ events: [CHHapticEvent], curves: [CHHapticParameterCurve] = [], fallback: () -> Void) {
        startEngineIfNeeded()
        if attemptPlay(events, curves) { return }
        // Restart and retry once.
        engine = nil
        startEngineIfNeeded()
        if attemptPlay(events, curves) { return }
        fallback()
    }

    private func attemptPlay(_ events: [CHHapticEvent], _ curves: [CHHapticParameterCurve]) -> Bool {
        guard let engine else { return false }
        do {
            let pattern = try CHHapticPattern(events: events, parameterCurves: curves)
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
            return true
        } catch {
            return false
        }
    }
}
