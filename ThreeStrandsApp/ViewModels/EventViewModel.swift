import Foundation

@MainActor
final class EventViewModel: ObservableObject {
    @Published private(set) var events: [Event] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let service: EventService

    init(service: EventService = EventService()) {
        self.service = service
    }

    func loadEvents(forceReload: Bool = false) async {
        guard !isLoading else { return }
        if !forceReload && !events.isEmpty { return }

        isLoading = true
        errorMessage = nil

        do {
            events = try await service.fetchEvents()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}

extension EventViewModel {
    static var preview: EventViewModel {
        let viewModel = EventViewModel(service: .preview)
        viewModel.events = Event.previewList
        return viewModel
    }
}
