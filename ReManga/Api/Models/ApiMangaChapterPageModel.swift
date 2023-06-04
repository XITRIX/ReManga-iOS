//
//  ApiMangaChapterPageModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 15.04.2023.
//

import Foundation

struct ApiMangaChapterPageModel: Codable, Hashable {
    var size: CGSize
    var path: String
    var page: Int
}
