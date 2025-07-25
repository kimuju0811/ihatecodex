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
    var savedAt: Date = Date()
    var lastAccess: Date = Date()

    enum CodingKeys: String, CodingKey {
        case id, title, writers, studio, categories, status, rating, episodes, lastRead, review, thumbnailURL, thumbnailData, savedAt, lastAccess
    }

    init(id: UUID = UUID(), title: String, writers: [String], studio: String, categories: [String], status: WebtoonStatus, rating: WebtoonRating, episodes: Int, lastRead: Int, review: String, thumbnailURL: String, thumbnailData: Data?, savedAt: Date = Date(), lastAccess: Date = Date()) {
        self.id = id
        self.title = title
        self.writers = writers
        self.studio = studio
        self.categories = categories
        self.status = status
        self.rating = rating
        self.episodes = episodes
        self.lastRead = lastRead
        self.review = review
        self.thumbnailURL = thumbnailURL
        self.thumbnailData = thumbnailData
        self.savedAt = savedAt
        self.lastAccess = lastAccess
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        title = try container.decode(String.self, forKey: .title)
        writers = try container.decode([String].self, forKey: .writers)
        studio = try container.decode(String.self, forKey: .studio)
        categories = try container.decode([String].self, forKey: .categories)
        status = try container.decode(WebtoonStatus.self, forKey: .status)
        rating = try container.decode(WebtoonRating.self, forKey: .rating)
        episodes = try container.decode(Int.self, forKey: .episodes)
        lastRead = try container.decode(Int.self, forKey: .lastRead)
        review = try container.decode(String.self, forKey: .review)
        thumbnailURL = try container.decode(String.self, forKey: .thumbnailURL)
        thumbnailData = try container.decodeIfPresent(Data.self, forKey: .thumbnailData)
        savedAt = try container.decodeIfPresent(Date.self, forKey: .savedAt) ?? Date()
        lastAccess = try container.decodeIfPresent(Date.self, forKey: .lastAccess) ?? savedAt
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(writers, forKey: .writers)
        try container.encode(studio, forKey: .studio)
        try container.encode(categories, forKey: .categories)
        try container.encode(status, forKey: .status)
        try container.encode(rating, forKey: .rating)
        try container.encode(episodes, forKey: .episodes)
        try container.encode(lastRead, forKey: .lastRead)
        try container.encode(review, forKey: .review)
        try container.encode(thumbnailURL, forKey: .thumbnailURL)
        try container.encodeIfPresent(thumbnailData, forKey: .thumbnailData)
        try container.encode(savedAt, forKey: .savedAt)
        try container.encode(lastAccess, forKey: .lastAccess)
    }
}
