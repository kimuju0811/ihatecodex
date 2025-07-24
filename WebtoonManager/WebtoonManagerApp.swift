import SwiftUI

@main
struct WebtoonManagerApp: App {
    @State private var isLoading = true

    var body: some Scene {
        WindowGroup {
            if isLoading {
                LoadingView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation { isLoading = false }
                        }
                    }
            } else {
                ContentView()
            }
        }
    }
}
