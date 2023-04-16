//
//  ApiMangaCommentModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 16.04.2023.
//

import Foundation

struct ApiMangaCommentModel: Hashable {
    var id: String
    var children: [ApiMangaCommentModel]
    var text: NSAttributedString
    var name: String
    var date: Date
    var score: Int = 0
    var imagePath: String
}
