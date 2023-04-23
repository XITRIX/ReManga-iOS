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
    let id: Int
    let count: Int?
    let name: String
    let isDefault, isVisible, isNotify: Bool?

    enum CodingKeys: String, CodingKey {
        case id, count, name
        case isDefault = "is_default"
        case isVisible = "is_visible"
        case isNotify = "is_notify"
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaBookmarksResultProps
struct ReMangaBookmarksResultProps: Codable, Hashable {
}
