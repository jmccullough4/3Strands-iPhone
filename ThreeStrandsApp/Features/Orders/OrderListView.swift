import SwiftUI

struct OrderListView: View {
    @EnvironmentObject private var orderViewModel: OrderViewModel
    @EnvironmentObject private var eventViewModel: EventViewModel

    var body: some View {
        NavigationStack {
            Group {
                if orderViewModel.orders.isEmpty {
                    ContentUnavailableView(
                        "No orders yet",
                        systemImage: "bag",
                        description: Text("Start an order from the events tab to reserve your favorites for pick up or delivery.")
                    )
                } else {
                    List {
                        Section("Upcoming") {
                            ForEach(orderViewModel.upcomingOrders) { order in
                                OrderRow(order: order)
                            }
                        }

                        if !orderViewModel.pastOrders.isEmpty {
                            Section("Past") {
                                ForEach(orderViewModel.pastOrders) { order in
                                    OrderRow(order: order)
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("My Orders")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        ForEach(eventViewModel.events) { event in
                            Button(event.title) {
                                orderViewModel.presentNewOrder(for: event)
                            }
                        }
                    } label: {
                        Label("New Order", systemImage: "plus")
                    }
                    .disabled(eventViewModel.events.isEmpty)
                }
            }
        }
        .sheet(item: $orderViewModel.selectedEventForOrder) { event in
            NavigationStack {
                OrderFormView(orderDraft: orderViewModel.createDraft(for: event))
                    .environmentObject(orderViewModel)
            }
        }
    }
}

private struct OrderRow: View {
    let order: EventOrder

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(order.eventTitle)
                .font(.headline)

            HStack {
                Label(order.orderType.displayTitle, systemImage: order.orderType.systemImageName)
                Spacer()
                Text(order.fulfillmentDate.formatted(order.orderType.dateFormatStyle))
            }
            .font(.footnote)
            .foregroundStyle(.secondary)

            if !order.items.isEmpty {
                Text(order.itemsSummary)
                    .font(.subheadline)
            }
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    NavigationStack {
        OrderListView()
            .environmentObject(OrderViewModel.preview)
            .environmentObject(EventViewModel.preview)
    }
}
