//
//  ApiMangaCatalogResult.swift
//  ReManga
//
//  Created by Даниил Виноградов on 07.04.2023.
//

import Foundation

struct ReMangaPage<Item: Decodable>: Decodable {
    let results: [Item]
    let hasNextPage: Bool

    private enum CodingKeys: String, CodingKey {
        case results, next, meta
    }

    private struct Metadata: Decodable {
        let page: Int
        let totalPages: Int

        enum CodingKeys: String, CodingKey {
            case page
            case totalPages = "total_pages"
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        results = try container.decode([Item].self, forKey: .results)
        if container.contains(.next) {
            // v2 endpoints return either a URL or a page number in `next`.
            hasNextPage = try !container.decodeNil(forKey: .next)
        } else if let metadata = try container.decodeIfPresent(Metadata.self, forKey: .meta) {
            hasNextPage = metadata.page < metadata.totalPages
        } else {
            hasNextPage = false
        }
    }
}

struct ReMangaApiMangaModel: Codable, Hashable {
    let id: Int
    let img: ReMangaApiImg
    let enName: String
    let rusName: String
    let dir: String
    let bookmarkType: String?

    enum CodingKeys: String, CodingKey {
        case id, dir
        case img = "cover"
        case enName = "secondary_name"
        case rusName = "main_name"
        case bookmarkType = "bookmark_type"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        img = try container.decode(ReMangaApiImg.self, forKey: .img)
        enName = try container.decode(String.self, forKey: .enName)
        rusName = try container.decode(String.self, forKey: .rusName)
        dir = try container.decode(String.self, forKey: .dir)

        // Catalog responses use bookmark names; other title lists may use IDs.
        if let name = try? container.decode(String.self, forKey: .bookmarkType) {
            bookmarkType = name
        } else {
            bookmarkType = try container.decodeIfPresent(Int.self, forKey: .bookmarkType).map(String.init)
        }
    }
}

struct ReMangaApiImg: Codable, Hashable {
    let high, mid, low: String?
}
