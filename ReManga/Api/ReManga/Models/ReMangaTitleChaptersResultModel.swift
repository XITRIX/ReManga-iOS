// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let reMangaTitleChaptersResultWelcome = try? JSONDecoder().decode(ReMangaTitleChaptersResultWelcome.self, from: jsonData)

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

import Foundation

enum ReMangaDateParser {
    static func date(from string: String) -> Date? {
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = iso.date(from: string) { return date }
        iso.formatOptions = [.withInternetDateTime]
        if let date = iso.date(from: string) { return date }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        for format in ["yyyy-MM-dd'T'HH:mm:ss.SSSSSS", "yyyy-MM-dd'T'HH:mm:ss"] {
            formatter.dateFormat = format
            if let date = formatter.date(from: string) { return date }
        }
        return nil
    }
}

// MARK: - ReMangaTitleChaptersResult
struct ReMangaTitleChaptersResult: Codable, Hashable {
    let msg: String?
    let content: [ReMangaTitleChaptersResultContent]
    let props: ReMangaTitleChaptersResultProps?
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaTitleChaptersResultContent
struct ReMangaTitleChaptersResultContent: Codable, Hashable {
    let id: Int?
    let rated, viewed: Bool?
    let isBought: Bool?
    let publishers: [ReMangaTitleChaptersResultPublisher]?
    let index, tome: Int?
    let chapter: String?
    let name: String?
    let price: String?
    let score: Int?
    let uploadDate: String
    let pubDate: String?
    let isPaid: Bool?

    enum CodingKeys: String, CodingKey {
        case id, rated, viewed
        case isBought = "is_bought"
        case publishers, index, tome, chapter, name, price, score
        case uploadDate = "upload_date"
        case pubDate = "pub_date"
        case isPaid = "is_paid"
    }
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaTitleChaptersResultPublisher
struct ReMangaTitleChaptersResultPublisher: Codable, Hashable {
    let name: String?
    let dir: String?
}

//
// Hashable or Equatable:
// The compiler will not be able to synthesize the implementation of Hashable or Equatable
// for types that require the use of JSONAny, nor will the implementation of Hashable be
// synthesized for types that have collections (such as arrays or dictionaries).

// MARK: - ReMangaTitleChaptersResultProps
struct ReMangaTitleChaptersResultProps: Codable, Hashable {
    let page, branchID: Int?

    enum CodingKeys: String, CodingKey {
        case page
        case branchID = "branch_id"
    }
}
