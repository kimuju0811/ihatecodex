import SwiftUI

struct SearchView: View {
    @ObservedObject var store: WebtoonStore
    @State private var searchText = ""
    @State private var sortOption = 0
    @State private var editingWebtoon: Webtoon?
    @State private var isEditing = false
    @State private var editMode: EditMode = .inactive

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
                    Button(isEditing ? "확인" : "편집") { isEditing.toggle() }
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding([.horizontal])
                .onChange(of: isEditing) { editMode = $0 ? .active : .inactive }

            Picker("정렬", selection: $sortOption) {
                Text("평가 순").tag(0)
                Text("제목 순").tag(1)
                Text("최근 클릭 순").tag(2)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding([.horizontal])

                List {
                    ForEach(filtered) { webtoon in
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
                                Text("평가: \(webtoon.rating.rawValue)")
                                    .font(.subheadline)
                                Text("연재 상태: \(webtoon.status.rawValue)")
                                    .font(.subheadline)
                                if !webtoon.studio.isEmpty {
                                    Text("스튜디오: \(webtoon.studio)")
                                        .font(.subheadline)
                                }
                                if !webtoon.categories.isEmpty {
                                    Text("장르: \(webtoon.categories.joined(separator: ", "))")
                                        .font(.subheadline)
                                }
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
                    .onDelete { offsets in
                        offsets.map { filtered[$0] }.forEach(delete)
                    }
                }
                .environment(\.editMode, $editMode)
            }
            .dismissKeyboardOnTap()
            .onChange(of: sortOption) { _ in
                sort()
            }
            .onAppear { sort() }
            .navigationTitle("웹툰 검색")
            .sheet(item: $editingWebtoon) { webtoon in
                AddWebtoonView(store: store, webtoon: webtoon)
            }
        }
    }

    private func sort() {
        switch sortOption {
        case 0:
            store.webtoons.sort { $0.rating.order > $1.rating.order }
        case 1:
            store.webtoons.sort { $0.title < $1.title }
        case 2:
            store.webtoons.sort { $0.lastAccess > $1.lastAccess }
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
