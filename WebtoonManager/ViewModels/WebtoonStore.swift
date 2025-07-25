import Foundation
import Combine

class WebtoonStore: ObservableObject {
    @Published var webtoons: [Webtoon] = [] {
        didSet { save() }
    }
    @Published var autoUpdate: Bool = true {
        didSet { save(); startAutoUpdate() }
    }
    @Published var categories: [String] = [] { didSet { save() } }
    @Published var writers: [String] = [] { didSet { save() } }
    @Published var studios: [String] = [] { didSet { save() } }

    private var timer: Timer?
    private let saveURL: URL = {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("webtoons.json")
    }()

    private struct SavedData: Codable {
        var webtoons: [Webtoon]
        var autoUpdate: Bool
        var categories: [String]
        var writers: [String]
        var studios: [String]
    }

    init() {
        load()
        startAutoUpdate()
    }

    func add(_ webtoon: Webtoon) {
        var new = webtoon
        new.savedAt = Date()
        new.lastAccess = new.savedAt
        webtoons.append(new)
        insertLists(from: webtoon)
    }

    func update(_ webtoon: Webtoon) {
        guard let index = webtoons.firstIndex(where: { $0.id == webtoon.id }) else { return }
        webtoons[index] = webtoon
        insertLists(from: webtoon)
    }

    func touch(_ webtoon: Webtoon) {
        guard let index = webtoons.firstIndex(where: { $0.id == webtoon.id }) else { return }
        webtoons[index].lastAccess = Date()
    }

    func startAutoUpdate() {
        timer?.invalidate()
        guard autoUpdate else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.fetchUpdates()
        }
    }

    func fetchUpdates() {
        // Placeholder for API fetch implementation
        // This would call external APIs to refresh data
        print("Fetching updates from API...")
    }

    func toggleAutoUpdate(_ enabled: Bool) {
        autoUpdate = enabled
        startAutoUpdate()
    }

    func renameCategory(at index: Int, new: String) {
        let old = categories[index]
        categories[index] = new
        for i in webtoons.indices {
            webtoons[i].categories = webtoons[i].categories.map { $0 == old ? new : $0 }
        }
    }

    func deleteCategory(at offsets: IndexSet) {
        for i in offsets {
            let removed = categories[i]
            categories.remove(at: i)
            for j in webtoons.indices {
                webtoons[j].categories.removeAll { $0 == removed }
            }
        }
    }

    func renameWriter(at index: Int, new: String) {
        let old = writers[index]
        writers[index] = new
        for i in webtoons.indices {
            webtoons[i].writers = webtoons[i].writers.map { $0 == old ? new : $0 }
        }
    }

    func deleteWriter(at offsets: IndexSet) {
        for i in offsets {
            let removed = writers[i]
            writers.remove(at: i)
            for j in webtoons.indices {
                webtoons[j].writers.removeAll { $0 == removed }
            }
        }
    }

    func renameStudio(at index: Int, new: String) {
        let old = studios[index]
        studios[index] = new
        for i in webtoons.indices {
            if webtoons[i].studio == old {
                webtoons[i].studio = new
            }
        }
    }

    func deleteStudio(at offsets: IndexSet) {
        for i in offsets {
            let removed = studios[i]
            studios.remove(at: i)
            for j in webtoons.indices {
                if webtoons[j].studio == removed {
                    webtoons[j].studio = ""
                }
            }
        }
    }

    private func insertLists(from webtoon: Webtoon) {
        for c in webtoon.categories where !categories.contains(c) {
            categories.append(c)
        }
        for w in webtoon.writers where !writers.contains(w) {
            writers.append(w)
        }
        if !webtoon.studio.isEmpty && !studios.contains(webtoon.studio) {
            studios.append(webtoon.studio)
        }
    }

    private func load() {
        guard let data = try? Data(contentsOf: saveURL),
              let saved = try? JSONDecoder().decode(SavedData.self, from: data) else { return }
        webtoons = saved.webtoons
        autoUpdate = saved.autoUpdate
        categories = saved.categories
        writers = saved.writers
        studios = saved.studios
    }

    private func save() {
        let saved = SavedData(webtoons: webtoons, autoUpdate: autoUpdate, categories: categories, writers: writers, studios: studios)
        if let data = try? JSONEncoder().encode(saved) {
            try? data.write(to: saveURL)
        }
    }
}
