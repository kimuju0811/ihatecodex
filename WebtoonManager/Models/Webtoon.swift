import Foundation

enum WebtoonStatus: String, CaseIterable, Identifiable, Codable {
    case ongoing = "연재 중"
    case completed = "완결"
    case hiatus = "휴재"

    var id: String { rawValue }
}

enum WebtoonRating: String, CaseIterable, Identifiable, Codable {
    case poor = "졸작"
    case average = "보통"
    case good = "수작"
    case great = "명작"

    var id: String { rawValue }
}

struct Webtoon: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var writers: [String]
    var studio: String
    var categories: [String]
    var status: WebtoonStatus
    var rating: WebtoonRating
    var episodes: Int
    var lastRead: Int
    var review: String
    var thumbnailURL: String
    var thumbnailData: Data?
}
