import SwiftUI

struct HomeRecommendationSection: View {
    @ObservedObject var store: WebtoonStore
    @StateObject private var manager: RecommendationManager

    init(store: WebtoonStore) {
        _store = ObservedObject(initialValue: store)
        _manager = StateObject(wrappedValue: RecommendationManager(store: store))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("수요일마다 추천")
                .font(.headline)
                .bold()

            HStack(spacing: 12) {
                ForEach(manager.recommended(from: store)) { webtoon in
                    RecommendationCardView(store: store, webtoon: webtoon)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .onAppear { manager.generateIfNeeded(from: store) }
    }
}

struct RecommendationCardView: View {
    @ObservedObject var store: WebtoonStore
    var webtoon: Webtoon

    var body: some View {
        NavigationLink(destination: WebtoonDetailView(store: store, webtoon: webtoon)) {
            VStack(alignment: .leading, spacing: 4) {
                thumbnail
                Text(webtoon.title)
                    .font(.subheadline)
                    .bold()
                    .lineLimit(1)
                Text(webtoon.writers.joined(separator: ", "))
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.secondarySystemBackground))
            )
        }
        .buttonStyle(.plain)
    }

    private var thumbnail: some View {
        Group {
            if let data = webtoon.thumbnailData, let ui = UIImage(data: data) {
                Image(uiImage: ui)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 120)
                    .clipped()
            } else {
                AsyncImage(url: URL(string: webtoon.thumbnailURL)) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                            .scaledToFill()
                            .frame(height: 120)
                            .clipped()
                    default:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 120)
                    }
                }
            }
        }
    }
}

#Preview {
    HomeRecommendationSection(store: WebtoonStore())
}

