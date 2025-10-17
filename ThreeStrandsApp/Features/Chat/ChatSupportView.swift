import SwiftUI
import MessageUI

struct ChatSupportView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var showingComposer = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 96, height: 96)
                    .foregroundStyle(.white)
                    .padding()
                    .background(Circle().fill(.blue.gradient))

                Text("Chat with 3 Strands")
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)

                Text("Send us a message any time. We’ll reply from info@3strands.co.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                Button {
                    if viewModel.canSendEmail {
                        showingComposer = true
                    } else {
                        viewModel.presentMailFallback()
                    }
                } label: {
                    Label("Start a conversation", systemImage: "paperplane.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                if let fallbackURL = viewModel.fallbackURL {
                    Link("Open in Mail", destination: fallbackURL)
                        .buttonStyle(.bordered)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Chat with us")
        }
        .sheet(isPresented: $showingComposer) {
            MailComposerView(resultHandler: viewModel.handleMailResult)
        }
        .alert("We can’t send email from this device", isPresented: $viewModel.showingFallbackAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Send an email to info@3strands.co from your preferred mail app.")
        }
    }
}

#Preview {
    ChatSupportView()
}
