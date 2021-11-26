// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let reUploadedChapterModel = try? newJSONDecoder().decode(ReUploadedChapterModel.self, from: jsonData)

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ReUploadedChapterModel
struct ReUploadedChapterModel: Codable, Hashable {
    let msg: String?
    let content: [ReUploadedChapterContent]
    let props: ReUploadedChapterProps?

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

// MARK: - ReUploadedChapterContent
struct ReUploadedChapterContent: Codable, Hashable {
    let id: Int?
    let enName: String?
    let rusName: String?
    let dir: String?
    let img: ReUploadedChapterImg?
    let uploadDate: Int?
    let chapterID: Int?
    let tome: Int?
    let chapter: String?
    let name: String?
    let countChapters: Int?
    let bookmarkType: String?
    let isHottest: Bool?
    let isLicensed: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case enName = "en_name"
        case rusName = "rus_name"
        case dir = "dir"
        case img = "img"
        case uploadDate = "upload_date"
        case chapterID = "chapter_id"
        case tome = "tome"
        case chapter = "chapter"
        case name = "name"
        case countChapters = "count_chapters"
        case bookmarkType = "bookmark_type"
        case isHottest = "is_hottest"
        case isLicensed = "is_licensed"
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReUploadedChapterImg
struct ReUploadedChapterImg: Codable, Hashable {
    let high: String?
    let mid: String?
    let low: String?

    enum CodingKeys: String, CodingKey {
        case high = "high"
        case mid = "mid"
        case low = "low"
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReUploadedChapterProps
struct ReUploadedChapterProps: Codable, Hashable {
    let totalItems: Int?
    let totalPages: Int?
    let page: Int?
    let bookmarkTypes: [ReUploadedChapterBookmarkType]?

    enum CodingKeys: String, CodingKey {
        case totalItems = "total_items"
        case totalPages = "total_pages"
        case page = "page"
        case bookmarkTypes = "bookmark_types"
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReUploadedChapterBookmarkType
struct ReUploadedChapterBookmarkType: Codable, Hashable {
    let id: Int?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}
