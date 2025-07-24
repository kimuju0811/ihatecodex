import SwiftUI

struct SearchView: View {
    @ObservedObject var store: WebtoonStore
    @State private var searchText = ""
    @State private var sortOption = 0

    var filtered: [Webtoon] {
        if searchText.isEmpty { return store.webtoons }
        return store.webtoons.filter { $0.title.contains(searchText) || $0.writer.contains(searchText) || $0.studio.contains(searchText) || $0.category.contains(searchText) }
    }

    var body: some View {
        NavigationStack {
            VStack {
                TextField("검색", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.horizontal])

            Picker("정렬", selection: $sortOption) {
                Text("평가 순").tag(0)
                Text("제목 순").tag(1)
                Text("최근 클릭 순").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding([.horizontal])

                List(filtered) { webtoon in
                    NavigationLink(destination: WebtoonDetailView(store: store, webtoon: webtoon)) {
                        HStack {
                            AsyncImage(url: URL(string: webtoon.thumbnailURL)) { phase in
                                switch phase {
                                case .success(let image):
                                    image.resizable().scaledToFit().frame(width: 70, height: 100)
                                default:
                                    Rectangle().fill(Color.gray).frame(width: 70, height: 100)
                                }
                            }
                            VStack(alignment: .leading) {
                                Text(webtoon.title).font(.headline)
                                Text(webtoon.writer).foregroundColor(.secondary)
                                Text(webtoon.rating.rawValue)
                                Text(webtoon.status.rawValue)
                            }
                        }
                    }
                }
            }
            .onChange(of: sortOption) { _ in
                sort()
            }
            .navigationTitle("웹툰 검색")
        }
    }

    private func sort() {
        switch sortOption {
        case 0:
            store.webtoons.sort { $0.rating.rawValue > $1.rating.rawValue }
        case 1:
            store.webtoons.sort { $0.title < $1.title }
        default:
            break
        }
    }
}

#Preview {
    SearchView(store: WebtoonStore())
}
