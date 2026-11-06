import Foundation

struct ReMangaBookmarksResultContent: Codable, Hashable {
    let id, type: Int
    let title: ReMangaBookmarksResultTitle
    let viewState: Int

    enum CodingKeys: String, CodingKey {
        case id, type, title
        case viewState = "view_state"
    }
}

struct ReMangaBookmarksResultTitle: Codable, Hashable {
    let id: Int
    let dir: String
    let enName, rusName: String?
    let img: ReMangaApiImg

    enum CodingKeys: String, CodingKey {
        case id, dir
        case enName = "secondary_name"
        case rusName = "main_name"
        case img = "cover"
    }
}
