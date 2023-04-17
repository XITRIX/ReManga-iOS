//
//  NewMangaLikeResultModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 17.04.2023.
//

import Foundation

struct NewMangaLikeResultModel: Codable {
    let setChapterHeart: Int

    enum CodingKeys: String, CodingKey {
        case setChapterHeart = "set_chapter_heart"
    }
}
