//
//  MangaDexModelExtensions.swift
//  ReManga
//
//  Created by Даниил Виноградов on 19.01.2025.
//

import Foundation

extension ApiMangaModel {
    init(from model: MangaDexData, _ statistics: MangaDexStatistics? = nil) {
        id = model.id
        title = model.attributes.title.en ?? ""
        rusTitle = model.attributes.title.en ?? ""

        let imgPath = model.relationships.first(where: { $0.type == .coverArt })?.attributes?.fileName ?? ""
        img = MangaDexApi.imgPath + model.id + "/" + imgPath + ".256.jpg"

        guard let statistics else { return }

        description = model.attributes.description.en?.htmlToAttributedString()
//        subtitle = "\(model.attributes.altTitles.compactMap { $0. }.joined(separator: " / "))\n\([model.issueYear?.text, model.type?.name, model.status?.name].compactMap { $0 }.joined(separator: " ⸱ "))"
        subtitle = model.attributes.altTitles.first(where: { $0.en != nil })?.en
        rating = statistics.rating.average.map { String(format: "%.2f", $0) } ?? "--"
        likes = "--"
//        likes = model.totalVotes?.kmbFormatted ?? "--"
        bookmarks = statistics.follows?.kmbFormatted ?? "--"
        sees = "--"
//        sees = model.totalViews?.kmbFormatted ?? "--"

//        genres = model.genres?.compactMap { .init(id: String($0.id), name: $0.name ?? "", kind: .genre) } ?? []
//        tags = model.categories?.compactMap { .init(id: String($0.id), name: $0.name ?? "", kind: .tag) } ?? []
        genres = model.attributes.tags.filter { $0.attributes.group == .genre }.compactMap { .init(id: $0.id, name: $0.attributes.name.en, kind: .genre) } 
        tags = model.attributes.tags.filter { $0.attributes.group == .format || $0.attributes.group == .theme }.compactMap { .init(id: $0.id, name: $0.attributes.name.en, kind: .tag) }

        branches = [.init(id: model.id, count: 0, translators: [])]
        //
//        branches = model.branches?.compactMap { .init(from: $0) } ?? []
//
//        if let continueModel = model.continueReading {
//            continueChapter = .init(from: continueModel)
//        }
    }
}

extension ApiMangaChapterModel {
    init(from model: MangaDexChapterData) {
        id = model.id
        tome = model.attributes.volume ?? "1"
        chapter = model.attributes.chapter ?? "0"
        team = model.relationships.first(where: { $0.type == .scanlation_group })?.name

        isReaded = false// model.isViewed ?? false
        isLiked = false // model.hasHeart ?? false
        likes = 0 // model.hearts ?? 0

        isAvailable = true // model.isAvailable ?? true
        price = nil // model.isExpired ? nil : model.price?.text.appending(" ₽")

        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withFullTime, .withFractionalSeconds, .withColonSeparatorInTimeZone]
        date = model.attributes.createdAt.map { dateFormatter.date(from: $0) ?? .now } ?? Date()
    }
}

extension MangaDexChapterResult {
    func toModels() -> [ApiMangaChapterPageModel] {

        chapter.data.enumerated().map {
            let url = baseURL + "/data/" + chapter.hash + "/" + $0.element
            return .init(size: .init(width: 100, height: 100), path: url, page: $0.offset)
        }
    }
}
