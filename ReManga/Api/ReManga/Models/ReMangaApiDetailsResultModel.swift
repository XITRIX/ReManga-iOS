// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let ReMangaApiDetailsResultWelcome = try? JSONDecoder().decode(ReMangaApiDetailsResultWelcome.self, from: jsonData)

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation
import MetaCodable

// MARK: - ReMangaApiDetailsResultWelcome
struct ReMangaApiDetailsResult: Codable, Hashable {
    let msg: String?
    let content: ReMangaApiDetailsResultContent
    let props: ReMangaApiDetailsResultProps?
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaApiDetailsResultContent
@Codable
struct ReMangaApiDetailsResultContent: Hashable {
    let id: Int?
    let img: ReMangaApiDetailsResultImg?
    @CodedAt("en_name") let enName: String?
    @CodedAt("rus_name") let rusName: String?
    @CodedAt("another_name") let anotherName: String?
    let dir: String?
    let description: String?
    @CodedAt("issue_year") let issueYear: Int?

    @CodedAt("avg_rating")
    @Default("--")
    let avgRating: String?
    @CodedAt("admin_rating") let adminRating: String?
    @CodedAt("count_rating") let countRating: Int?
    @CodedAt("age_limit") let ageLimit: Int?
    let status: ReMangaApiDetailsResultStatus?
    @CodedAt("count_bookmarks") let countBookmarks: Int?
    @CodedAt("total_votes") let totalVotes: Int?
    @CodedAt("total_views") let totalViews: Int?
    let type: ReMangaApiDetailsResultStatus?
    let genres: [ReMangaApiDetailsResultStatus]?
    let categories: [ReMangaApiDetailsResultStatus]?
    @CodedAt("bookmark_type") let bookmarkType: Int?
//    let rated: JSONNull?
    let branches: [ReMangaApiDetailsResultBranch]?
    @CodedAt("active_branch") let activeBranch: Int?
    @CodedAt("count_chapters") let countChapters: Int?
//    let firstChapter: JSONNull?
    @CodedAt("continue_reading") let continueReading: ReMangaApiDetailsResultContinueReading?
    @CodedAt("is_licensed") let isLicensed: Bool?
//    let newlateID, newlateTitle, related: JSONNull?
    let uploaded: Int?
    @CodedAt("can_post_comments") let canPostComments: Bool?
    let adaptation: ReMangaApiDetailsResultAdaptation?
    let publishers: [ReMangaApiDetailsResultPublisher]?
    @CodedAt("is_yaoi") let isYaoi: Bool?
    @CodedAt("is_erotic") let isErotic: Bool?

//    enum CodingKeys: String, CodingKey {
//        case id, img
//        case enName = "en_name"
//        case rusName = "rus_name"
//        case anotherName = "another_name"
//        case dir, description
//        case issueYear = "issue_year"
//        case avgRating = "avg_rating"
//        case adminRating = "admin_rating"
//        case countRating = "count_rating"
//        case ageLimit = "age_limit"
//        case status
//        case countBookmarks = "count_bookmarks"
//        case totalVotes = "total_votes"
//        case totalViews = "total_views"
//        case type, genres, categories
//        case bookmarkType = "bookmark_type"
////        case rated
//        case branches
//        case activeBranch = "active_branch"
//        case countChapters = "count_chapters"
////        case firstChapter = "first_chapter"
//        case continueReading = "continue_reading"
//        case isLicensed = "is_licensed"
////        case newlateID = "newlate_id"
////        case newlateTitle = "newlate_title"
////        case related
//        case uploaded
//        case canPostComments = "can_post_comments"
//        case adaptation, publishers
//        case isYaoi = "is_yaoi"
//        case isErotic = "is_erotic"
//    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaApiDetailsResultAdaptation
struct ReMangaApiDetailsResultAdaptation: Codable, Hashable {
    let rusName, enName, dir: String?
    let img: String?

    enum CodingKeys: String, CodingKey {
        case rusName = "rus_name"
        case enName = "en_name"
        case dir, img
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaApiDetailsResultBranch
struct ReMangaApiDetailsResultBranch: Codable, Hashable {
    let id: Int?
    let img: ReMangaApiDetailsResultImg?
    let subscribed: Bool?
    let totalVotes, countChapters: Int?
    let publishers: [ReMangaApiDetailsResultPublisher]?

    enum CodingKeys: String, CodingKey {
        case id, img, subscribed
        case totalVotes = "total_votes"
        case countChapters = "count_chapters"
        case publishers
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaApiDetailsResultPublisher
struct ReMangaApiDetailsResultPublisher: Codable, Hashable {
    let id: Int?
    let name, img, dir, tagline: String?
    let cover: ReMangaApiDetailsResultImg?
    let type: String?
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaApiDetailsResultStatus
struct ReMangaApiDetailsResultStatus: Codable, Hashable {
    let id: Int
    let name: String?
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaApiDetailsResultContinueReading
struct ReMangaApiDetailsResultContinueReading: Codable, Hashable {
    let id, tome: Int?
    let chapter: String?
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaApiDetailsResultImg
struct ReMangaApiDetailsResultImg: Codable, Hashable {
    let high, mid, low: String?
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaApiDetailsResultProps
struct ReMangaApiDetailsResultProps: Codable, Hashable {
    let ageLimit: [ReMangaApiDetailsResultStatus]?
    let canUploadChapters, canUpdate, canPinComment: Bool?
//    let promoOffer, adminLink, panelLink: JSONNull?

    enum CodingKeys: String, CodingKey {
        case ageLimit = "age_limit"
        case canUploadChapters = "can_upload_chapters"
        case canUpdate = "can_update"
        case canPinComment = "can_pin_comment"
//        case promoOffer = "promo_offer"
//        case adminLink = "admin_link"
//        case panelLink = "panel_link"
    }
}
