//
//  ApiMangaModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 12.04.2023.
//

import Foundation

struct ApiMangaTag: Codable, Hashable {
    enum Kind: Codable {
        case tag, type, genre
    }

    var id: String
    var name: String
    var kind: Kind
}

struct ApiMangaModel: Hashable {
    let title: String
    let rusTitle: String?
    let img: String
    let id: String

    var description: NSMutableAttributedString? = nil
    var subtitle: String? = nil
    var rating: String? = nil
    var likes: String? = nil
    var sees: String? = nil
    var bookmarks: String? = nil
    var genres: [ApiMangaTag] = []
    var tags: [ApiMangaTag] = []
    var branches: [ApiMangaBranchModel] = []
    var translators: [ApiMangaTranslatorModel] = []
    var continueChapter: ApiMangaChapterModel?

    var bookmark: ApiMangaBookmarkModel?
}
