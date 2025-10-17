import Foundation

struct EventOrder: Identifiable, Codable {
    let id: UUID
    let eventID: UUID
    let eventTitle: String
    let orderType: OrderType
    let fulfillmentDate: Date
    let items: [String]
    let deliveryAddress: String?
    let contactPhone: String
    let additionalNotes: String?

    var itemsSummary: String {
        items.joined(separator: ", ")
    }
}

extension EventOrder {
    static let previewList: [EventOrder] = [
        EventOrder(
            id: UUID(),
            eventID: Event.preview.id,
            eventTitle: Event.preview.title,
            orderType: .pickup,
            fulfillmentDate: Date().addingTimeInterval(60 * 60 * 24 * 2),
            items: ["Cold Brew Growler", "Seasonal Latte"],
            deliveryAddress: nil,
            contactPhone: "555-123-4567",
            additionalNotes: nil
        ),
        EventOrder(
            id: UUID(),
            eventID: Event.previewList[1].id,
            eventTitle: Event.previewList[1].title,
            orderType: .delivery,
            fulfillmentDate: Date().addingTimeInterval(60 * 60 * 24 * -1),
            items: ["Whole Bean - Ethiopia", "Cold Brew Concentrate"],
            deliveryAddress: "500 Market Street, Sacramento, CA",
            contactPhone: "555-987-6543",
            additionalNotes: "Ring the bell at arrival"
        )
    ]
}
