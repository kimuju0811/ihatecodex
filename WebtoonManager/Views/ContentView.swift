import SwiftUI

struct ContentView: View {
    @StateObject private var store = WebtoonStore()
    @AppStorage("selectedTab") private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(store: store)
                .tabItem { Label("홈", systemImage: "house") }
                .tag(0)

            SearchView(store: store)
                .tabItem { Label("검색", systemImage: "magnifyingglass") }
                .tag(1)

            AddWebtoonView(store: store)
                .tabItem { Label("추가", systemImage: "plus.circle") }
                .tag(2)

            SettingsView(store: store)
                .tabItem { Label("기타", systemImage: "gear") }
                .tag(3)
        }
        .preferredColorScheme(store.colorScheme)
        .tint(store.tintColor)
    }
}

#Preview {
    ContentView()
}
