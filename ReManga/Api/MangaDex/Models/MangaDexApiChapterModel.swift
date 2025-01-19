import Foundation

// MARK: - MangaDexWelcome
struct MangaDexChapterResult: Codable {
    let result: String
    let baseURL: String
    let chapter: MangaDexChapter

    enum CodingKeys: String, CodingKey {
        case result
        case baseURL = "baseUrl"
        case chapter
    }
}

// MARK: - MangaDexChapter
struct MangaDexChapter: Codable {
    let hash: String
    let data, dataSaver: [String]
}
