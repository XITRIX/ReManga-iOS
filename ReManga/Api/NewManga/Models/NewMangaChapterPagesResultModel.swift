// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let newMangaChapterPagesResultWelcome = try? JSONDecoder().decode(NewMangaChapterPagesResultWelcome.self, from: jsonData)

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NewMangaChapterPagesResultWelcome
struct NewMangaChapterPagesResult: Codable, Hashable {
    let isStatic: Bool?
    let origin: String
    let pages: [NewMangaChapterPagesResultPage]

    enum CodingKeys: String, CodingKey {
        case isStatic = "is_static"
        case origin, pages
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaChapterPagesResultPage
struct NewMangaChapterPagesResultPage: Codable, Hashable {
    let index: Int
    let slices: [NewMangaChapterPagesResultSlice]
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaChapterPagesResultSlice
struct NewMangaChapterPagesResultSlice: Codable, Hashable {
    let format: String?
    let path: String
    let size: NewMangaChapterPagesResultSize
}

//enum NewMangaChapterPagesResultFormat: String, Codable, Hashable {
//    case webp = "webp"
//}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaChapterPagesResultSize
struct NewMangaChapterPagesResultSize: Codable, Hashable {
    let width, height: Int
}
