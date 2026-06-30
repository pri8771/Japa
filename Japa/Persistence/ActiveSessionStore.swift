import Foundation

/// Persists the in-progress round without ever sitting on the haptic path.
///
/// The practice loop updates in-memory engine state and fires the haptic
/// **first**, then calls `save(_:)`, which enqueues a tiny JSON write on a
/// background serial queue — storage latency never shapes the tap rhythm.
/// `flush()` is the resign-active backstop: it blocks until the latest snapshot
/// is on disk, guaranteeing durability across force-quit and restart.
final class ActiveSessionStore {
    private let persistence: Persistence
    private let fileName = "active-session"
    private let queue = DispatchQueue(label: "com.priyansh.japa.active-session", qos: .utility)

    init(persistence: Persistence) {
        self.persistence = persistence
    }

    /// Reads the persisted in-progress round, if any. Synchronous (launch path).
    func load() -> ActiveSessionState? {
        persistence.load(ActiveSessionState.self, fileName)
    }

    /// Enqueues an asynchronous write of the latest snapshot. Returns immediately.
    func save(_ state: ActiveSessionState) {
        queue.async { [persistence, fileName] in
            persistence.save(state, fileName)
        }
    }

    /// Blocks until all queued writes have completed (resign-active backstop).
    func flush() {
        queue.sync {}
    }

    /// Clears the snapshot. Called once a round completes or the user ends/abandons it.
    func clear() {
        queue.sync { [persistence, fileName] in
            persistence.delete(fileName)
        }
    }
}
