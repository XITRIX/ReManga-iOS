//
//  NewMangaModelExtensions.swift
//  ReManga
//
//  Created by Даниил Виноградов on 12.04.2023.
//

import Foundation

extension ApiMangaModel {
    init(from model: NewMangaCatalogResultDocument) {
        self.id = model.slug
        title = model.titleEn ?? ""
        rusTitle = model.titleRu
        img = NewMangaApi.imgPath + model.imageSmall
    }

    init(from model: NewMangaDetailsResult) {
        self.id = model.slug ?? ""
        title = model.title?.en ?? ""
        rusTitle = model.title?.ru ?? ""
        img = NewMangaApi.imgPath + (model.image?.name ?? "")

        description = model.description
        subtitle = "\([model.title?.en, model.title?.original].compactMap { $0 }.joined(separator: " / "))\n\([model.type?.name, model.status?.name].compactMap { $0 }.joined(separator: " ⸱ "))"
        rating = model.rating == nil ? nil : String(format: "%.2f", model.rating!)
        likes = model.hearts?.kmbFormatted ?? "--"
        bookmarks = model.bookmarks?.kmbFormatted ?? "--"
        sees = model.views?.kmbFormatted ?? "--"

        genres = model.genres?.compactMap { $0.title?.ru } ?? []
        tags = model.tags?.compactMap { $0.title?.ru } ?? []

        branches = model.branches?.compactMap { .init(id: String($0.id), count: $0.chaptersTotal) } ?? []
    }
}

extension ApiMangaChapterModel {
    init(from model: NewMangaTitleChapterResultItem) {
        tome = model.tom ?? 0
        chapter = String(format: "%g", model.number ?? 0)
        date = "11/11/2011"
    }
}

extension NewMangaCatalogResultType {
    var name: String {
        switch self {
        case .manga:
            return "манга"
        case .manhwa:
            return "манхва"
        case .manhya:
            return "маньхуа"
        case .single:
            return "сингл"
        case .oel:
            return "OEL-манга"
        case .comics:
            return "комикс"
        case .russian:
            return "руманга"
        }
    }
}

extension NewMangaCatalogResultStatus {
    var name: String {
        switch self {
        case .onGoing:
            return "выпускается"
        case .suspended:
            return "приостановлен"
        case .completed:
            return "завершён"
        case .announcement:
            return "анонс"
        case .abandoned:
            return "заброшен"
        }
    }
}
