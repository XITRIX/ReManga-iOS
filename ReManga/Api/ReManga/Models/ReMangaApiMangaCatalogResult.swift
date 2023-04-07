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
