import Foundation

// Login and social authentication still return the original content envelope.
struct ReMangaAuthResult: Decodable {
    let content: ReMangaAuthResultContent
}

struct ReMangaAuthResultContent: Decodable {
    let accessToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
