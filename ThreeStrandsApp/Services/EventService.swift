import Foundation

actor EventService {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let cacheURL: URL

    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
        self.cacheURL = FileManager.default
            .temporaryDirectory
            .appendingPathComponent("events.json")
    }

    func fetchEvents() async throws -> [Event] {
        if let cached = try? loadCachedEvents(), !cached.isEmpty {
            return cached
        }

        do {
            let (data, _) = try await session.data(from: endpoint)
            let events = try mapWordPressEvents(data: data)
            if !events.isEmpty {
                try cache(events: events)
                return events.sorted { $0.startDate < $1.startDate }
            }
        } catch {
            if let cached = try? loadCachedEvents(), !cached.isEmpty {
                return cached
            }
        }

        let fallbackEvents = try loadBundledEvents()
        try cache(events: fallbackEvents)
        return fallbackEvents
    }

    private func mapWordPressEvents(data: Data) throws -> [Event] {
        let response = try JSONDecoder().decode([WordPressEvent].self, from: data)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        return response.compactMap { item in
            guard
                let startString = item.acf?.startDate,
                let endString = item.acf?.endDate,
                let startDate = formatter.date(from: startString) ?? decoder.dateDecodingStrategyDate(from: startString),
                let endDate = formatter.date(from: endString) ?? decoder.dateDecodingStrategyDate(from: endString)
            else {
                return nil
            }

            let description = item.content?.rendered.strippingHTML() ??
                item.excerpt?.rendered.strippingHTML() ??
                "Stay tuned for details."
            let location = item.acf?.location ?? "TBD"

            return Event(
                id: UUID(uuidString: item.uuidString) ?? UUID(),
                title: item.title.rendered.strippingHTML(),
                description: description,
                location: location,
                startDate: startDate,
                endDate: endDate,
                websiteURL: item.link
            )
        }
    }

    private func loadBundledEvents() throws -> [Event] {
        guard let url = bundledResource(named: "SampleEvents", withExtension: "json") else {
            throw EventServiceError.missingSampleFile
        }

        let data = try Data(contentsOf: url)
        return try decoder.decode([Event].self, from: data)
    }

    private func loadCachedEvents() throws -> [Event]? {
        guard FileManager.default.fileExists(atPath: cacheURL.path) else { return nil }
        let data = try Data(contentsOf: cacheURL)
        return try decoder.decode([Event].self, from: data)
    }

    private func cache(events: [Event]) throws {
        let data = try JSONEncoder().encode(events)
        try data.write(to: cacheURL, options: .atomic)
    }

    private var endpoint: URL {
        URL(string: "https://3strands.co/wp-json/wp/v2/events?per_page=20&_embed") ??
            URL(string: "https://3strands.co")!
    }

    private func bundledResource(named name: String, withExtension ext: String) -> URL? {
        let bundleCandidates = Bundle.resourceBundles

        for bundle in bundleCandidates {
            if let url = bundle.url(forResource: name, withExtension: ext) {
                return url
            }
        }

        return nil
    }
}

private extension Bundle {
    static var resourceBundles: [Bundle] {
        var bundles: [Bundle] = [Bundle.main, Bundle(for: BundleLocator.self)]
        #if SWIFT_PACKAGE
        bundles.append(Bundle.module)
        #endif
        return bundles
    }
}

private extension JSONDecoder.DateDecodingStrategy {
    func date(from string: String) -> Date? {
        switch self {
        case .iso8601:
            return ISO8601DateFormatter().date(from: string)
        case .formatted(let formatter):
            return formatter.date(from: string)
        case .custom:
            return nil
        case .deferredToDate, .secondsSince1970, .millisecondsSince1970:
            return nil
        @unknown default:
            return nil
        }
    }
}

private extension JSONDecoder {
    func dateDecodingStrategyDate(from string: String) -> Date? {
        dateDecodingStrategy.date(from: string)
    }
}

private struct WordPressEvent: Decodable {
    let id: Int
    let title: Rendered
    let excerpt: Rendered?
    let content: Rendered?
    let acf: CustomFields?
    let link: URL?

    struct Rendered: Decodable {
        let rendered: String
    }

    struct CustomFields: Decodable {
        let location: String?
        let startDate: String?
        let endDate: String?

        private enum CodingKeys: String, CodingKey {
            case location = "event_location"
            case startDate = "event_start"
            case endDate = "event_end"
        }
    }

    var uuidString: String {
        let formatted = String(format: "%012d", id)
        return "00000000-0000-0000-0000-\(formatted)"
    }
}

private final class BundleLocator {}

enum EventServiceError: Error {
    case missingSampleFile
}

extension EventService {
    static var preview: EventService {
        EventService(session: .shared)
    }
}
