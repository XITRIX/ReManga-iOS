// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let newMangaBookmarksResultWelcome = try? JSONDecoder().decode(NewMangaBookmarksResultWelcome.self, from: jsonData)

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NewMangaBookmarksResultElement
struct NewMangaBookmarksResultElement: Codable, Hashable {
    let type: String
    let project: NewMangaBookmarksResultProject
    let newChaptersFree, newChaptersPaid: Int?

    enum CodingKeys: String, CodingKey {
        case type, project
        case newChaptersFree = "new_chapters_free"
        case newChaptersPaid = "new_chapters_paid"
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaBookmarksResultProject
struct NewMangaBookmarksResultProject: Codable, Hashable {
    let id: Int
    let title: NewMangaBookmarksResultTitle
    let image: NewMangaBookmarksResultImage
    let type: String?
    let rating: Double?
    let hearts: Int?
    let description: String?
    let slug: String
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaBookmarksResultImage
struct NewMangaBookmarksResultImage: Codable, Hashable {
    let id: Int?
    let name: String
//    let color: [JSONAny]?
    let height, width: Int?
    let origin: String?
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaBookmarksResultTitle
struct NewMangaBookmarksResultTitle: Codable, Hashable {
    let ru, en: String?
}

typealias NewMangaBookmarksResult = [NewMangaBookmarksResultElement]
