// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let reMangaCommentsResultWelcome = try? JSONDecoder().decode(ReMangaCommentsResultWelcome.self, from: jsonData)

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ReMangaCommentsResult
struct ReMangaCommentsResult: Codable, Hashable {
    let msg: String?
    let content: [ReMangaCommentsResultContent]
    let props: ReMangaCommentsResultProps?
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaCommentsResultContent
struct ReMangaCommentsResultContent: Codable, Hashable {
    let id: Int
    let text: String?
    let countReplies, date, score: Int?
    let isSpoiler, isPinned: Bool?
    let rated: Int?
    let rank: String? //ReMangaCommentsResultRank?
    let user: ReMangaCommentsResultUser

    enum CodingKeys: String, CodingKey {
        case id, text
        case countReplies = "count_replies"
        case date, score
        case rated
        case isSpoiler = "is_spoiler"
        case isPinned = "is_pinned"
        case rank, user
    }
}

enum ReMangaCommentsResultRank: String, Codable, Hashable {
    case ruby = "ruby"
    case transparent = "transparent"
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaCommentsResultUser
struct ReMangaCommentsResultUser: Codable, Hashable {
    let id: Int
    let username: String
    let avatar: ReMangaCommentsResultAvatar?
    let tagline: String?
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaCommentsResultAvatar
struct ReMangaCommentsResultAvatar: Codable, Hashable {
    let high, mid, low: String?
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaCommentsResultProps
struct ReMangaCommentsResultProps: Codable, Hashable {
    let page: Int?
}
