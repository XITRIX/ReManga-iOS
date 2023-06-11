// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let newMangaApiTagsResultModelWelcome = try? JSONDecoder().decode(NewMangaApiTagsResultModelWelcome.self, from: jsonData)

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NewMangaApiTagsResultModelElement
struct NewMangaApiTagsResultModelElement: Codable, Hashable {
    let id: Int
    let title: NewMangaApiTagsResultModelTitle
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaApiTagsResultModelTitle
struct NewMangaApiTagsResultModelTitle: Codable, Hashable {
    let en, ru: String
}

typealias NewMangaApiTagsResultModel = [NewMangaApiTagsResultModelElement]
