//
//   MangaDownloadModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 07.05.2023.
//

import Foundation

struct MangaChapterDownloadModel: Codable {
    var id: String
    var tome: String
    var chapter: String
    var title: String?
    var pages: [ApiMangaChapterPageModel]
}

struct MangaDownloadModel: Codable {
    var name: String?
    var image: String?
    var chapters: [MangaChapterDownloadModel]
}
