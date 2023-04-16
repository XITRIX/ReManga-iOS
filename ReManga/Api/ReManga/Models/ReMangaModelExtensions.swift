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

private extension String {
//    func htmlToAttributedString() throws -> NSMutableAttributedString? {
//        let font = UIFont.systemFont(ofSize: 17)
//        let string = appending(String(format: "<style>body{font-family: '%@'; font-size:%fpx;}</style>", font.fontName, font.pointSize))
//
//        guard let data = string.data(using: .utf8)
//        else { return nil }
//
//        let text = try NSMutableAttributedString(
//            data: data,
//            options: [.documentType: NSAttributedString.DocumentType.html,
//                      .characterEncoding: String.Encoding.utf8.rawValue],
//            documentAttributes: nil)
//
//        let attrs: [NSAttributedString.Key: Any] = [
//            .foregroundColor: UIColor.label
//        ]
//
//        text.addAttributes(attrs, range: .init(location: 0, length: text.length))
//        return text
//    }

    func htmlToAttributedString(of size: Int = 17) -> NSMutableAttributedString? {
        let htmlTemplate = """
        <!doctype html>
        <html>
          <head>
            <style>
              body {
                font-family: -apple-system;
                font-size: \(size)px;
              }
            </style>
          </head>
          <body>
            \(self)
          </body>
        </html>
        """

        guard let data = htmlTemplate.data(using: .utf8) else {
            return nil
        }

        guard let attributedString = try? NSMutableAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html,
                      .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil
        ) else {
            return nil
        }

        let attrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.label
        ]

        attributedString.addAttributes(attrs, range: .init(location: 0, length: attributedString.length))

        return attributedString
    }
}
