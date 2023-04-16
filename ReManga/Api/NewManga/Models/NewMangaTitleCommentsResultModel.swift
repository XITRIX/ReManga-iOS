// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let newMangaTitleCommentsResultWelcome = try? JSONDecoder().decode(NewMangaTitleCommentsResultWelcome.self, from: jsonData)

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - NewMangaTitleComment
struct NewMangaTitleComment: Codable, Hashable {
    let id: Int
    let html: String?
//    let chapterID: JSONNull?
    let projectID: Int?
//    let teamID: JSONNull?
    let user: NewMangaTitleCommentsResultUser?
    let createdAt: String
    let children: [NewMangaTitleCommentsResultChild]?
    let likes, dislikes, rating: Int?
    let currentMark: Bool?
    let isPinned, canPin, canUnpin: Bool?

    enum CodingKeys: String, CodingKey {
        case id, html
//        case chapterID = "chapter_id"
        case projectID = "project_id"
//        case teamID = "team_id"
        case user
        case createdAt = "created_at"
        case children, likes, dislikes, rating
        case currentMark = "current_mark"
        case isPinned = "is_pinned"
        case canPin = "can_pin"
        case canUnpin = "can_unpin"
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaTitleCommentsResultChild
struct NewMangaTitleCommentsResultChild: Codable, Hashable {
    let id: Int
    let user: NewMangaTitleCommentsResultUser?
    let html: String?
    let likes, dislikes, parentID: Int?
    let createdAt: String
    let rating: Int?
//    let currentMark: JSONNull?
    let isPinned, canPin, canUnpin: Bool?
    let children: [NewMangaTitleCommentsResultChild]?

    enum CodingKeys: String, CodingKey {
        case id, user, html, likes, dislikes
        case parentID = "parent_id"
        case createdAt = "created_at"
        case rating
//        case currentMark = "current_mark"
        case isPinned = "is_pinned"
        case canPin = "can_pin"
        case canUnpin = "can_unpin"
        case children
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaTitleCommentsResultUser
struct NewMangaTitleCommentsResultUser: Codable, Hashable {
    let id: Int
    let name: String?
    let image: NewMangaTitleCommentsResultImage?
    let badges: [NewMangaTitleCommentsResultBadge]?
    let isAdmin, isActive, isOnline: Bool?
    let lastLogin: String?
    let isModerator, isTranslator: Bool?

    enum CodingKeys: String, CodingKey {
        case id, name, image, badges
        case isAdmin = "is_admin"
        case isActive = "is_active"
        case isOnline = "is_online"
        case lastLogin = "last_login"
        case isModerator = "is_moderator"
        case isTranslator = "is_translator"
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaTitleCommentsResultBadge
struct NewMangaTitleCommentsResultBadge: Codable, Hashable {
    let id: Int?
    let name: String?
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - NewMangaTitleCommentsResultImage
struct NewMangaTitleCommentsResultImage: Codable, Hashable {
    let id: Int?
    let name: String?
    let color: [String]?
    let width, height: Int?
    let origin: NewMangaTitleCommentsResultOrigin?
}

enum NewMangaTitleCommentsResultOrigin: String, Codable, Hashable {
    case appDisk1Main = "app_disk1_main"
}

typealias NewMangaTitleCommentsResult = [NewMangaTitleComment]
