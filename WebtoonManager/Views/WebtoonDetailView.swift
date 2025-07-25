import SwiftUI

struct WebtoonDetailView: View {
    @ObservedObject var store: WebtoonStore
    @State var webtoon: Webtoon
    @State private var showMenu = false
    @State private var showPicker = false

    private var progress: Double {
        guard webtoon.episodes > 0 else { return 0 }
        return Double(webtoon.lastRead) / Double(webtoon.episodes)
    }

    private var progressText: String {
        if webtoon.episodes == 0 { return "안 읽음" }
        if webtoon.lastRead == 0 { return "안 읽음" }
        if webtoon.lastRead >= webtoon.episodes { return "다 읽음" }
        return "\(webtoon.lastRead)/\(webtoon.episodes)"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let data = webtoon.thumbnailData, let ui = UIImage(data: data) {
                    Image(uiImage: ui).resizable().scaledToFit().frame(maxWidth: .infinity)
                } else {
                    AsyncImage(url: URL(string: webtoon.thumbnailURL)) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable().scaledToFit().frame(maxWidth: .infinity)
                        default:
                            Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 200)
                        }
                    }
                }

                Text(webtoon.title).font(.largeTitle).bold()
                Text(webtoon.writers.joined(separator: ", ")).foregroundColor(.secondary)
                progressBar
                Text("장르: \(webtoon.categories.joined(separator: ", "))")
                Text("연재 상태: \(webtoon.status.rawValue)")
                Text("평가: \(webtoon.rating.rawValue)")
                TextEditor(text: $webtoon.review).frame(minHeight: 100)
            }
            .padding()
        }
        .navigationTitle(webtoon.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { store.touch(webtoon) }
        .confirmationDialog("진행 상태", isPresented: $showMenu) {
            Button("안 읽음") { webtoon.lastRead = 0; update() }
            Button("읽는 중") { showPicker = true }
            Button("다 읽음") { webtoon.lastRead = webtoon.episodes; update() }
        }
        .sheet(isPresented: $showPicker) {
            VStack {
                Picker("회차", selection: $webtoon.lastRead) {
                    ForEach(0...webtoon.episodes, id: \.self) { Text("\($0)").tag($0) }
                }
                .pickerStyle(WheelPickerStyle())
                Button("확인") { update(); showPicker = false }
            }.padding()
        }
    }

    private var progressBar: some View {
        ZStack {
            GeometryReader { geo in
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 20)
                RoundedRectangle(cornerRadius: 8)
                    .fill(webtoon.lastRead >= webtoon.episodes && webtoon.episodes > 0 ? Color.black : Color.yellow)
                    .frame(width: geo.size.width * progress, height: 20)
            }
            Text(progressText)
                .foregroundColor(webtoon.lastRead >= webtoon.episodes && webtoon.episodes > 0 ? .white : .black)
        }
        .frame(height: 20)
        .onTapGesture { showMenu = true }
    }

    private func update() {
        store.update(webtoon)
    }
}

#Preview {
    WebtoonDetailView(store: WebtoonStore(), webtoon: Webtoon(title: "Sample", writers: ["Writer"], studio: "Studio", categories: ["Category"], status: .ongoing, rating: .average, episodes: 10, lastRead: 0, review: "", thumbnailURL: "", thumbnailData: nil))
}
