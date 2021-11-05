// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let reSearchModel = try? newJSONDecoder().decode(ReSearchModel.self, from: jsonData)

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ReSearchModel
struct ReSearchModel: Codable, Hashable {
    let msg: String?
    let content: [ReSearchContent]
    let props: ReSearchProps?
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReSearchContent
struct ReSearchContent: Codable, Hashable {
    let id: Int?
    let enName, rusName, dir: String?
    let bookmarkType: String?
    let img: ReSearchImg?
    let issueYear: Int?
    let avgRating: String?
    let type, countChapters: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case enName = "en_name"
        case rusName = "rus_name"
        case dir
        case bookmarkType = "bookmark_type"
        case img
        case issueYear = "issue_year"
        case avgRating = "avg_rating"
        case type
        case countChapters = "count_chapters"
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReSearchImg
struct ReSearchImg: Codable, Hashable {
    let high, mid, low: String?
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReSearchProps
struct ReSearchProps: Codable, Hashable {
    let totalItems, totalPages, page: Int?

    enum CodingKeys: String, CodingKey {
        case totalItems = "total_items"
        case totalPages = "total_pages"
        case page
    }
}
