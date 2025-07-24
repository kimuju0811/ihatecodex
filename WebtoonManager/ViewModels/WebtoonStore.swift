import Foundation
import Combine

class WebtoonStore: ObservableObject {
    @Published var webtoons: [Webtoon] = []
    @Published var autoUpdate: Bool = true

    private var timer: Timer?

    init() {
        startAutoUpdate()
    }

    func add(_ webtoon: Webtoon) {
        webtoons.append(webtoon)
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
}
