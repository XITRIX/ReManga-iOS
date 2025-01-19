// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let reMangaApiSimilarResultModelWelcome = try? JSONDecoder().decode(ReMangaApiSimilarResultModelWelcome.self, from: jsonData)

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ReMangaApiSimilarResultModel
struct ReMangaApiSimilarResultModel: Codable, Hashable {
    let msg: String
    let content: [ReMangaApiSimilarResultModelContent]
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaApiSimilarResultModelContent
struct ReMangaApiSimilarResultModelContent: Codable, Hashable {
    let id: Int?
    let draw, genre, history: Bool?
    let score: Int?
    let title: ReMangaApiSimilarResultModelTitle
    let rated: Int?
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaApiSimilarResultModelTitle
struct ReMangaApiSimilarResultModelTitle: Codable, Hashable {
    let id: Int?
    let enName, rusName, dir: String
    let issueYear: Int?
    let avgRating: String?
    let adminRating: String?
    let totalVotes, totalViews: Int?
    let isLicensed: Bool?
    let coverHigh, coverMid, coverLow: String?
    let type: String?
    let promoLink: String?
    let countChapters: Int?
    let isYaoi, isErotic: Bool?
    let bookmarkType: String?
    let img: ReMangaApiSimilarResultModelImg
    let isPromo: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case enName = "en_name"
        case rusName = "rus_name"
        case dir
        case issueYear = "issue_year"
        case avgRating = "avg_rating"
        case adminRating = "admin_rating"
        case totalVotes = "total_votes"
        case totalViews = "total_views"
        case isLicensed = "is_licensed"
        case coverHigh = "cover_high"
        case coverMid = "cover_mid"
        case coverLow = "cover_low"
        case type
        case promoLink = "promo_link"
        case countChapters = "count_chapters"
        case isYaoi = "is_yaoi"
        case isErotic = "is_erotic"
        case bookmarkType = "bookmark_type"
        case img
        case isPromo = "is_promo"
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaApiSimilarResultModelImg
struct ReMangaApiSimilarResultModelImg: Codable, Hashable {
    let high, mid, low: String
}
