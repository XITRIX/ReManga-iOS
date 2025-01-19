// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let mangaDexWelcome = try? JSONDecoder().decode(MangaDexWelcome.self, from: jsonData)

import Foundation

// MARK: - MangaDexWelcome
struct MangaDexStatisticsResult: Codable {
    let result: String
    let statistics: [String: MangaDexStatistics]
}

// MARK: - MangaDexStatistics
struct MangaDexStatistics: Codable {
    let comments: MangaDexComments
    let rating: MangaDexRating
    let follows: Int?
}

// MARK: - MangaDexComments
struct MangaDexComments: Codable {
    let threadID, repliesCount: Int

    enum CodingKeys: String, CodingKey {
        case threadID = "threadId"
        case repliesCount
    }
}

// MARK: - MangaDexRating
struct MangaDexRating: Codable {
    let average, bayesian: Double?
    let distribution: [String: Int]
}
