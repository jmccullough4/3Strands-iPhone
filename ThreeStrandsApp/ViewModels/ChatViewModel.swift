import Foundation
import MessageUI

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var showingFallbackAlert = false
    @Published var fallbackURL: URL?

    var canSendEmail: Bool {
        MFMailComposeViewController.canSendMail()
    }

    func presentMailFallback() {
        if let url = URL(string: "mailto:info@3strands.co") {
            fallbackURL = url
        }
        showingFallbackAlert = true
    }

    func handleMailResult(_ result: Result<MFMailComposeResult, Error>) {
        switch result {
        case .success(let result):
            if result == .sent {
                // we could trigger analytics here if needed
                break
            }
        case .failure:
            showingFallbackAlert = true
        }
    }
}
