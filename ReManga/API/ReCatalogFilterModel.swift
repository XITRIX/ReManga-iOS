// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let reCatalogFilterModel = try? newJSONDecoder().decode(ReCatalogFilterModel.self, from: jsonData)

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ReCatalogFilterModel
struct ReCatalogFilterModel: Codable, Hashable {
    let msg: String?
    let content: ReCatalogFilterContent
    let props: ReCatalogFilterProps?

    enum CodingKeys: String, CodingKey {
        case msg = "msg"
        case content = "content"
        case props = "props"
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReCatalogFilterContent
struct ReCatalogFilterContent: Codable, Hashable {
    let genres: [ReCatalogFilterItem]?
    let categories: [ReCatalogFilterItem]?
    let types: [ReCatalogFilterItem]?
    let status: [ReCatalogFilterItem]?
    let ageLimit: [ReCatalogFilterItem]?

    enum CodingKeys: String, CodingKey {
        case genres = "genres"
        case categories = "categories"
        case types = "types"
        case status = "status"
        case ageLimit = "age_limit"
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReCatalogFilterItem
struct ReCatalogFilterItem: Codable, Hashable {
    let id: Int?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReCatalogFilterProps
struct ReCatalogFilterProps: Codable, Hashable {
    let fields: [String]?
    let allowedFields: [String]?

    enum CodingKeys: String, CodingKey {
        case fields = "fields"
        case allowedFields = "allowed_fields"
    }
}
