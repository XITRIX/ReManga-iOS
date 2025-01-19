// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let mangaDexWelcome = try? JSONDecoder().decode(MangaDexWelcome.self, from: jsonData)

import Foundation

// MARK: - MangaDexWelcome
struct MangaDexDetailsResult: Codable {
    let result, response: String
    let data: MangaDexData
}

struct MangaDexMangaCatalogResult: Codable {
    let result, response: String
    let data: [MangaDexData]
    let limit, offset, total: Int
}

// MARK: - MangaDexData
struct MangaDexData: Codable {
    let id: String
//    let type: MangaDexRelationshipType
    let attributes: MangaDexDatumAttributes
    let relationships: [MangaDexRelationship]
}

// MARK: - MangaDexDatumAttributes
struct MangaDexDatumAttributes: Codable {
    let title: MangaDexTitle
    let altTitles: [MangaDexAltTitle]
    let description: MangaDexPurpleDescription
    let isLocked: Bool
    let links: MangaDexLinks?
    let originalLanguage: String // MangaDexOriginalLanguage
    let lastVolume, lastChapter: String?
//    let publicationDemographic: MangaDexPublicationDemographic?
    let status: MangaDexStatus
    let year: Int?
    let contentRating: MangaDexContentRating
    let tags: [MangaDexTag]
//    let state: MangaDexState
    let chapterNumbersResetOnNewVolume: Bool
//    let createdAt, updatedAt: Date
    let version: Int
    let availableTranslatedLanguages: [String?]
    let latestUploadedChapter: String?
}

// MARK: - MangaDexAltTitle
struct MangaDexAltTitle: Codable {
    let he, fa, ar, th: String?
    let ja, zhHk, zh, ko: String?
    let uk, ru, jaRo, ne: String?
    let de, fr, vi, esLa: String?
    let es, tr, en, ptBr: String?
    let pl, id, lt, ms: String?
    let el, ro, kk, koRo: String?
    let az, it, hi, bn: String?
    let ta, mn, my, te: String?
    let zhRo, tl, ka, da: String?
    let nl, bg: String?

    enum CodingKeys: String, CodingKey {
        case he, fa, ar, th, ja
        case zhHk = "zh-hk"
        case zh, ko, uk, ru
        case jaRo = "ja-ro"
        case ne, de, fr, vi
        case esLa = "es-la"
        case es, tr, en
        case ptBr = "pt-br"
        case pl, id, lt, ms, el, ro, kk
        case koRo = "ko-ro"
        case az, it, hi, bn, ta, mn, my, te
        case zhRo = "zh-ro"
        case tl, ka, da, nl, bg
    }
}

enum MangaDexContentRating: String, Codable {
    case erotica = "erotica"
    case safe = "safe"
    case suggestive = "suggestive"
}

// MARK: - MangaDexPurpleDescription
struct MangaDexPurpleDescription: Codable {
    let en: String?
    let es, ru, th, tr: String?
    let uk, esLa, ptBr, hu: String?
    let it, fr, ja, vi: String?
    let id, el, zhHk, ar: String?
    let az, tl, de, pl: String?
    let fa, pt: String?

    enum CodingKeys: String, CodingKey {
        case en, es, ru, th, tr, uk
        case esLa = "es-la"
        case ptBr = "pt-br"
        case hu, it, fr, ja, vi, id, el
        case zhHk = "zh-hk"
        case ar, az, tl, de, pl, fa, pt
    }
}

// MARK: - MangaDexLinks
struct MangaDexLinks: Codable {
    let al, ap, bw, kt: String?
    let mu: String?
    let amz: String?
    let cdj: String?
    let ebj: String?
    let mal: String?
    let raw: String?
    let engtl: String?
    let nu: String?
}

//enum MangaDexOriginalLanguage: String, Codable {
//    case ja = "ja"
//    case ko = "ko"
//    case en = "en"
//}

enum MangaDexPublicationDemographic: String, Codable {
    case josei = "josei"
    case seinen = "seinen"
    case shoujo = "shoujo"
    case shounen = "shounen"
}

//enum MangaDexState: String, Codable {
//    case published = "published"
//}

enum MangaDexStatus: String, Codable {
    case completed = "completed"
    case hiatus = "hiatus"
    case ongoing = "ongoing"
    case cancelled = "cancelled"
}

// MARK: - MangaDexTag
struct MangaDexTag: Codable {
    let id: String
    let type: MangaDexTagType
    let attributes: MangaDexTagAttributes
//    let relationships: [JSONAny]
}

// MARK: - MangaDexTagAttributes
struct MangaDexTagAttributes: Codable {
    let name: MangaDexName
    let description: MangaDexFluffyDescription
    let group: MangaDexGroup
    let version: Int
}

// MARK: - MangaDexFluffyDescription
struct MangaDexFluffyDescription: Codable {
}

enum MangaDexGroup: String, Codable {
    case content = "content"
    case format = "format"
    case genre = "genre"
    case theme = "theme"
}

// MARK: - MangaDexName
struct MangaDexName: Codable {
    let en: String
}

enum MangaDexTagType: String, Codable {
    case tag = "tag"
}

// MARK: - MangaDexTitle
struct MangaDexTitle: Codable {
    let en, jaRo: String?

    enum CodingKeys: String, CodingKey {
        case en
        case jaRo = "ja-ro"
    }
}

// MARK: - MangaDexRelationship
struct MangaDexRelationship: Codable {
    let id: String
    let type: MangaDexRelationshipType
    let attributes: MangaDexRelationshipAttributes?
    let name: String?
//    let related: MangaDexRelated?
}

// MARK: - MangaDexRelationshipAttributes
struct MangaDexRelationshipAttributes: Codable {
//    let description: MangaDexDescriptionEnum
//    let locale: String? // MangaDexOriginalLanguage
//    let createdAt, updatedAt: Date
    let description, volume, fileName, locale: String?
    let version: Int
}

//enum MangaDexDescriptionEnum: String, Codable {
//    case addCoverBestQualityWithBooklive = "Add cover best quality with booklive"
//    case empty = ""
//    case formatTankoubonImprintJumpComicsPublisherShueisha = "Format: Tankoubon\u{d}\nImprint: Jump Comics\u{d}\nPublisher: Shueisha"
//    case volume5CoverFromBookWalker = "Volume 5 Cover from BookWalker"
//    case volume6CoverFromBookWalker = "Volume 6 Cover from BookWalker"
//}

enum MangaDexRelated: String, Codable {
    case main_story = "main_story"
    case adaptedFrom = "adapted_from"
    case alternateStory = "alternate_story"
    case alternateVersion = "alternate_version"
    case colored = "colored"
    case doujinshi = "doujinshi"
    case monochrome = "monochrome"
    case prequel = "prequel"
    case preserialization = "preserialization"
    case sameFranchise = "same_franchise"
    case sequel = "sequel"
    case sharedUniverse = "shared_universe"
    case sideStory = "side_story"
    case spinOff = "spin_off"
}

enum MangaDexRelationshipType: String, Codable {
    case artist = "artist"
    case author = "author"
    case coverArt = "cover_art"
    case creator = "creator"
    case manga = "manga"
    case scanlation_group = "scanlation_group"
    case user = "user"
}
