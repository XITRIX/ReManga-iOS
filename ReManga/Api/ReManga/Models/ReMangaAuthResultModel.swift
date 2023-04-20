// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let reMangaAuthResultWelcome = try? JSONDecoder().decode(ReMangaAuthResultWelcome.self, from: jsonData)

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ReMangaAuthResult
struct ReMangaAuthResult: Codable, Hashable {
    let msg: String
    let content: ReMangaAuthResultContent
    let props: ReMangaAuthResultProps?
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaAuthResultContent
struct ReMangaAuthResultContent: Codable, Hashable {
    let accessToken: String
    let authType: String?
    let id: Int?
    let username: String?
    let badges: [ReMangaAuthResultBadge]?
    let isSuperuser, isStaff: Bool?
    let balance: String?
    let ticketBalance: Int?
    let avatar, email: String?
    let sex: Int?
//    let publishers: [JSONAny]?
    let vkNot: Bool?
    let yaoi, adult, chaptersRead: Int?
    let vkID: String?
//    let googleID, yandexID, mailID: JSONNull?
    let isTwoFactorAuth: Bool?
//    let tagline: JSONNull?
    let preference, countViews, countVotes, countComments: Int?
    let isNotifyBookmark, appExtendedCatalog: Bool?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case authType = "auth_type"
        case id, username, badges
        case isSuperuser = "is_superuser"
        case isStaff = "is_staff"
        case balance
        case ticketBalance = "ticket_balance"
        case avatar, email, sex
//        case publishers
        case vkNot = "vk_not"
        case yaoi, adult
        case chaptersRead = "chapters_read"
        case vkID = "vk_id"
//        case googleID = "google_id"
//        case yandexID = "yandex_id"
//        case mailID = "mail_id"
        case isTwoFactorAuth = "is_two_factor_auth"
//        case tagline
        case preference
        case countViews = "count_views"
        case countVotes = "count_votes"
        case countComments = "count_comments"
        case isNotifyBookmark = "is_notify_bookmark"
        case appExtendedCatalog = "app_extended_catalog"
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaAuthResultBadge
struct ReMangaAuthResultBadge: Codable, Hashable {
    let id: Int?
    let name: String?
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaAuthResultProps
struct ReMangaAuthResultProps: Codable, Hashable {
}
