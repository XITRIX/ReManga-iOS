// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let newMangaApiSimilarResultModelWelcome = try? JSONDecoder().decode(NewMangaApiSimilarResultModelWelcome.self, from: jsonData)

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NewMangaApiSimilarModel
struct NewMangaApiSimilarModel: Codable, Hashable {
    let id: Int
    let title: NewMangaApiSimilarResultModelTitle
    let image: NewMangaApiSimilarResultModelImage
    let type: String?
    let rating: Double?
    let hearts: Int?
    let description: String?
    let slug: String
//    let lastChapterDate: JSONNull?

    enum CodingKeys: String, CodingKey {
        case id, title, image, type, rating, hearts, description, slug
//        case lastChapterDate = "last_chapter_date"
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaApiSimilarResultModelImage
struct NewMangaApiSimilarResultModelImage: Codable, Hashable {
    let name: String
//    let color: [JSONAny]?
    let height, width: Int
    let origin: String
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaApiSimilarResultModelTitle
struct NewMangaApiSimilarResultModelTitle: Codable, Hashable {
    let en, ru: String?
//    let original: JSONNull?
}

typealias NewMangaApiSimilarResultModel = [NewMangaApiSimilarModel]
