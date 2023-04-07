// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let newMangaCatalogRequestWelcome = try? JSONDecoder().decode(NewMangaCatalogRequestWelcome.self, from: jsonData)

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NewMangaCatalogRequestWelcome
struct NewMangaCatalogRequest: Codable, Hashable {
    var query: String = ""
    var sort = NewMangaCatalogRequestSort(kind: "RATING", dir: "DESC")
    var filter = NewMangaCatalogRequestFilter()
    var pagination = NewMangaCatalogRequestPagination()
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaCatalogRequestFilter
struct NewMangaCatalogRequestFilter: Codable, Hashable {
    var hiddenProjects: [String] = []
    var genres = NewMangaCatalogRequestGenres()
    var tags = NewMangaCatalogRequestGenres()
    var type = NewMangaCatalogRequestAdult()
    var translationStatus = NewMangaCatalogRequestAdult()
    var releasedYear = NewMangaCatalogRequestReleasedYear()
    var requireChapters: Bool = true
    var originalStatus = NewMangaCatalogRequestAdult()
    var adult = NewMangaCatalogRequestAdult(allowed: ["ADULT_13", "ADULT_16"])

    enum CodingKeys: String, CodingKey {
        case hiddenProjects = "hidden_projects"
        case genres, tags, type
        case translationStatus = "translation_status"
        case releasedYear = "released_year"
        case requireChapters = "require_chapters"
        case originalStatus = "original_status"
        case adult
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaCatalogRequestAdult
struct NewMangaCatalogRequestAdult: Codable, Hashable {
    var allowed: [String] = []
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaCatalogRequestGenres
struct NewMangaCatalogRequestGenres: Codable, Hashable {
    var excluded: [String] = []
    var included: [String] = []
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaCatalogRequestReleasedYear
struct NewMangaCatalogRequestReleasedYear: Codable, Hashable {
    var min, max: Int?
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaCatalogRequestPagination
struct NewMangaCatalogRequestPagination: Codable, Hashable {
    var page = 1
    var size = 30
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaCatalogRequestSort
struct NewMangaCatalogRequestSort: Codable, Hashable {
    var kind: String = ""
    var dir: String = ""
}
