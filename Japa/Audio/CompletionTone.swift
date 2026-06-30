import AVFoundation

/// Plays the single gentle tone that accompanies round completion.
@MainActor
protocol TonePlaying: AnyObject {
    func prepare()
    func play()
}

/// No-op tone for previews and tests.
@MainActor
final class NoopTone: TonePlaying {
    func prepare() {}
    func play() {}
}

/// Synthesizes and plays a soft, bell-like completion tone.
///
/// The tone is generated in memory (no bundled audio file) as a short, warm
/// chord with an exponential decay. It uses the `.ambient` audio session so it
/// **respects the silent switch** and never interrupts other audio — the
/// completion *haptic* carries the signal when the device is muted.
@MainActor
final class CompletionTonePlayer: TonePlaying {
    private var player: AVAudioPlayer?

    func prepare() {
        guard player == nil else { return }
        guard let data = Self.toneData else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            let player = try AVAudioPlayer(data: data)
            player.volume = 0.7
            player.prepareToPlay()
            self.player = player
        } catch {
            player = nil
        }
    }

    func play() {
        if player == nil { prepare() }
        guard let player else { return }
        try? AVAudioSession.sharedInstance().setActive(true)
        player.currentTime = 0
        player.play()
    }

    // MARK: Synthesis

    /// A warm three-note tone (a calm, consonant chord) with a gentle attack and
    /// long exponential decay — closer to a singing bowl than a chime.
    private static let toneData: Data? = makeWAV(
        frequencies: [261.63, 392.0, 523.25], // C4, G4, C5
        weights: [1.0, 0.45, 0.3],
        duration: 1.8,
        sampleRate: 44_100
    )

    private static func makeWAV(
        frequencies: [Double],
        weights: [Double],
        duration: Double,
        sampleRate: Double
    ) -> Data? {
        let frameCount = Int(duration * sampleRate)
        var samples = [Int16]()
        samples.reserveCapacity(frameCount)

        let attack = 0.012 * sampleRate
        let totalWeight = weights.reduce(0, +)

        for i in 0..<frameCount {
            let t = Double(i) / sampleRate
            var value = 0.0
            for (freq, weight) in zip(frequencies, weights) {
                value += weight * sin(2.0 * .pi * freq * t)
            }
            value /= max(totalWeight, 0.0001)

            // Exponential decay for a soft, fading bell.
            let decay = exp(-3.2 * t)
            // Short attack ramp to avoid a click at onset.
            let attackGain = Double(i) < attack ? Double(i) / attack : 1.0
            let amplitude = 0.55 * decay * attackGain

            let scaled = max(-1.0, min(1.0, value * amplitude))
            samples.append(Int16(scaled * Double(Int16.max)))
        }

        return encodeWAV(samples: samples, sampleRate: Int(sampleRate))
    }

    private static func encodeWAV(samples: [Int16], sampleRate: Int) -> Data {
        let channels = 1
        let bitsPerSample = 16
        let byteRate = sampleRate * channels * bitsPerSample / 8
        let blockAlign = channels * bitsPerSample / 8
        let dataSize = samples.count * bitsPerSample / 8

        var data = Data()
        func appendString(_ s: String) { data.append(contentsOf: s.utf8) }
        func appendUInt32(_ v: UInt32) { var x = v.littleEndian; withUnsafeBytes(of: &x) { data.append(contentsOf: $0) } }
        func appendUInt16(_ v: UInt16) { var x = v.littleEndian; withUnsafeBytes(of: &x) { data.append(contentsOf: $0) } }

        appendString("RIFF")
        appendUInt32(UInt32(36 + dataSize))
        appendString("WAVE")
        appendString("fmt ")
        appendUInt32(16)
        appendUInt16(1) // PCM
        appendUInt16(UInt16(channels))
        appendUInt32(UInt32(sampleRate))
        appendUInt32(UInt32(byteRate))
        appendUInt16(UInt16(blockAlign))
        appendUInt16(UInt16(bitsPerSample))
        appendString("data")
        appendUInt32(UInt32(dataSize))
        for sample in samples {
            var s = sample.littleEndian
            withUnsafeBytes(of: &s) { data.append(contentsOf: $0) }
        }
        return data
    }
}
