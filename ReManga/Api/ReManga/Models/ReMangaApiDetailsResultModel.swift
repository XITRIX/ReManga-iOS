import Foundation

// The v2 detail endpoint returns the title directly, without a content envelope.
struct ReMangaApiDetailsResultContent: Codable, Hashable {
    let id: Int
    let img: ReMangaApiDetailsResultImg?
    let enName, rusName, anotherName, dir, description: String?
    let issueYear: Int?
    let avgRating: String?
    let status, type: ReMangaApiDetailsResultStatus?
    let countBookmarks, totalVotes, totalViews, countComments: Int?
    let genres, categories: [ReMangaApiDetailsResultStatus]?
    let bookmarkType: Int?
    let branches: [ReMangaApiDetailsResultBranch]?
    let continueReading: ReMangaApiDetailsResultContinueReading?

    enum CodingKeys: String, CodingKey {
        case id, dir, description, status, type, genres, categories, branches
        case img = "cover"
        case enName = "secondary_name"
        case rusName = "main_name"
        case anotherName = "another_name"
        case issueYear = "issue_year"
        case avgRating = "avg_rating"
        case countBookmarks = "count_bookmarks"
        case totalVotes = "total_votes"
        case totalViews = "total_views"
        case countComments = "count_comments"
        case bookmarkType = "bookmark_type"
        case continueReading = "continue_reading"
    }
}

struct ReMangaApiDetailsResultBranch: Codable, Hashable {
    let id: Int
    let countChapters: Int?
    let publishers: [ReMangaApiDetailsResultPublisher]?

    enum CodingKeys: String, CodingKey {
        case id, publishers
        case countChapters = "count_chapters"
    }
}

struct ReMangaApiDetailsResultPublisher: Codable, Hashable {
    let name: String?
    let cover: ReMangaApiDetailsResultImg?
    let type: ReMangaApiDetailsResultStatus?
}

struct ReMangaApiDetailsResultStatus: Codable, Hashable {
    let id: Int
    let name: String?
}

struct ReMangaApiDetailsResultContinueReading: Codable, Hashable {
    let id, tome: Int?
    let chapter: String?
}

struct ReMangaApiDetailsResultImg: Codable, Hashable {
    let high, mid, low: String?
}
