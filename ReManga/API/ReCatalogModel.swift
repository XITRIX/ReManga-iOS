// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let reCatalogWelcome = try? newJSONDecoder().decode(ReCatalogWelcome.self, from: jsonData)

import Foundation

// MARK: - ReCatalogWelcome
struct ReCatalogModel: Codable, Hashable {
    let msg: String?
    let content: [ReCatalogContent]
    let props: ReCatalogProps?

    enum CodingKeys: String, CodingKey {
        case msg = "msg"
        case content = "content"
        case props = "props"
    }
}

// MARK: - ReCatalogContent
struct ReCatalogContent: Codable, Hashable {
    let id: Int?
    let enName: String?
    let rusName: String?
    let dir: String?
    let issueYear: Int?
    let avgRating: String?
    let type: String?
    let totalViews: Int?
    let totalVotes: Int?
    let coverHigh: String?
    let coverMid: String?
    let coverLow: String?
    let promoLink: String?
    let img: ReCatalogImg?
    let bookmarkType: ReCatalogBookmarkType?
    let genres: [ReCatalogCategory]?
    let categories: [ReCatalogCategory]?
    let countChapters: Int?
    let isPromo: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case enName = "en_name"
        case rusName = "rus_name"
        case dir = "dir"
        case issueYear = "issue_year"
        case avgRating = "avg_rating"
        case type = "type"
        case totalViews = "total_views"
        case totalVotes = "total_votes"
        case coverHigh = "cover_high"
        case coverMid = "cover_mid"
        case coverLow = "cover_low"
        case promoLink = "promo_link"
        case bookmarkType = "bookmark_type"
        case genres = "genres"
        case img = "img"
        case categories = "categories"
        case countChapters = "count_chapters"
        case isPromo = "is_promo"
    }
}

enum ReCatalogBookmarkType: String, Codable, Hashable {
    case будуЧитать = "Буду читать"
    case прочитано = "Прочитано"
    case читаю = "Читаю"
}

// MARK: - ReCatalogCategory
struct ReCatalogCategory: Codable, Hashable {
    let id: Int?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}

// MARK: - ReCatalogImg
struct ReCatalogImg: Codable, Hashable {
    let high: String?
    let mid: String?
    let low: String?

    enum CodingKeys: String, CodingKey {
        case high = "high"
        case mid = "mid"
        case low = "low"
    }
}

//enum ReCatalogType: String, Codable {
//    case западныйКомикс = "Западный комикс"
//    case манхва = "Манхва"
//    case маньхуа = "Маньхуа"
//    case рукомикс = "Рукомикс"
//}

// MARK: - ReCatalogProps
struct ReCatalogProps: Codable, Hashable {
    let totalItems: Int?
    let totalPages: Int?
    let page: Int?

    enum CodingKeys: String, CodingKey {
        case totalItems = "total_items"
        case totalPages = "total_pages"
        case page = "page"
    }
}
