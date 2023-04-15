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

        genres = model.genres?.compactMap { .init(id: String($0.id), name: $0.title.ru ?? "", kind: .genre)  } ?? []
        tags = model.tags?.compactMap { .init(id: String($0.id), name: $0.title.ru ?? "", kind: .tag) } ?? []

        branches = model.branches?.compactMap { .init(id: String($0.id), count: $0.chaptersTotal) } ?? []
    }
}

extension ApiMangaChapterModel {
    init(from model: NewMangaTitleChapterResultItem) {
        id = String(model.id ?? 0)
        tome = model.tom ?? 0
        chapter = String(format: "%g", model.number ?? 0)
        team = model.translator

        let dateFormatter = ISO8601DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss[.SSS]±hh:mm"
        dateFormatter.formatOptions = [.withFullDate, .withFullTime, .withFractionalSeconds, .withColonSeparatorInTimeZone]
        date = dateFormatter.date(from: model.createdAt)!
    }
}

//extension ApiMangaChapterPageModel {
//    init(from model: NewMangaChapterPagesResultSlice) {
//        size = CGSize(width: model.size.width, height: model.size.height)
//        path = model.path
//    }
//}

extension NewMangaChapterPagesResult {
    func getPages(chapter id: String) -> [ApiMangaChapterPageModel] {
        let rootPath = "https://storage.newmanga.org/origin_proxy/"
        let pages = pages.flatMap { $0.slices }.compactMap { $0 }
        return pages.map { ApiMangaChapterPageModel(size: CGSize(width: $0.size.width, height: $0.size.height), path: "\(rootPath)/\(origin)/\(id)/\($0.path)") }
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
