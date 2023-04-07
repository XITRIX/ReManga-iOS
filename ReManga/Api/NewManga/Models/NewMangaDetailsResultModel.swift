// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let newMangaDetailsResultWelcome = try? JSONDecoder().decode(NewMangaDetailsResultWelcome.self, from: jsonData)

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NewMangaDetailsResultWelcome
struct NewMangaDetailsResult: Codable, Hashable {
    let id: Int?
    let title: NewMangaDetailsResultTitle?
    let image: NewMangaDetailsResultImage?
    let type: NewMangaCatalogResultType?
    let rating: Double?
    let ratingCount, hearts: Int?
//    let currentRating: JSONNull?
    let hasHeart: Bool?
    let views, bookmarks: Int?
    let status: NewMangaCatalogResultStatus?
    let description: String?
    let bookmark: NewMangaDetailsResultBookmark?
    let genres, tags: [NewMangaDetailsResultGenre]?
    let author, artist: NewMangaDetailsResultArtist?
    let releaseDate: String?
//    let timer: JSONNull?
    let isClaimed: Bool?
    let adult: String?
    let tomes: [Int]?
    let lastChapterRead: Int?
    let originalStatus: String?
    let slug: String?
    let branches: [NewMangaDetailsResultBranch]?
//    let originalURL, englishURL, otherURL: JSONNull?

    enum CodingKeys: String, CodingKey {
        case id, title, image, type, rating
        case ratingCount = "rating_count"
        case hearts
//        case currentRating = "current_rating"
        case hasHeart = "has_heart"
        case views, bookmarks, status, description, bookmark, genres, tags, author, artist
        case releaseDate = "release_date"
//        case timer
        case isClaimed = "is_claimed"
        case adult, tomes
        case lastChapterRead = "last_chapter_read"
        case originalStatus = "original_status"
        case slug, branches
//        case originalURL = "original_url"
//        case englishURL = "english_url"
//        case otherURL = "other_url"
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaDetailsResultArtist
struct NewMangaDetailsResultArtist: Codable, Hashable {
    let id: Int?
    let name, description: String?
    let image: NewMangaDetailsResultImage?
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaDetailsResultImage
struct NewMangaDetailsResultImage: Codable, Hashable {
    let name: String?
//    let color: [JSONAny]?
    let height, width: Int?
    let origin: String?
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaDetailsResultBookmark
struct NewMangaDetailsResultBookmark: Codable, Hashable {
    let type: String?
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaDetailsResultBranch
struct NewMangaDetailsResultBranch: Codable, Hashable {
    let id: Int
    let translators: [NewMangaDetailsResultTranslator]?
    let chaptersTotal: Int
    let likesTotal: Int?
    let isDefault: Bool?
//    let subscription: JSONNull?

    enum CodingKeys: String, CodingKey {
        case id, translators
        case chaptersTotal = "chapters_total"
        case likesTotal = "likes_total"
        case isDefault = "is_default"
//        case subscription
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaDetailsResultTranslator
struct NewMangaDetailsResultTranslator: Codable, Hashable {
    let id: Int?
//    let balance: JSONNull?
    let isTeam: Bool?
    let user: NewMangaDetailsResultUser?
//    let team: JSONNull?

    enum CodingKeys: String, CodingKey {
        case id
//        case balance
        case isTeam = "is_team"
        case user
//         case team
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaDetailsResultUser
struct NewMangaDetailsResultUser: Codable, Hashable {
    let id: Int?
    let name: String?
    let isAdmin, isModerator, isTranslator, isActive: Bool?
    let lastLogin: String?
    let isOnline: Bool?
    let image: NewMangaDetailsResultImage?

    enum CodingKeys: String, CodingKey {
        case id, name
        case isAdmin = "is_admin"
        case isModerator = "is_moderator"
        case isTranslator = "is_translator"
        case isActive = "is_active"
        case lastLogin = "last_login"
        case isOnline = "is_online"
        case image
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaDetailsResultGenre
struct NewMangaDetailsResultGenre: Codable, Hashable {
    let id: Int?
    let title: NewMangaDetailsResultTitle?
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaDetailsResultTitle
struct NewMangaDetailsResultTitle: Codable, Hashable {
    let en, ru, original: String?
}
