import SwiftUI
import Photos

@main
struct WebtoonManagerApp: App {
    @State private var isLoading = true
    @AppStorage("didRequestPermissions") private var didRequestPermissions = false
    @AppStorage("networkAllowed") private var networkAllowed = false
    @State private var showNetworkAlert = false

    var body: some Scene {
        WindowGroup {
            if isLoading {
                LoadingView()
                    .onAppear {
                        requestPermissions()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation { isLoading = false }
                        }
                    }
            } else {
                ContentView()
                    .alert("인터넷 연결 허용", isPresented: $showNetworkAlert) {
                        Button("허용") { networkAllowed = true }
                        Button("허용 안함", role: .cancel) { networkAllowed = false }
                    } message: {
                        Text("자동 업데이트를 위해 인터넷 연결을 사용합니다.")
                    }
            }
        }
    }

    private func requestPermissions() {
        guard !didRequestPermissions else { return }
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { _ in
            DispatchQueue.main.async {
                didRequestPermissions = true
                showNetworkAlert = true
            }
        }
    }
}
