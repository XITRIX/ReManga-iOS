//
//   MangaDownloadModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 07.05.2023.
//

import Foundation
import RxRelay

struct MangaChapterDownloadModel: Codable {
    var id: String
    var tome: String
    var chapter: String
    var title: String?
    var pages: [ApiMangaChapterPageModel]
}

struct MangaDownloadModel: Codable {
    var id: String
    var name = BehaviorRelay<String?>(value: nil)
    var image = BehaviorRelay<String?>(value: nil)
    var date = BehaviorRelay<Date>(value: .now)
    var chapters = BehaviorRelay<[MangaChapterDownloadModel]>(value: [])

    init(id: String, name: String? = nil, image: String? = nil, date: Date, chapters: [MangaChapterDownloadModel]) {
        self.id = id
        self.name.accept(name)
        self.image.accept(image)
        self.date.accept(date)
        self.chapters.accept(chapters)
    }
}
