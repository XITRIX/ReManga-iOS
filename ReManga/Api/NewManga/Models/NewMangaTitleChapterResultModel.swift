// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let newMangaTitleChapterResultWelcome = try? JSONDecoder().decode(NewMangaTitleChapterResultWelcome.self, from: jsonData)

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NewMangaTitleChapterResultWelcome
struct NewMangaTitleChapterResult: Codable, Hashable {
    let items: [NewMangaTitleChapterResultItem]
    let count: Int
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaTitleChapterResultItem
struct NewMangaTitleChapterResultItem: Codable, Hashable {
    let id, tom: Int?
    let name: String?
    let number: Double?
    let projectID, branchID, hearts: Int?
    let price: Int?
    let isAvailable, isViewed, hasHeart: Bool?
    let translator: String?
    let expiresAt: String?
    let createdAt: String?
    let isExpired: Bool?
    let pages: Int?
    let isPublished, isParsed: Bool?
    let origin: NewMangaTitleChapterResultOrigin?

    enum CodingKeys: String, CodingKey {
        case id, tom, name, number
        case projectID = "project_id"
        case branchID = "branch_id"
        case hearts, price
        case isAvailable = "is_available"
        case isViewed = "is_viewed"
        case hasHeart = "has_heart"
        case translator
        case expiresAt = "expires_at"
        case createdAt = "created_at"
        case isExpired = "is_expired"
        case pages
        case isPublished = "is_published"
        case isParsed = "is_parsed"
        case origin
    }
}

enum NewMangaTitleChapterResultOrigin: String, Codable, Hashable {
    case appDisk1Main = "app_disk1_main"
    case appDisk2Main = "app_disk2_main"
}
