import Foundation
import Observation

/// Shared application state: preferences, mantras, history, and the local store.
///
/// Local-first by construction — every mutation persists to disk through
/// `Persistence`; nothing leaves the device. This object owns the shared haptic
/// and tone engines so they are prepared once and reused across rounds.
@MainActor
@Observable
final class AppModel {

    private(set) var preferences: Preferences
    private(set) var customMantras: [Mantra]
    private(set) var sessions: [PracticeSession]
    private(set) var selectedMantra: Mantra

    private let persistence: Persistence
    let activeStore: ActiveSessionStore
    private let haptics: HapticFeedback
    private let tone: TonePlaying

    /// Seed set followed by the user's own mantras.
    var allMantras: [Mantra] { SeedMantras.all + customMantras }

    init(
        persistence: Persistence = .live,
        haptics: HapticFeedback? = nil,
        tone: TonePlaying? = nil
    ) {
        self.persistence = persistence
        self.activeStore = ActiveSessionStore(persistence: persistence)
        self.haptics = haptics ?? HapticPlayer()
        self.tone = tone ?? CompletionTonePlayer()

        let prefs = persistence.load(Preferences.self, Keys.preferences) ?? Preferences()
        self.preferences = prefs
        let custom = persistence.load([Mantra].self, Keys.mantras) ?? []
        self.customMantras = custom
        self.sessions = persistence.load([PracticeSession].self, Keys.sessions) ?? []

        let pool = SeedMantras.all + custom
        self.selectedMantra =
            pool.first { $0.id == prefs.lastMantraID }
            ?? pool.first { $0.title == "Om Namah Shivaya" }
            ?? Mantra.none
    }

    private enum Keys {
        static let preferences = "preferences"
        static let mantras = "mantras"
        static let sessions = "sessions"
    }

    // MARK: - Mantra selection & authoring

    func select(_ mantra: Mantra) {
        selectedMantra = mantra
        preferences.lastMantraID = mantra.id
        savePreferences()
    }

    @discardableResult
    func addCustomMantra(title: String, script: String? = nil) -> Mantra? {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        let cleanedScript = script?.trimmingCharacters(in: .whitespacesAndNewlines)
        let mantra = Mantra(
            title: trimmed,
            script: (cleanedScript?.isEmpty == false) ? cleanedScript : nil,
            isSeed: false
        )
        customMantras.append(mantra)
        persistence.save(customMantras, Keys.mantras)
        return mantra
    }

    func deleteCustomMantra(_ mantra: Mantra) {
        guard !mantra.isSeed else { return }
        customMantras.removeAll { $0.id == mantra.id }
        persistence.save(customMantras, Keys.mantras)
        if selectedMantra.id == mantra.id {
            select(SeedMantras.all.first ?? Mantra.none)
        }
    }

    // MARK: - Preferences

    func setDefaultTarget(_ target: Int) {
        preferences.defaultTarget = JapaEngine.clampTarget(target)
        savePreferences()
    }

    func setCompletionToneEnabled(_ enabled: Bool) {
        preferences.completionToneEnabled = enabled
        savePreferences()
    }

    func setHapticIntensity(_ value: Double) {
        preferences.hapticIntensity = min(max(value, 0), 1)
        savePreferences()
    }

    func markIntroSeen() {
        guard !preferences.hasSeenIntro else { return }
        preferences.hasSeenIntro = true
        savePreferences()
    }

    private func savePreferences() {
        persistence.save(preferences, Keys.preferences)
    }

    // MARK: - History

    func record(_ session: PracticeSession) {
        sessions.insert(session, at: 0)
        persistence.save(sessions, Keys.sessions)
    }

    func deleteSession(_ session: PracticeSession) {
        sessions.removeAll { $0.id == session.id }
        persistence.save(sessions, Keys.sessions)
    }

    func clearHistory() {
        sessions.removeAll()
        persistence.save(sessions, Keys.sessions)
    }

    // MARK: - Practice controllers

    /// A resumable in-progress round, if one was persisted and has real progress.
    var resumableState: ActiveSessionState? {
        guard let state = activeStore.load(), state.count > 0, !state.makeEngine().isComplete else { return nil }
        return state
    }

    func newPracticeController() -> PracticeController {
        makeController(mantra: selectedMantra, target: preferences.defaultTarget, restoredCount: nil, startedAt: Date())
    }

    func resumePracticeController() -> PracticeController? {
        guard let state = resumableState else { return nil }
        let mantra = allMantras.first { $0.title == state.mantraTitle } ?? Mantra(title: state.mantraTitle)
        return makeController(mantra: mantra, target: state.target, restoredCount: state.count, startedAt: state.startedAt)
    }

    func discardResumable() {
        activeStore.clear()
    }

    private func makeController(mantra: Mantra, target: Int, restoredCount: Int?, startedAt: Date) -> PracticeController {
        PracticeController(
            mantra: mantra,
            target: target,
            restoredCount: restoredCount,
            startedAt: startedAt,
            preferences: { [weak self] in self?.preferences ?? Preferences() },
            haptics: haptics,
            tone: tone,
            activeStore: activeStore,
            onFinish: { [weak self] session in self?.record(session) }
        )
    }
}
