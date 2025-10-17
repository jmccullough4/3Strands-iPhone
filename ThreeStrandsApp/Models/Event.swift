import Foundation

struct Event: Codable, Identifiable, Hashable {
    let id: UUID
    let title: String
    let description: String
    let location: String
    let startDate: Date
    let endDate: Date
    let websiteURL: URL?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case location
        case startDate = "start_date"
        case endDate = "end_date"
        case websiteURL = "website_url"
    }
}

extension Event {
    static let preview = Event(
        id: UUID(),
        title: "Farmers Market Pop-up",
        description: "Come taste our newest small-batch cold brew at the Midtown Farmers Market.",
        location: "Midtown Farmers Market",
        startDate: Date().addingTimeInterval(60 * 60 * 24 * 2),
        endDate: Date().addingTimeInterval(60 * 60 * 24 * 2 + 60 * 60 * 3),
        websiteURL: URL(string: "https://3strands.co/events/farmers-market")
    )

    static let previewList = [
        Event.preview,
        Event(
            id: UUID(),
            title: "Corporate Coffee Cart",
            description: "We’re catering a corporate gathering with pour-over service and pastries.",
            location: "Riverfront Office Park",
            startDate: Date().addingTimeInterval(60 * 60 * 24 * 5),
            endDate: Date().addingTimeInterval(60 * 60 * 24 * 5 + 60 * 60 * 4),
            websiteURL: URL(string: "https://3strands.co/events/corporate-cart")
        ),
        Event(
            id: UUID(),
            title: "Downtown Delivery Day",
            description: "Pre-order beans and cold brew for same-day delivery downtown.",
            location: "Sacramento, CA",
            startDate: Date().addingTimeInterval(60 * 60 * 24 * 7),
            endDate: Date().addingTimeInterval(60 * 60 * 24 * 7 + 60 * 60 * 8),
            websiteURL: URL(string: "https://3strands.co/events/delivery-day")
        )
    ]
}
