// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let reChapterArtist = try? newJSONDecoder().decode(ReChapterArtist.self, from: jsonData)
//   let reChapterAlbum = try? newJSONDecoder().decode(ReChapterAlbum.self, from: jsonData)
//   let reChapterTrack = try? newJSONDecoder().decode(ReChapterTrack.self, from: jsonData)

import Foundation

// MARK: - ReChapterModel
struct ReChapterModel: Codable {
    let msg: String?
    let content: ReChapterContent
    let props: ReChapterTrack?

    enum CodingKeys: String, CodingKey {
        case msg = "msg"
        case content = "content"
        case props = "props"
    }
}

// MARK: - ReChapterContent
struct ReChapterContent: Codable {
    let id: Int?
    let tome: Int?
    let chapter: String?
    let name: String?
    let score: Int?
    let rated: Bool?
    let viewID: Int?
    let uploadDate: String?
    let isPaid: Bool?
    let titleID: Int?
    let volumeID: JSONNull?
    let branchID: Int?
    let price: String?
    let pubDate: String?
    let publishers: [ReChapterPublisher]?
    let index: Int?
    let pages: [ReChapterPageUnion]

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case tome = "tome"
        case chapter = "chapter"
        case name = "name"
        case score = "score"
        case rated = "rated"
        case viewID = "view_id"
        case uploadDate = "upload_date"
        case isPaid = "is_paid"
        case titleID = "title_id"
        case volumeID = "volume_id"
        case branchID = "branch_id"
        case price = "price"
        case pubDate = "pub_date"
        case publishers = "publishers"
        case index = "index"
        case pages = "pages"
    }
}

struct ReChapterPageUnion: Codable {
    var parts: [ReChapterPage]

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([ReChapterPage].self) {
            parts = x
            return
        }
        if let x = try? container.decode(ReChapterPage.self) {
            parts = [x]
            return
        }
        throw DecodingError.typeMismatch(ReChapterPageUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ReChapterPageUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(parts)
    }
}

// MARK: - ReChapterPage
struct ReChapterPage: Codable {
    let id: Int?
    let link: String?
    let page: Int
    let height: Int
    let width: Int
    let countComments: Int?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case link = "link"
        case page = "page"
        case height = "height"
        case width = "width"
        case countComments = "count_comments"
    }
}

// MARK: - ReChapterPublisher
struct ReChapterPublisher: Codable {
    let id: Int?
    let name: String?
    let dir: String?
    let showDonate: Bool?
    let donatePageText: String?
    let img: ReChapterImg?
    let paidSubscription: ReChapterPaidSubscription?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case dir = "dir"
        case showDonate = "show_donate"
        case donatePageText = "donate_page_text"
        case img = "img"
        case paidSubscription = "paid_subscription"
    }
}

// MARK: - ReChapterImg
struct ReChapterImg: Codable {
    let high: String?
    let mid: String?
    let low: String?

    enum CodingKeys: String, CodingKey {
        case high = "high"
        case mid = "mid"
        case low = "low"
    }
}

// MARK: - ReChapterPaidSubscription
struct ReChapterPaidSubscription: Codable {
    let name: String?
    let paidSubscriptionDescription: String?
    let price: String?
    let publisher: Int?
    let user: JSONNull?
    let id: Int?
    let date: String?
    let period: Int?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case paidSubscriptionDescription = "description"
        case price = "price"
        case publisher = "publisher"
        case user = "user"
        case id = "id"
        case date = "date"
        case period = "period"
    }
}

// MARK: - ReChapterTrack
struct ReChapterTrack: Codable {
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func ==(lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
