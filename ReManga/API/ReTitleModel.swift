// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let ReTitleWelcome = try? newJSONDecoder().decode(ReTitleWelcome.self, from: jsonData)

import Foundation

// MARK: - ReTitleModel
struct ReTitleModel: Codable {
    let msg: String?
    let content: ReTitleContent
    let props: ReTitleProps?

    enum CodingKeys: String, CodingKey {
        case msg = "msg"
        case content = "content"
        case props = "props"
    }
}

// MARK: - ReTitleContent
struct ReTitleContent: Codable {
    let id: Int
    let img: ReTitleImg?
    let enName: String?
    let rusName: String?
    let anotherName: String?
    let dir: String?
    let contentDescription: String?
    let issueYear: Int?
    let avgRating: String?
    let countRating: Int?
    let ageLimit: Int?
    let status: ReTitleStatus?
    let countBookmarks: Int?
    let totalVotes: Int?
    let totalViews: Int?
    let type: ReTitleStatus?
    let genres: [ReTitleStatus]?
    let categories: [ReTitleStatus]?
    let publishers: [ReTitlePublisher]?
    let bookmarkType: Int?
    let rated: Int?
    let branches: [ReTitleBranch]?
    let activeBranch: Int?
    let countChapters: Int?
    let firstChapter: ReTitleChapter?
    let continueReading: ReTitleChapter?
    let isLicensed: Bool?
    let isAdsenseBlocked: Int?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case img = "img"
        case enName = "en_name"
        case rusName = "rus_name"
        case anotherName = "another_name"
        case dir = "dir"
        case contentDescription = "description"
        case issueYear = "issue_year"
        case avgRating = "avg_rating"
        case countRating = "count_rating"
        case ageLimit = "age_limit"
        case status = "status"
        case countBookmarks = "count_bookmarks"
        case totalVotes = "total_votes"
        case totalViews = "total_views"
        case type = "type"
        case genres = "genres"
        case categories = "categories"
        case publishers = "publishers"
        case bookmarkType = "bookmark_type"
        case rated = "rated"
        case branches = "branches"
        case activeBranch = "active_branch"
        case countChapters = "count_chapters"
        case firstChapter = "first_chapter"
        case continueReading = "continue_reading"
        case isLicensed = "is_licensed"
        case isAdsenseBlocked = "is_adsense_blocked"
    }
}

// MARK: - ReTitleBranch
struct ReTitleBranch: Codable {
    let id: Int?
    let img: String?
    let publishers: [ReTitlePublisher]?
    let subscribed: Bool?
    let totalVotes: Int?
    let countChapters: Int?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case img = "img"
        case publishers = "publishers"
        case subscribed = "subscribed"
        case totalVotes = "total_votes"
        case countChapters = "count_chapters"
    }
}

// MARK: - ReTitlePublisher
struct ReTitlePublisher: Codable {
    let id: Int?
    let name: String?
    let img: String?
    let dir: String?
    let tagline: String?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case img = "img"
        case dir = "dir"
        case tagline = "tagline"
        case type = "type"
    }
}

// MARK: - ReTitleStatus
struct ReTitleStatus: Codable {
    let id: Int?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}

// MARK: - ReTitleChapter
struct ReTitleChapter: Codable {
    let id: Int?
    let tome: Int?
    let chapter: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case tome = "tome"
        case chapter = "chapter"
    }
}

// MARK: - ReTitleImg
struct ReTitleImg: Codable {
    let high: String?
    let mid: String?
    let low: String?

    enum CodingKeys: String, CodingKey {
        case high = "high"
        case mid = "mid"
        case low = "low"
    }
}

// MARK: - ReTitleProps
struct ReTitleProps: Codable {
    let bookmarkTypes: [ReTitleStatus]?
    let canUpdate: Bool?
    let canUploadChapters: Bool?
    let canPinComment: Bool?
    let canWatchStatistic: Bool?
    let ageLimit: [ReTitleStatus]?

    enum CodingKeys: String, CodingKey {
        case bookmarkTypes = "bookmark_types"
        case canUpdate = "can_update"
        case canUploadChapters = "can_upload_chapters"
        case canPinComment = "can_pin_comment"
        case canWatchStatistic = "can_watch_statistic"
        case ageLimit = "age_limit"
    }
}
