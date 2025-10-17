import Foundation

actor OrderService {
    private var submittedOrders: [EventOrder] = []

    func validate(draft: EventOrderDraft) -> Bool {
        !draft.itemsDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !draft.contactPhone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        (draft.orderType == .pickup || !draft.deliveryAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }

    func submit(draft: EventOrderDraft) async throws -> EventOrder {
        try await Task.sleep(nanoseconds: 300_000_000) // simulate network delay

        let items = draft.itemsDescription
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        let order = EventOrder(
            id: UUID(),
            eventID: draft.event.id,
            eventTitle: draft.event.title,
            orderType: draft.orderType,
            fulfillmentDate: draft.fulfillmentDate,
            items: items.isEmpty ? [draft.itemsDescription] : items,
            deliveryAddress: draft.orderType == .delivery ? draft.deliveryAddress : nil,
            contactPhone: draft.contactPhone,
            additionalNotes: draft.hasQuestions ? draft.additionalNotes : nil
        )

        submittedOrders.append(order)
        return order
    }
}

extension OrderService {
    static var preview: OrderService {
        OrderService()
    }
}
