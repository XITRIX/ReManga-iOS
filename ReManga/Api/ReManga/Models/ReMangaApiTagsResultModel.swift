// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let reMangaApiTagsResultModelWelcome = try? JSONDecoder().decode(ReMangaApiTagsResultModelWelcome.self, from: jsonData)

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ReMangaApiTagsResultModel
struct ReMangaApiTagsResultModel: Codable, Hashable {
    let msg: String?
    let content: ReMangaApiTagsResultModelContent
    let props: ReMangaApiTagsResultModelProps?
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaApiTagsResultModelContent
struct ReMangaApiTagsResultModelContent: Codable, Hashable {
    let genres, categories, types, status: [ReMangaApiTagsResultModelAgeLimit]?
    let ageLimit: [ReMangaApiTagsResultModelAgeLimit]?

    enum CodingKeys: String, CodingKey {
        case genres, categories, types, status
        case ageLimit = "age_limit"
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaApiTagsResultModelAgeLimit
struct ReMangaApiTagsResultModelAgeLimit: Codable, Hashable {
    let id: Int
    let name: String
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaApiTagsResultModelProps
struct ReMangaApiTagsResultModelProps: Codable, Hashable {
    let fields, allowedFields: [String]?

    enum CodingKeys: String, CodingKey {
        case fields
        case allowedFields = "allowed_fields"
    }
}
