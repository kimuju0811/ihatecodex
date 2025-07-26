import SwiftUI

struct HomeView: View {
    @ObservedObject var store: WebtoonStore
    @State private var searchText = ""

    var body: some View {
        VStack {
            Image("AppLogo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
                .padding()

            Text("WebOrg_v0.1.2")
                .font(.caption)
                .foregroundColor(.secondary)

            TextField("검색", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.horizontal])
                .onChange(of: searchText) { _ in
                    // Could update search results in real time
                }

            Spacer()
        }
        .dismissKeyboardOnTap()
        .background(Color(.systemBackground))
    }
}

#Preview {
    HomeView(store: WebtoonStore())
}
