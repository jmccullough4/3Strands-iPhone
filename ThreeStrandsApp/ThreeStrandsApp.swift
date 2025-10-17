import SwiftUI

@main
struct ThreeStrandsApp: App {
    @StateObject private var eventViewModel = EventViewModel()
    @StateObject private var orderViewModel = OrderViewModel()

    var body: some Scene {
        WindowGroup {
            TabView {
                EventListView()
                    .environmentObject(eventViewModel)
                    .environmentObject(orderViewModel)
                    .tabItem {
                        Label("Events", systemImage: "calendar")
                    }

                OrderListView()
                    .environmentObject(orderViewModel)
                    .environmentObject(eventViewModel)
                    .tabItem {
                        Label("Orders", systemImage: "bag")
                    }

                ChatSupportView()
                    .tabItem {
                        Label("Chat", systemImage: "message")
                    }
            }
            .task {
                await eventViewModel.loadEvents()
            }
        }
    }
}
