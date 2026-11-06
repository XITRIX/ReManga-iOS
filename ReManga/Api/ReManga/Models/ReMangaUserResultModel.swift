import Foundation

struct ReMangaUserResultContent: Codable, Hashable {
    let id: Int
    let username: String
    let balance: String?
    let avatar: ReMangaApiImg?
}
