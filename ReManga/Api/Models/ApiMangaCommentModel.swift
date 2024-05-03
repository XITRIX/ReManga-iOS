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
    var childrenCount: Int
    var text: NSMutableAttributedString
    var name: String
    var date: Date
    var likes: Int = 0
    var dislikes: Int = 0
    var imagePath: String?
    var hierarchy: Int = 0
    var isPinned: Bool = false
    var isLiked: Bool?
}

extension ApiMangaCommentModel {
    var allChildrenCount: Int {
        var count = children.count
        children.forEach { count += $0.allChildrenCount }
        return count
    }
}
