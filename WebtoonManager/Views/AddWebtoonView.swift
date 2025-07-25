import SwiftUI
import PhotosUI

struct AddWebtoonView: View {
    @ObservedObject var store: WebtoonStore
    var existing: Webtoon?
    @Environment(\.dismiss) private var dismiss

    @State private var editingId: UUID?

    @State private var title: String
    @State private var writers: [String]
    @State private var studio: String
    @State private var categories: [String]
    @State private var status: WebtoonStatus
    @State private var rating: WebtoonRating
    @State private var episodes: String
    @State private var lastRead: String
    @State private var review: String
    @State private var thumbnailURL: String
    @State private var imageData: Data?
    @State private var pickerItem: PhotosPickerItem?

    init(store: WebtoonStore, webtoon: Webtoon? = nil) {
        self.store = store
        self.existing = webtoon
        _title = State(initialValue: webtoon?.title ?? "")
        _writers = State(initialValue: webtoon?.writers ?? [""])
        _studio = State(initialValue: webtoon?.studio ?? "")
        _categories = State(initialValue: webtoon?.categories ?? [""])
        _status = State(initialValue: webtoon?.status ?? .ongoing)
        _rating = State(initialValue: webtoon?.rating ?? .average)
        _episodes = State(initialValue: webtoon != nil ? String(webtoon!.episodes) : "")
        _lastRead = State(initialValue: webtoon != nil ? String(webtoon!.lastRead) : "")
        _review = State(initialValue: webtoon?.review ?? "")
        _thumbnailURL = State(initialValue: webtoon?.thumbnailURL ?? "")
        _imageData = State(initialValue: webtoon?.thumbnailData)
        _editingId = State(initialValue: webtoon?.id)
    }

    private func loadFromEditing() {
        let w = existing ?? store.editingWebtoon
        guard editingId != w?.id else { return }
        if let w {
            title = w.title
            writers = w.writers
            studio = w.studio
            categories = w.categories
            status = w.status
            rating = w.rating
            episodes = String(w.episodes)
            lastRead = String(w.lastRead)
            review = w.review
            thumbnailURL = w.thumbnailURL
            imageData = w.thumbnailData
            editingId = w.id
        } else {
            clear()
            editingId = nil
        }
    }

    var body: some View {
        Form {
            Section(header: Text("기본 정보")) {
                TextField("제목", text: $title)
                ForEach(writers.indices, id: \.self) { i in
                    HStack {
                        TextField("작가", text: $writers[i])
                            .onSubmit { if i == writers.count - 1 { writers.append("") } }
                        if writers.count > 1 {
                            Button(action: { writers.remove(at: i) }) {
                                Image(systemName: "minus.circle")
                            }
                        }
                    }
                }
                ForEach(categories.indices, id: \.self) { i in
                    HStack {
                        TextField("장르", text: $categories[i])
                            .onSubmit { if i == categories.count - 1 { categories.append("") } }
                        if categories.count > 1 {
                            Button(action: { categories.remove(at: i) }) {
                                Image(systemName: "minus.circle")
                            }
                        }
                    }
                }
                TextField("스튜디오", text: $studio)
                TextField("썸네일 URL", text: $thumbnailURL)
                if let data = imageData, let ui = UIImage(data: data) {
                    Image(uiImage: ui).resizable().scaledToFit().frame(height: 100)
                }
                PhotosPicker(selection: $pickerItem, matching: .images) {
                    Text("이미지 선택")
                }
                .onChange(of: pickerItem) { item in
                    if let item { Task { imageData = try? await item.loadTransferable(type: Data.self) } }
                }
                Picker("연재 상태", selection: $status) {
                    ForEach(WebtoonStatus.allCases) { Text($0.rawValue).tag($0) }
                }
                Picker("평가", selection: $rating) {
                    ForEach(WebtoonRating.allCases) { Text($0.rawValue).tag($0) }
                }
            }
            Section(header: Text("회차")) {
                TextField("총 회차", text: $episodes)
                    .keyboardType(.numberPad)
                TextField("마지막으로 읽은 회차", text: $lastRead)
                    .keyboardType(.numberPad)
                    .onChange(of: lastRead) { newValue in
                        if let e = Int(episodes), let l = Int(newValue), l > e { lastRead = episodes }
                    }
            }
            Section(header: Text("리뷰")) {
                TextEditor(text: $review)
            }
            Button("저장") {
                let epi = Int(episodes) ?? 0
                let last = min(Int(lastRead) ?? 0, epi)
                let new = Webtoon(id: editingId ?? existing?.id ?? UUID(), title: title, writers: writers.filter { !$0.isEmpty }, studio: studio, categories: categories.filter { !$0.isEmpty }, status: status, rating: rating, episodes: epi, lastRead: last, review: review, thumbnailURL: thumbnailURL, thumbnailData: imageData)
                if editingId != nil || existing != nil {
                    store.update(new)
                } else {
                    store.add(new)
                }
                clear()
                store.finishEditing()
                dismiss()
            }
            Button("취소") {
                store.finishEditing()
                dismiss()
            }
        }
        .onAppear { loadFromEditing() }
        .onChange(of: store.editingWebtoon) { _ in loadFromEditing() }
    }

    private func clear() {
        title = ""
        writers = [""]
        studio = ""
        categories = [""]
        status = .ongoing
        rating = .average
        episodes = ""
        lastRead = ""
        review = ""
        thumbnailURL = ""
        imageData = nil
    }
}

#Preview {
    AddWebtoonView(store: WebtoonStore())
}
