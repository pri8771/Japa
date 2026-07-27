import Foundation

/// The neutral default bundled with Mala.
///
/// v1 deliberately ships no spiritual seed content. Practice is never gated
/// behind choosing text: people can count without a label or add their own
/// private free-text mantra (see `AppModel`).
enum SeedMantras {
    static let all: [Mantra] = [Mantra.none]
}
