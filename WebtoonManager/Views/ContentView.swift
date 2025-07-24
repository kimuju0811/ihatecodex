import SwiftUI

struct ContentView: View {
    @StateObject private var store = WebtoonStore()
    
    var body: some View {
        TabView {
            HomeView(store: store)
                .tabItem {
                    Label("홈", systemImage: "house")
                }

            SearchView(store: store)
                .tabItem {
                    Label("검색", systemImage: "magnifyingglass")
                }

            AddWebtoonView(store: store)
                .tabItem {
                    Label("추가", systemImage: "plus.circle")
                }

            SettingsView(store: store)
                .tabItem {
                    Label("기타", systemImage: "gear")
                }
        }
    }
}

#Preview {
    ContentView()
}
