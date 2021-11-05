// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let reBranchWelcome = try? newJSONDecoder().decode(ReBranchWelcome.self, from: jsonData)

import Foundation

// MARK: - ReBranchWelcome
struct ReBranchModel: Codable {
    let msg: String?
    let content: [ReBranchContent]
    let props: ReBranchProps?

    enum CodingKeys: String, CodingKey {
        case msg = "msg"
        case content = "content"
        case props = "props"
    }
}

// MARK: - ReBranchContent
struct ReBranchContent: Codable {
    let id: Int
    let tome: Int?
    let chapter: String?
    let name: String?
    let score: Int?
    let rated: Bool?
    let viewed: Bool?
    let uploadDate: String?
    let isPaid: Bool?
    let isBought: Bool?
    let price: String?
    let pubDate: String?
    let publishers: [ReBranchPublisher]?
    let index: Int?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case tome = "tome"
        case chapter = "chapter"
        case name = "name"
        case score = "score"
        case rated = "rated"
        case viewed = "viewed"
        case uploadDate = "upload_date"
        case isPaid = "is_paid"
        case isBought = "is_bought"
        case price = "price"
        case pubDate = "pub_date"
        case publishers = "publishers"
        case index = "index"
    }
}

// MARK: - ReBranchPublisher
struct ReBranchPublisher: Codable {
    let name: String?

    enum CodingKeys: String, CodingKey {
        case name = "name"
    }
}

// MARK: - ReBranchProps
struct ReBranchProps: Codable {
    let totalItems: Int?
    let branchID: Int?

    enum CodingKeys: String, CodingKey {
        case totalItems = "total_items"
        case branchID = "branch_id"
    }
}
