// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let newMangaCatalogResultWelcome = try? JSONDecoder().decode(NewMangaCatalogResultWelcome.self, from: jsonData)

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NewMangaCatalogResult
struct NewMangaCatalogResult: Codable, Hashable {
    let debug: NewMangaCatalogResultDebug?
    let result: NewMangaCatalogResultResult

    enum CodingKeys: String, CodingKey {
        case debug = "__debug"
        case result
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaCatalogResultDebug
struct NewMangaCatalogResultDebug: Codable, Hashable {
    let requestTime: String?
    let engineQuery: NewMangaCatalogResultEngineQuery?

    enum CodingKeys: String, CodingKey {
        case requestTime = "request_time"
        case engineQuery = "engine_query"
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaCatalogResultEngineQuery
struct NewMangaCatalogResultEngineQuery: Codable, Hashable {
    let q, queryBy, queryByWeights, numTypos: String?
    let sortBy, hiddenHits, filterBy: String?
    let page, perPage: Int?
    let exhaustiveSearch, engineQueryPrefix: Bool?

    enum CodingKeys: String, CodingKey {
        case q
        case queryBy = "query_by"
        case queryByWeights = "query_by_weights"
        case numTypos = "num_typos"
        case sortBy = "sort_by"
        case hiddenHits = "hidden_hits"
        case filterBy = "filter_by"
        case page
        case perPage = "per_page"
        case exhaustiveSearch = "exhaustive_search"
        case engineQueryPrefix = "prefix"
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaCatalogResultResult
struct NewMangaCatalogResultResult: Codable, Hashable {
//    let facetCounts: [JSONAny]?
    let found: Int?
    let hits: [NewMangaCatalogResultHit]?
    let outOf, page: Int?
    let requestParams: NewMangaCatalogResultRequestParams?
    let searchCutoff: Bool?
    let searchTimeMS: Int?

    enum CodingKeys: String, CodingKey {
//        case facetCounts = "facet_counts"
        case found, hits
        case outOf = "out_of"
        case page
        case requestParams = "request_params"
        case searchCutoff = "search_cutoff"
        case searchTimeMS = "search_time_ms"
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaCatalogResultHit
struct NewMangaCatalogResultHit: Codable, Hashable {
    let document: NewMangaCatalogResultDocument?
//    let highlights: [JSONAny]?
    let textMatch: Int?

    enum CodingKeys: String, CodingKey {
        case document
        case textMatch = "text_match"
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaCatalogResultDocument
struct NewMangaCatalogResultDocument: Codable, Hashable {
    let adult: String?
    let countChapters, createdAt: Int?
    let description: String?
    let genres: [String]?
    let hearts: Int?
    let id, imageLarge, imageSmall: String
    let indexedTitleEn: String?
    let indexedTitleOg, indexedTitleRu: String?
    let isActive: Bool?
    let originalStatus: NewMangaCatalogResultStatus?
    let rating, ratingRank: Double?
    let releasedAt, releasedYear: Int?
    let slug: String
    let status: NewMangaCatalogResultStatus?
    let tags: [String]?
    let titleEn, titleOg, titleRu: String?
    let type: NewMangaCatalogResultType?
    let views: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case countChapters = "count_chapters"
        case createdAt = "created_at"
        case description, genres, hearts, id
        case imageLarge = "image_large"
        case imageSmall = "image_small"
        case indexedTitleEn = "indexed_title_en"
        case indexedTitleOg = "indexed_title_og"
        case indexedTitleRu = "indexed_title_ru"
        case isActive = "is_active"
        case originalStatus = "original_status"
        case rating
        case ratingRank = "rating_rank"
        case releasedAt = "released_at"
        case releasedYear = "released_year"
        case slug, status, tags
        case titleEn = "title_en"
        case titleOg = "title_og"
        case titleRu = "title_ru"
        case type, views
    }
}

enum NewMangaCatalogResultStatus: String, Codable, Hashable {
    case onGoing = "on_going"
    case suspended = "suspended"
    case completed = "completed"
    case announcement = "announcement"
    case abandoned = "abandoned"
}

enum NewMangaCatalogResultType: String, Codable, Hashable {
    case manga = "manga"
    case manhwa = "manhwa"
    case manhya = "manhya"
    case single = "single"
    case oel = "oel"
    case comics = "comics"
    case russian = "russian"
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaCatalogResultRequestParams
struct NewMangaCatalogResultRequestParams: Codable, Hashable {
    let collectionName: String?
    let perPage: Int?
    let q: String?

    enum CodingKeys: String, CodingKey {
        case collectionName = "collection_name"
        case perPage = "per_page"
        case q
    }
}
