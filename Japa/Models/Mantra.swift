import Foundation

/// A mantra the practitioner can repeat.
///
/// Crucially, mantra text **never affects counting** — it is purely a label for
/// the session. A seed mantra and a user's free-text mantra behave identically
/// in the engine and on the practice screen.
struct Mantra: Identifiable, Codable, Hashable {
    let id: UUID
    /// Short display name, e.g. "Om Namah Shivaya".
    var title: String
    /// Optional script/transliteration shown in larger type, e.g. "ॐ नमः शिवाय".
    var script: String?
    /// A one-line, respectful note. Present only on reviewed seed mantras.
    var note: String?
    /// True for the bundled, human-reviewed seed set; false for user free-text.
    let isSeed: Bool

    init(id: UUID = UUID(), title: String, script: String? = nil, note: String? = nil, isSeed: Bool = false) {
        self.id = id
        self.title = title
        self.script = script
        self.note = note
        self.isSeed = isSeed
    }
}

extension Mantra {
    /// A neutral default so practice is never blocked behind choosing content.
    static let none = Mantra(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
        title: "Counting",
        script: nil,
        note: "Practice without a mantra label.",
        isSeed: true
    )
}
