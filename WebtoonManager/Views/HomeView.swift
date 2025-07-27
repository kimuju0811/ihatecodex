import SwiftUI

struct HomeView: View {
    @ObservedObject var store: WebtoonStore
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
                    .padding(.top)

                Text("WebOrg_v0.2.1")
                    .font(.caption)
                    .foregroundColor(.secondary)

                TextField("검색", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.horizontal])
                    .onChange(of: searchText) { _ in
                        // Could update search results in real time
                    }

                HomeRecommendationSection(store: store)
                    .padding([.horizontal])

                Spacer()
            }
            .dismissKeyboardOnTap()
            .background(Color(.systemBackground))
            .navigationTitle("홈")
        }
    }
}

#Preview {
    HomeView(store: WebtoonStore())
}
