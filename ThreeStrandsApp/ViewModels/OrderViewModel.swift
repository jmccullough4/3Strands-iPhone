import Foundation

@MainActor
final class OrderViewModel: ObservableObject {
    @Published private(set) var orders: [EventOrder] = []
    @Published var submissionError: String?
    @Published var selectedEventForOrder: Event?

    private let orderService: OrderService

    init(orderService: OrderService = OrderService()) {
        self.orderService = orderService
    }

    var upcomingOrders: [EventOrder] {
        orders.filter { $0.fulfillmentDate >= .now }.sorted { $0.fulfillmentDate < $1.fulfillmentDate }
    }

    var pastOrders: [EventOrder] {
        orders.filter { $0.fulfillmentDate < .now }.sorted { $0.fulfillmentDate > $1.fulfillmentDate }
    }

    func createDraft(for event: Event) -> EventOrderDraft {
        EventOrderDraft(event: event)
    }

    func canSubmit(draft: EventOrderDraft) -> Bool {
        orderService.validate(draft: draft)
    }

    func submit(draft: EventOrderDraft) async {
        do {
            let order = try await orderService.submit(draft: draft)
            orders.append(order)
            submissionError = nil
        } catch {
            submissionError = error.localizedDescription
        }
    }

    func presentNewOrder(for event: Event) {
        selectedEventForOrder = event
    }
}

extension OrderViewModel {
    static var preview: OrderViewModel {
        let viewModel = OrderViewModel(orderService: .preview)
        viewModel.orders = EventOrder.previewList
        return viewModel
    }
}
