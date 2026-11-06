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
struct ReMangaCommentsCountResult: Decodable, Hashable {
    let msg: String?
    let content: Int
}

// MARK: - ReMangaCommentsResult
struct ReMangaCommentsResult: Decodable, Hashable {
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
struct ReMangaCommentsResultContent: Decodable, Hashable {
    let id: Int
    let text: String?
    let countReplies, score: Int?
    let date: ReMangaCommentDate?
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

enum ReMangaCommentDate: Decodable, Hashable {
    case elapsedMilliseconds(Double)
    case timestamp(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let milliseconds = try? container.decode(Double.self) {
            self = .elapsedMilliseconds(milliseconds)
        } else {
            self = .timestamp(try container.decode(String.self))
        }
    }

    var value: Date? {
        switch self {
        case .elapsedMilliseconds(let milliseconds):
            return Date().addingTimeInterval(-milliseconds / 1000)
        case .timestamp(let string):
            return ReMangaDateParser.date(from: string)
        }
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
struct ReMangaCommentsResultUser: Decodable, Hashable {
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
struct ReMangaCommentsResultAvatar: Decodable, Hashable {
    let high, mid, low: String?
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaCommentsResultProps
struct ReMangaCommentsResultProps: Decodable, Hashable {
    let page: Int?
}
