// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let mangaDexWelcome = try? JSONDecoder().decode(MangaDexWelcome.self, from: jsonData)

import Foundation

// MARK: - MangaDexWelcome
struct MangaDexChaptersModel: Codable {
    let result, response: String
    let data: [MangaDexChapterData]
    let limit, offset, total: Int
}

// MARK: - MangaDexDatum
struct MangaDexChapterData: Codable {
    let id: String
    let type: MangaDexDatumType
    let attributes: MangaDexChapterDataAttributes
    let relationships: [MangaDexRelationship]
}

// MARK: - MangaDexDatumAttributes
struct MangaDexChapterDataAttributes: Codable {
    let volume: String?
    let chapter: String?
    let title: String?
    let translatedLanguage: String? //MangaDexEdLanguage
//    let externalURL: JSONNull?
    let publishAt, readableAt, createdAt, updatedAt: String?
    let pages, version: Int

    enum CodingKeys: String, CodingKey {
        case volume
         case chapter
         case title
        case translatedLanguage
//        case externalURL = "externalUrl"
        case publishAt, readableAt, createdAt, updatedAt, pages, version
    }
}

//enum MangaDexEdLanguage: String, Codable {
//    case en = "en"
//    case esLa = "es-la"
//    case ptBr = "pt-br"
//    case ru = "ru"
//}

// MARK: - MangaDexChapterRelationshipAttributes
struct MangaDexChapterRelationshipAttributes: Codable {
    let name: String?
//    let altNames: [JSONAny]?
    let locked: Bool?
    let website: String?
    let ircServer: MangaDexIRCServer?
    let ircChannel: MangaDexIRCChannel?
    let discord: MangaDexDiscord?
    let contactEmail: MangaDexContactEmail?
    let description: String?
//    let twitter: JSONNull?
    let mangaUpdates: String?
    let focusedLanguages: String? //[MangaDexEdLanguage]?
    let official, verified, inactive: Bool?
//    let publishDelay: JSONNull?
    let exLicensed: Bool?
    let createdAt, updatedAt: String?
    let version: Int
    let username: MangaDexUsername?
    let roles: [MangaDexRole]?
}

enum MangaDexContactEmail: String, Codable {
    case aeryOutlookCOMAr = "aery@outlook.com.ar"
    case newbiemangaYandexRu = "newbiemanga@yandex.ru"
}

enum MangaDexDiscord: String, Codable {
    case deKBJE9HH9 = "DeKbJE9hH9"
    case eT6Sejne88 = "eT6sejne88"
    case inviteXAX34S9EnB = "/invite/xAX34s9enB"
    case x4SdftW = "x4SdftW"
}

enum MangaDexIRCChannel: String, Codable {
    case randomscans = "#randomscans"
}

enum MangaDexIRCServer: String, Codable {
    case ircIrchighwayNet = "irc.irchighway.net"
}

//enum MangaDexName: String, Codable {
//    case hiveScans = "Hive Scans"
//    case inescrupulososScan = "Inescrupulosos Scan"
//    case luraToon = "Lura Toon"
//    case newbie = "Newbie"
//    case nightscans = "Nightscans "
//    case reverseScan = "ReverseScan"
//    case viniPrado = "ViniPrado"
//}

enum MangaDexRole: String, Codable {
    case roleBot = "ROLE_BOT"
    case roleGlobalModerator = "ROLE_GLOBAL_MODERATOR"
    case roleGroupLeader = "ROLE_GROUP_LEADER"
    case roleGroupMember = "ROLE_GROUP_MEMBER"
    case roleMember = "ROLE_MEMBER"
    case rolePowerUploader = "ROLE_POWER_UPLOADER"
    case roleStaff = "ROLE_STAFF"
    case roleUser = "ROLE_USER"
}

enum MangaDexUsername: String, Codable {
    case aliceShiro = "AliceShiro"
    case contributor = "Contributor"
    case crono0 = "Crono0"
    case lionsyz = "Lionsyz"
    case monate = "Monate"
    case viniPrado = "ViniPrado"
}

enum MangaDexDatumType: String, Codable {
    case chapter = "chapter"
}
