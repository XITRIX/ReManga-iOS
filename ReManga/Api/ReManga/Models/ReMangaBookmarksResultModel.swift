// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let reMangaBookmarksResultWelcome = try? JSONDecoder().decode(ReMangaBookmarksResultWelcome.self, from: jsonData)

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ReMangaBookmarksResult
struct ReMangaBookmarksResult: Codable, Hashable {
    let msg: String?
    let content: [ReMangaBookmarksResultContent]
    let props: ReMangaBookmarksResultProps?
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaBookmarksResultContent
struct ReMangaBookmarksResultContent: Codable, Hashable {
    let id, type: Int
    let rated: Int?
    let title: ReMangaBookmarksResultTitle
    let readProgress, readProgressTotal: Int?
    let isNotifyPaidChapters: Bool?
    let viewState: Int?

    enum CodingKeys: String, CodingKey {
        case id, type, rated, title
        case readProgress = "read_progress"
        case readProgressTotal = "read_progress_total"
        case isNotifyPaidChapters = "is_notify_paid_chapters"
        case viewState = "view_state"
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaBookmarksResultTitle
struct ReMangaBookmarksResultTitle: Codable, Hashable {
    let id: Int
    let dir: String
    let enName, rusName: String?
    let img: ReMangaBookmarksResultImg
    let totalVotes, countChapters: Int?
    let isYaoi, isErotic: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case enName = "en_name"
        case rusName = "rus_name"
        case dir, img
        case totalVotes = "total_votes"
        case countChapters = "count_chapters"
        case isYaoi = "is_yaoi"
        case isErotic = "is_erotic"
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaBookmarksResultImg
struct ReMangaBookmarksResultImg: Codable, Hashable {
    let high, mid, low: String
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaBookmarksResultProps
struct ReMangaBookmarksResultProps: Codable, Hashable {
    let page: Int?
}
