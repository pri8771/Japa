import Foundation

/// A tiny local-first, Codable-to-disk store.
///
/// Everything Japa keeps — preferences, custom mantras, history, and the
/// in-progress round — lives as JSON in the app sandbox. There is no network,
/// no account, and no analytics. This type is the whole persistence surface.
struct Persistence {
    /// Directory that holds all of Japa's JSON files.
    let directory: URL

    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(directory: URL) {
        self.directory = directory
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        self.encoder = encoder
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    }

    /// The live store, rooted in Application Support so it isn't offered to the
    /// user as user-visible documents and is excluded from the Files app.
    static var live: Persistence {
        let base = FileManager.default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .first ?? FileManager.default.temporaryDirectory
        return Persistence(directory: base.appendingPathComponent("Japa", isDirectory: true))
    }

    func url(for name: String) -> URL {
        directory.appendingPathComponent("\(name).json")
    }

    /// Loads and decodes a value, returning `nil` if the file is missing or unreadable.
    func load<T: Decodable>(_ type: T.Type, _ name: String) -> T? {
        guard let data = try? Data(contentsOf: url(for: name)) else { return nil }
        return try? decoder.decode(T.self, from: data)
    }

    /// Encodes and writes a value atomically.
    func save<T: Encodable>(_ value: T, _ name: String) {
        guard let data = try? encoder.encode(value) else { return }
        try? data.write(to: url(for: name), options: [.atomic])
    }

    /// Removes a file if present.
    func delete(_ name: String) {
        try? FileManager.default.removeItem(at: url(for: name))
    }
}
