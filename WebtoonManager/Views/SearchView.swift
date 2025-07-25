import SwiftUI

struct SearchView: View {
    @ObservedObject var store: WebtoonStore
    @State private var searchText = ""
    @State private var sortOption = 0
    @State private var editingWebtoon: Webtoon?
    @State private var isEditing = false

    var filtered: [Webtoon] {
        if searchText.isEmpty { return store.webtoons }
        return store.webtoons.filter { $0.title.contains(searchText) || $0.writers.joined().contains(searchText) || $0.studio.contains(searchText) || $0.categories.joined().contains(searchText) }
    }

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("검색", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Spacer()
                    Button("편집") { isEditing.toggle() }
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
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
                            if let data = webtoon.thumbnailData, let ui = UIImage(data: data) {
                                Image(uiImage: ui).resizable().scaledToFit().frame(width: 70, height: 100)
                            } else {
                                AsyncImage(url: URL(string: webtoon.thumbnailURL)) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image.resizable().scaledToFit().frame(width: 70, height: 100)
                                    default:
                                        Rectangle().fill(Color.gray).frame(width: 70, height: 100)
                                    }
                                }
                            }
                            VStack(alignment: .leading) {
                                Text(webtoon.title).font(.headline)
                                Text(webtoon.writers.joined(separator: ", "))
                                    .foregroundColor(.secondary)
                                Text(webtoon.rating.rawValue)
                                Text(webtoon.status.rawValue)
                            }
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) { delete(webtoon) } label: { Label("삭제", systemImage: "trash") }
                    }
                    .swipeActions(edge: .leading) {
                        Button { editingWebtoon = webtoon } label: { Label("편집", systemImage: "pencil") }
                    }
                }
            }
            .onChange(of: sortOption) { _ in
                sort()
            }
            .navigationTitle("웹툰 검색")
            .sheet(item: $editingWebtoon) { webtoon in
                AddWebtoonView(store: store, webtoon: webtoon)
            }
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

    private func delete(_ webtoon: Webtoon) {
        store.webtoons.removeAll { $0.id == webtoon.id }
    }
}

#Preview {
    SearchView(store: WebtoonStore())
}
