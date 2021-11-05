// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let reUserModel = try? newJSONDecoder().decode(ReUserModel.self, from: jsonData)

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ReUserModel
struct ReUserModel: Codable, Hashable {
    let msg: String?
    let content: ReUserContent
    let props: ReUserProps?
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReUserContent
struct ReUserContent: Codable, Hashable {
    let id: Int
    let username: String?
//    let badges: [JSONAny]?
    let isSuperuser, isStaff: Bool?
    let balance: String
    let avatar, email: String?
    let sex: Int?
//    let publishers: [JSONAny]?
    let vkNot: Bool?
    let yaoi: Int?
    let adult: Bool?
    let chaptersRead: Int
    let vkID: String?
    let googleID, yandexID, mailID: JSONNull?
    let isTwoFactorAuth: Bool?
    let tagline: JSONNull?
    let preference, countViews, countVotes, countComments: Int?

    enum CodingKeys: String, CodingKey {
        case id, username
        case isSuperuser = "is_superuser"
        case isStaff = "is_staff"
        case balance, avatar, email, sex
        case vkNot = "vk_not"
        case yaoi, adult
        case chaptersRead = "chapters_read"
        case vkID = "vk_id"
        case googleID = "google_id"
        case yandexID = "yandex_id"
        case mailID = "mail_id"
        case isTwoFactorAuth = "is_two_factor_auth"
        case tagline, preference
        case countViews = "count_views"
        case countVotes = "count_votes"
        case countComments = "count_comments"
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReUserProps
struct ReUserProps: Codable, Hashable {
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}
