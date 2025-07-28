import SwiftUI

class RecommendationManager: ObservableObject {
    @AppStorage("lastRecommendedDate") private var lastRecommendedTime: Double = 0
    @AppStorage("recommendationHistory") private var historyData: Data = Data()
    @AppStorage("recommendedIDs") private var recommendedIDsData: Data = Data()

    @Published private(set) var recommendedIDs: [UUID] = []
    private var history: [UUID: Date] = [:]

    init(store: WebtoonStore) {
        load()
        generateIfNeeded(from: store)
    }

    func generateIfNeeded(from store: WebtoonStore) {
        let now = Date()
        let calendar = Calendar.current
        let lastDate = Date(timeIntervalSince1970: lastRecommendedTime)
        let needUpdate = recommendedIDs.isEmpty ||
            (calendar.component(.weekday, from: now) == 4 &&
             calendar.component(.weekday, from: lastDate) != 4)
        if needUpdate {
            generate(from: store, now: now)
        }
    }

    func recommended(from store: WebtoonStore) -> [Webtoon] {
        store.webtoons.filter { recommendedIDs.contains($0.id) }
    }

    private func generate(from store: WebtoonStore, now: Date) {
        let candidates = store.webtoons.filter { w in
            w.rating != .poor && !isRecommendedRecently(id: w.id, now: now)
        }
        let selected = Array(candidates.shuffled().prefix(3))
        recommendedIDs = selected.map(\.id)
        lastRecommendedTime = now.timeIntervalSince1970
        saveIDs()
        saveHistory(with: selected, date: now)
    }

    private func isRecommendedRecently(id: UUID, now: Date) -> Bool {
        if let date = history[id] {
            return now.timeIntervalSince(date) < 30 * 24 * 3600
        }
        return false
    }

    private func load() {
        if let ids = try? JSONDecoder().decode([UUID].self, from: recommendedIDsData) {
            recommendedIDs = ids
        }
        if let dict = try? JSONDecoder().decode([UUID: Date].self, from: historyData) {
            history = dict
        }
    }

    private func saveIDs() {
        if let data = try? JSONEncoder().encode(recommendedIDs) {
            recommendedIDsData = data
        }
    }

    private func saveHistory(with selected: [Webtoon], date: Date) {
        for w in selected { history[w.id] = date }
        if let data = try? JSONEncoder().encode(history) {
            historyData = data
        }
    }
}

