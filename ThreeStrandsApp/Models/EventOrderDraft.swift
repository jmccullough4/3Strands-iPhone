import Foundation

struct EventOrderDraft {
    var event: Event
    var orderType: OrderType = .pickup
    var fulfillmentDate: Date
    var itemsDescription: String = ""
    var deliveryAddress: String = ""
    var contactPhone: String = ""
    var hasQuestions = false
    var additionalNotes: String = ""

    init(event: Event) {
        self.event = event
        let defaultDate = max(event.startDate, Date())
        self.fulfillmentDate = defaultDate
    }
}
