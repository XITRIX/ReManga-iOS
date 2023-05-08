//
//  ApiMangaChapterModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 14.04.2023.
//

import Foundation

struct ApiMangaBranchModel: Codable, Hashable {
    var id: String
    var count: Int
    var translators: [ApiMangaTranslatorModel]
}

struct ApiMangaChapterModel: Codable, Hashable {
    var id: String
    var tome: String
    var chapter: String
    var date: Date
    var team: String?
    var isReaded: Bool
    var isLiked: Bool
    var likes: Int
    var isAvailable: Bool
    var price: String?
}
