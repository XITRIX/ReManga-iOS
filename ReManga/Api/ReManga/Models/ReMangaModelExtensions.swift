//
//  ReMangaModelExtensions.swift
//  ReManga
//
//  Created by Даниил Виноградов on 12.04.2023.
//

import Foundation
import UIKit

extension ApiMangaModel {
    init(from model: ReMangaApiMangaModel) {
        id = model.dir
        title = model.enName
        rusTitle = model.rusName
        img = ReMangaApi.imgPath + model.img.mid
    }

    init(from model: ReMangaApiDetailsResultContent) {
        self.id = model.dir ?? ""
        title = model.enName ?? ""
        rusTitle = model.rusName ?? ""
        img = ReMangaApi.imgPath + (model.img?.high ?? "")

        description = model.description?.htmlToAttributedString()
        subtitle = "\([model.enName, model.anotherName].compactMap { $0 }.joined(separator: " / "))\n\([model.issueYear?.text, model.type?.name, model.status?.name].compactMap { $0 }.joined(separator: " ⸱ "))"
        rating = model.avgRating
        likes = model.totalVotes?.kmbFormatted ?? "--"
        bookmarks = model.countBookmarks?.kmbFormatted ?? "--"
        sees = model.totalViews?.kmbFormatted ?? "--"

        genres = model.genres?.compactMap { .init(id: String($0.id), name: $0.name ?? "", kind: .genre) } ?? []
        tags = model.categories?.compactMap { .init(id: String($0.id), name: $0.name ?? "", kind: .tag) } ?? []

        branches = model.branches?.compactMap { .init(from: $0) } ?? []
    }
}

extension ApiMangaBranchModel {
    init(from model: ReMangaApiDetailsResultBranch) {
        id = String(model.id ?? 0)
        count = model.countChapters ?? 0
        translators = model.publishers?.map { .init(from: $0) } ?? [] //: [ApiMangaTranslatorModel]
    }
}

extension ApiMangaTranslatorModel {
    init(from model: ReMangaApiDetailsResultPublisher) {
        imagePath = ReMangaApi.imgPath + (model.img ?? "")
        title = model.name ?? ""
        type = model.type ?? ""
    }
}

extension ApiMangaChapterModel {
    init(from model: ReMangaTitleChaptersResultContent) {
        id = String(model.id ?? 0)
        tome = model.tome ?? 0
        chapter = model.chapter ?? ""
        team = model.publishers?.first?.name ?? ""

        isReaded = model.viewed ?? false
        isLiked = model.rated ?? false
        likes = model.score ?? 0

        isAvailable = !(model.isPaid ?? false)
        price = model.isPaid == false ? nil : model.price

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        date = dateFormatter.date(from: model.uploadDate)!
    }
}

extension ApiMangaChapterPageModel {
    init(from model: ReMangaChapterPagesResultPage) {
        size = CGSize(width: model.width, height: model.height)
        path = model.link
    }
}
