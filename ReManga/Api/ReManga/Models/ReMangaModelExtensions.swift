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
        self.id = model.id?.text ?? ""
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
        if let d = dateFormatter.date(from: model.uploadDate) {
            date = d
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            date = dateFormatter.date(from: model.uploadDate)!
        }
    }
}

extension ApiMangaChapterPageModel {
    init(from model: ReMangaChapterPagesResultPage) {
        size = CGSize(width: model.width, height: model.height)
        path = model.link
    }
}

extension ApiMangaCommentModel {
    init?(from model: ReMangaCommentsResultContent) {
        id = String(model.id)
        name = model.user.username
        likes = model.score ?? 0
        dislikes = 0
        children = []
        childrenCount = model.countReplies ?? 0
        isPinned = model.isPinned ?? false

        if model.rated == 0 {
            isLiked = true
        } else if model.rated == 1 {
            isLiked = true
        } else if model.rated == nil {
            isLiked = nil
        }

        guard let date = model.date
        else { return nil }
        
        self.date = Date(timeIntervalSince1970: TimeInterval(date))

        let imageRoot = "https://remanga.org"
        imagePath = imageRoot + (model.user.avatar?.low ?? "")

        guard let text = model.text
        else { return nil }

        self.text = .init(string: text)

        applyHierarchy(0)
    }

    private mutating func applyHierarchy(_ value: Int) {
        hierarchy = value
        for i in 0 ..< children.count {
            children[i].applyHierarchy(hierarchy + 1)
        }
    }
}

extension ApiMangaUserModel {
    init(from model: ReMangaUserResultContent) {
        id = model.id
        username = model.username

        if let avatar = model.avatar {
            image = ReMangaApi.imgPath + avatar
        }

        if let sbalance = model.balance,
           let balance = Double(sbalance)
        {
            currency = "\(balance) монет"
        }
    }
}

extension ApiMangaBookmarkModel {
    init(from model: ReMangaBookmarksResultContent) {
        id = model.id
        name = model.name
    }
}
