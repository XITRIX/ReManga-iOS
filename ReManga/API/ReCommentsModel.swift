// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let reCommentsModel = try? newJSONDecoder().decode(ReCommentsModel.self, from: jsonData)

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ReCommentsModel
struct ReCommentsModel: Codable, Hashable {
    let msg: String?
    let content: [ReCommentsContent]
    let props: ReCommentsProps?
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReCommentsContent
struct ReCommentsContent: Codable, Hashable {
    let id: Int?
    let text: String?
    let countReplies: Int?
    let user: ReCommentsUser?
    let date: Double
    let score: Int
    let rated: Int?
    let isSpoiler, isPinned: Bool?
    let rank: String?

    enum CodingKeys: String, CodingKey {
        case id, text
        case countReplies = "count_replies"
        case user, date, score, rated
        case isSpoiler = "is_spoiler"
        case isPinned = "is_pinned"
        case rank
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReCommentsUser
struct ReCommentsUser: Codable, Hashable {
    let id: Int?
    let username: String?
    let avatar: ReCommentsAvatar?
    let tagline: String?
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReCommentsAvatar
struct ReCommentsAvatar: Codable, Hashable {
    let high, mid, low: String?
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReCommentsProps
struct ReCommentsProps: Codable, Hashable {
    let totalItems, totalPages, page: Int?

    enum CodingKeys: String, CodingKey {
        case totalItems = "total_items"
        case totalPages = "total_pages"
        case page
    }
}
