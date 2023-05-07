// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let newMangaUserResultWelcome = try? JSONDecoder().decode(NewMangaUserResultWelcome.self, from: jsonData)

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NewMangaUserResult
struct NewMangaUserResult: Codable, Hashable {
    let id: Int
    let name: String?
    let isAdmin, isModerator, isTranslator, isActive: Bool?
    let lastLogin: String?
    let isOnline: Bool?
    let image: NewMangaUserResultImage?
//    let email: JSONNull?
    let createdAt: String?
//    let fullName: JSONNull?
    let gender: String?
//    let site, about, vk, discord: JSONNull?
    let isActivated: Bool?
    let balance: Int?
    let authMethods: NewMangaUserResultAuthMethods?

    enum CodingKeys: String, CodingKey {
        case id, name
        case isAdmin = "is_admin"
        case isModerator = "is_moderator"
        case isTranslator = "is_translator"
        case isActive = "is_active"
        case lastLogin = "last_login"
        case isOnline = "is_online"
        case image
//        case email
        case createdAt = "created_at"
//        case fullName = "full_name"
        case gender
//        case site, about, vk, discord
        case isActivated = "is_activated"
        case balance
        case authMethods = "auth_methods"
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaUserResultAuthMethods
struct NewMangaUserResultAuthMethods: Codable, Hashable {
    let password, vk, google, facebook: Bool?
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaUserResultImage
struct NewMangaUserResultImage: Codable, Hashable {
    let name: String?
//    let color: [JSONAny]?
    let height, width: Int?
    let origin: String?
}
