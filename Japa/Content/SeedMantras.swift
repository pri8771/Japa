import Foundation

/// The tiny, reviewed seed set of mantras bundled with Japa.
///
/// This set is intentionally small. Practice is never gated behind a content
/// library — anyone can add their own free-text mantra (see `AppModel`). These
/// entries are widely-known, traditional mantras with a short, neutral gloss.
///
/// - Important: Mantra *text never affects counting*. These are labels only.
/// - Note: The launch checklist requires a qualified human to sign off on the
///   accuracy and respectfulness of this text before App Store submission
///   (see `docs/CONTENT_REVIEW.md`, item B6). The IDs below are stable so a
///   user's `lastMantraID` survives content edits.
enum SeedMantras {
    static let all: [Mantra] = [
        Mantra(
            id: id(1),
            title: "Om",
            script: "ॐ",
            note: "The pranava — the elemental sound, common to many traditions.",
            isSeed: true
        ),
        Mantra(
            id: id(2),
            title: "Om Namah Shivaya",
            script: "ॐ नमः शिवाय",
            note: "A salutation to Shiva, central to Shaiva practice.",
            isSeed: true
        ),
        Mantra(
            id: id(3),
            title: "Om Mani Padme Hum",
            script: "ॐ मणि पद्मे हूँ",
            note: "The mantra of Avalokiteshvara in Tibetan Buddhism.",
            isSeed: true
        ),
        Mantra(
            id: id(4),
            title: "Om Gam Ganapataye Namaha",
            script: "ॐ गं गणपतये नमः",
            note: "An invocation of Ganesha, remover of obstacles.",
            isSeed: true
        ),
        Mantra(
            id: id(5),
            title: "Hare Krishna",
            script: "हरे कृष्ण हरे राम",
            note: "An abbreviation of the Vaishnava maha-mantra.",
            isSeed: true
        ),
        Mantra(
            id: id(6),
            title: "Waheguru",
            script: "ਵਾਹਿਗੁਰੂ",
            note: "A remembrance of the Divine in the Sikh tradition.",
            isSeed: true
        ),
        Mantra(
            id: id(7),
            title: "So Ham",
            script: "सो ऽहम्",
            note: "A breath mantra meaning \u{201C}I am that\u{201D}; used in meditative practice.",
            isSeed: true
        ),
        Mantra(
            id: id(8),
            title: "Om Shanti",
            script: "ॐ शान्ति",
            note: "An invocation of peace.",
            isSeed: true
        ),
        Mantra.none
    ]

    /// Deterministic UUIDs for the seed set so preferences and history stay stable.
    private static func id(_ n: Int) -> UUID {
        UUID(uuidString: String(format: "00000000-0000-0000-0000-0000000000%02d", n))!
    }
}
