import SwiftUI

struct AddWebtoonView: View {
    @ObservedObject var store: WebtoonStore

    @State private var title: String = ""
    @State private var writer: String = ""
    @State private var studio: String = ""
    @State private var category: String = ""
    @State private var status: WebtoonStatus = .ongoing
    @State private var rating: WebtoonRating = .average
    @State private var episodes: Int = 0
    @State private var lastRead: Int = 0
    @State private var review: String = ""
    @State private var thumbnailURL: String = ""

    var body: some View {
        Form {
            Section(header: Text("기본 정보")) {
                TextField("제목", text: $title)
                TextField("작가", text: $writer)
                TextField("스튜디오", text: $studio)
                TextField("카테고리", text: $category)
                TextField("썸네일 URL", text: $thumbnailURL)
                Picker("연재 상태", selection: $status) {
                    ForEach(WebtoonStatus.allCases) { Text($0.rawValue).tag($0) }
                }
                Picker("평가", selection: $rating) {
                    ForEach(WebtoonRating.allCases) { Text($0.rawValue).tag($0) }
                }
            }
            Section(header: Text("회차")) {
                Stepper(value: $episodes, in: 0...1000) {
                    Text("총 회차: \(episodes)")
                }
                Stepper(value: $lastRead, in: 0...episodes) {
                    Text("마지막으로 읽은 회차: \(lastRead)")
                }
            }
            Section(header: Text("리뷰")) {
                TextEditor(text: $review)
            }
            Button("저장") {
                let new = Webtoon(title: title, writer: writer, studio: studio, category: category, status: status, rating: rating, episodes: episodes, lastRead: lastRead, review: review, thumbnailURL: thumbnailURL)
                store.add(new)
                clear()
            }
            Button("취소") { clear() }
        }
    }

    private func clear() {
        title = ""
        writer = ""
        studio = ""
        category = ""
        status = .ongoing
        rating = .average
        episodes = 0
        lastRead = 0
        review = ""
        thumbnailURL = ""
    }
}

#Preview {
    AddWebtoonView(store: WebtoonStore())
}
