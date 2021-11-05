// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let reSimilarWelcome = try? newJSONDecoder().decode(ReSimilarWelcome.self, from: jsonData)

import Foundation

// MARK: - ReSimilarWelcome
struct ReSimilarModel: Codable {
    let msg: String?
    let content: [ReSimilarContent]
    let props: ReSimilarProps?

    enum CodingKeys: String, CodingKey {
        case msg = "msg"
        case content = "content"
        case props = "props"
    }
}

// MARK: - ReSimilarContent
struct ReSimilarContent: Codable {
    let id: Int?
    let enName: String?
    let rusName: String?
    let dir: String?
    let issueYear: Int?
    let avgRating: String?
    let totalVotes: Int?
    let totalViews: Int?
    let coverHigh: String?
    let coverMid: String?
    let coverLow: String?
    let type: String?
    let promoLink: String?
    let countChapters: Int?
    let bookmarkType: String?
    let img: ReSimilarImg?
    let isPromo: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case enName = "en_name"
        case rusName = "rus_name"
        case dir = "dir"
        case issueYear = "issue_year"
        case avgRating = "avg_rating"
        case totalVotes = "total_votes"
        case totalViews = "total_views"
        case coverHigh = "cover_high"
        case coverMid = "cover_mid"
        case coverLow = "cover_low"
        case type = "type"
        case promoLink = "promo_link"
        case countChapters = "count_chapters"
        case bookmarkType = "bookmark_type"
        case img = "img"
        case isPromo = "is_promo"
    }
}

// MARK: - ReSimilarImg
struct ReSimilarImg: Codable {
    let high: String?
    let mid: String?
    let low: String?

    enum CodingKeys: String, CodingKey {
        case high = "high"
        case mid = "mid"
        case low = "low"
    }
}

// MARK: - ReSimilarProps
struct ReSimilarProps: Codable {
}
