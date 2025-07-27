import SwiftUI

struct HomeView: View {
    @ObservedObject var store: WebtoonStore
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                VStack(spacing: 16) {
                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geo.size.width * 0.8)

                    Text("WebOrg_v0.2.2")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Spacer().frame(height: geo.size.height / 3)

                    TextField("검색", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .onChange(of: searchText) { _ in
                            // Could update search results in real time
                        }

                    HomeRecommendationSection(store: store)
                        .padding(.horizontal)

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .dismissKeyboardOnTap()
            .background(Color(.systemBackground))
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    HomeView(store: WebtoonStore())
}
