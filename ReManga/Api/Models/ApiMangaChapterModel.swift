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
}

struct ApiMangaChapterModel: Codable, Hashable {
    var id: String
    var tome: Int
    var chapter: String
    var date: Date
    var team: String?
}
