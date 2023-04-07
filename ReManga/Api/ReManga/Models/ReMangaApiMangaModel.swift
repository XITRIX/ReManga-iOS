//
//  ApiMangaModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 07.04.2023.
//

import Foundation

// MARK: - ApiMangaModel
struct ReMangaApiMangaModel: Codable, Hashable {
    let id: Int
    let img: ReMangaApiImg
    let enName: String
    let rusName: String
    let dir: String

    enum CodingKeys: String, CodingKey {
        case id, img
        case enName = "en_name"
        case rusName = "rus_name"
        case dir
    }
}

// MARK: - ApiImg
struct ReMangaApiImg: Codable, Hashable {
    let high, mid, low: String
}
