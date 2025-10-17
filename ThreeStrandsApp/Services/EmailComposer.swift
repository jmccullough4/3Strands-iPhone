import Foundation
import MessageUI
import SwiftUI

struct MailComposerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = MFMailComposeViewController

    var subject: String = "3 Strands Inquiry"
    var recipients: [String] = ["info@3strands.co"]
    var body: String = "Hello 3 Strands team,\n\n"
    var resultHandler: (Result<MFMailComposeResult, Error>) -> Void

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let controller = MFMailComposeViewController()
        controller.mailComposeDelegate = context.coordinator
        controller.setSubject(subject)
        controller.setToRecipients(recipients)
        controller.setMessageBody(body, isHTML: false)
        return controller
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(resultHandler: resultHandler)
    }

    final class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let resultHandler: (Result<MFMailComposeResult, Error>) -> Void

        init(resultHandler: @escaping (Result<MFMailComposeResult, Error>) -> Void) {
            self.resultHandler = resultHandler
        }

        func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            if let error {
                resultHandler(.failure(error))
            } else {
                resultHandler(.success(result))
            }
            controller.dismiss(animated: true)
        }
    }
}
