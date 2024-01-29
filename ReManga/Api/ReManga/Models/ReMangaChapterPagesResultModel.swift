// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let reMangaChapterPagesResultWelcome = try? JSONDecoder().decode(ReMangaChapterPagesResultWelcome.self, from: jsonData)

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

// MARK: - ReMangaChapterPagesResult
struct ReMangaChapterPagesResult: Codable, Hashable {
    let msg: String?
    let content: ReMangaChapterPagesResultContent
    let props: ReMangaChapterPagesResultProps?
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaChapterPagesResultContent
struct ReMangaChapterPagesResultContent: Codable, Hashable {
    let id, tome: Int?
    let chapter, name: String?
    let score: Int?
    let rated: Bool?
    let uploadDate: String?
    let isPaid: Bool?
    let titleID: Int?
//    let volumeID: JSONNull?
    let branchID: Int?
//    let price, pubDate: JSONNull?
    let index: Int?
    let publishers: [ReMangaChapterPagesResultPublisher]?
//    let delayPubDate: JSONNull?
    let isPublished: Bool?
    let pages: [[ReMangaChapterPagesResultPage]]

    enum CodingKeys: String, CodingKey {
        case id, tome, chapter, name, score, rated
        case uploadDate = "upload_date"
        case isPaid = "is_paid"
        case titleID = "title_id"
//        case volumeID = "volume_id"
        case branchID = "branch_id"
//        case price
//        case pubDate = "pub_date"
        case index, publishers
//        case delayPubDate = "delay_pub_date"
        case isPublished = "is_published"
        case pages
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaChapterPagesResultPage
struct ReMangaChapterPagesResultPage: Codable, Hashable {
    let id: Int?
    let link: String
    let height, width: Int
    let countComments: Int?

    enum CodingKeys: String, CodingKey {
        case id, link, height, width
        case countComments = "count_comments"
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaChapterPagesResultPublisher
struct ReMangaChapterPagesResultPublisher: Codable, Hashable {
    let id: Int?
    let name, dir: String?
    let showDonate: Bool?
//    let donatePageText: JSONNull?
    let img: ReMangaChapterPagesResultImg?

    enum CodingKeys: String, CodingKey {
        case id, name, dir
        case showDonate = "show_donate"
//        case donatePageText = "donate_page_text"
        case img
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaChapterPagesResultImg
struct ReMangaChapterPagesResultImg: Codable, Hashable {
    let high, mid, low: String?
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaChapterPagesResultProps
struct ReMangaChapterPagesResultProps: Codable, Hashable {
}
