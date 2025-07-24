import Foundation
import Combine

class WebtoonStore: ObservableObject {
    @Published var webtoons: [Webtoon] = [] {
        didSet { save() }
    }
    @Published var autoUpdate: Bool = true {
        didSet { save(); startAutoUpdate() }
    }

    private var timer: Timer?
    private let saveURL: URL = {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("webtoons.json")
    }()

    private struct SavedData: Codable {
        var webtoons: [Webtoon]
        var autoUpdate: Bool
    }

    init() {
        load()
        startAutoUpdate()
    }

    func add(_ webtoon: Webtoon) {
        webtoons.append(webtoon)
    }

    func update(_ webtoon: Webtoon) {
        guard let index = webtoons.firstIndex(where: { $0.id == webtoon.id }) else { return }
        webtoons[index] = webtoon
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

    private func load() {
        guard let data = try? Data(contentsOf: saveURL),
              let saved = try? JSONDecoder().decode(SavedData.self, from: data) else { return }
        webtoons = saved.webtoons
        autoUpdate = saved.autoUpdate
    }

    private func save() {
        let saved = SavedData(webtoons: webtoons, autoUpdate: autoUpdate)
        if let data = try? JSONEncoder().encode(saved) {
            try? data.write(to: saveURL)
        }
    }
}
