import SwiftUI

struct EventListView: View {
    @EnvironmentObject private var viewModel: EventViewModel
    @EnvironmentObject private var orderViewModel: OrderViewModel
    @State private var searchText = ""

    private var filteredEvents: [Event] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return viewModel.events
        }

        return viewModel.events.filter { event in
            event.title.localizedCaseInsensitiveContains(searchText) ||
            event.location.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading upcoming events…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Text("We were unable to load the events.")
                            .font(.headline)
                        Text(error)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)

                        Button {
                            Task { await viewModel.loadEvents(forceReload: true) }
                        } label: {
                            Label("Retry", systemImage: "arrow.clockwise")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if filteredEvents.isEmpty {
                    ContentUnavailableView(
                        "No events",
                        systemImage: "calendar.badge.exclamationmark",
                        description: Text("We didn’t find any events that match your search.")
                    )
                } else {
                    List(filteredEvents) { event in
                        NavigationLink(value: event) {
                            EventRow(event: event)
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Upcoming Events")
            .navigationDestination(for: Event.self) { event in
                EventDetailView(event: event)
                    .environmentObject(orderViewModel)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        Task { await viewModel.loadEvents(forceReload: true) }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
    }
}

private struct EventRow: View {
    let event: Event

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(event.title)
                .font(.headline)

            Text(event.startDate.formattedRelativeEventRange(endDate: event.endDate))
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(event.location)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        EventListView()
            .environmentObject(EventViewModel.preview)
            .environmentObject(OrderViewModel())
    }
}
