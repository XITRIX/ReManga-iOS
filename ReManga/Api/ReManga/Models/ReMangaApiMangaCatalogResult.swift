//
//  ApiMangaCatalogResult.swift
//  ReManga
//
//  Created by Даниил Виноградов on 07.04.2023.
//

import Foundation

// MARK: - ApiMangaCatalog
struct ReMangaApiMangaCatalogResult: Codable {
    let msg: String
    let content: [ReMangaApiMangaModel]
    let props: ReMangaApiMangaCatalogProps
}

// MARK: - ApiMangaCatalogProps
struct ReMangaApiMangaCatalogProps: Codable {
    let totalItems, totalPages, page: Int

    enum CodingKeys: String, CodingKey {
        case totalItems = "total_items"
        case totalPages = "total_pages"
        case page
    }
}

// MARK: - ApiMangaModel
struct ReMangaApiMangaModel: Codable, Hashable {
    let id: Int
    let img: ReMangaApiImg
    let enName: String
    let rusName: String
    let dir: String
    let bookmarkType: String?

    enum CodingKeys: String, CodingKey {
        case id, img
        case enName = "en_name"
        case rusName = "rus_name"
        case bookmarkType = "bookmark_type"
        case dir
    }
}

// MARK: - ApiImg
struct ReMangaApiImg: Codable, Hashable {
    let high, mid, low: String
}

