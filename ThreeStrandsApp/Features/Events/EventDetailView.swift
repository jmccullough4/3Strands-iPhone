import SwiftUI

struct EventDetailView: View {
    let event: Event
    @EnvironmentObject private var orderViewModel: OrderViewModel
    @State private var showingOrderSheet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header
                Divider()
                description
                Divider()
                actionButtons
            }
            .padding()
        }
        .navigationTitle(event.title)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingOrderSheet) {
            NavigationStack {
                OrderFormView(orderDraft: orderViewModel.createDraft(for: event))
                    .environmentObject(orderViewModel)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(event.startDate.formattedRelativeEventRange(endDate: event.endDate), systemImage: "calendar")
                .font(.headline)
            Label(event.location, systemImage: "mappin.and.ellipse")
                .font(.subheadline)
            if let websiteURL = event.websiteURL {
                Link(destination: websiteURL) {
                    Label("View event on 3Strands.co", systemImage: "safari")
                }
            }
        }
    }

    private var description: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About this event")
                .font(.title2)
                .bold()
            Text(event.description)
                .foregroundStyle(.primary)
        }
    }

    private var actionButtons: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ready to enjoy 3 Strands?")
                .font(.title3)
                .bold()

            Button {
                showingOrderSheet = true
            } label: {
                Label("Place an order", systemImage: "bag.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    NavigationStack {
        EventDetailView(event: .preview)
            .environmentObject(OrderViewModel())
    }
}
