//
//  ApiMangaModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 12.04.2023.
//

import Foundation

struct ApiMangaModel: Codable, Hashable {
    let title: String
    let rusTitle: String?
    let img: String
    let id: String

    var description: String? = nil
    var subtitle: String? = nil
    var rating: String? = nil
    var likes: String? = nil
    var sees: String? = nil
    var bookmarks: String? = nil
    var genres: [String] = []
    var tags: [String] = []
    var branches: [ApiMangaBranchModel] = []
}
