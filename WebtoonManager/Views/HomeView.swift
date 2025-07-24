import SwiftUI

struct HomeView: View {
    @ObservedObject var store: WebtoonStore
    @State private var searchText = ""

    var body: some View {
        VStack {
            Image("AppLogo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 390)
                .padding()

            TextField("검색", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.horizontal])
                .onChange(of: searchText) { _ in
                    // Could update search results in real time
                }

            Spacer()
        }
        .background(Color.white)
    }
}

#Preview {
    HomeView(store: WebtoonStore())
}
