//
//  ReMangaApi+Widgets.swift
//  ReManga
//
//  Created by Даниил Виноградов on 04.07.2023.
//

import Foundation

extension ReMangaApi {
    func fetchPopulars() async throws -> [ApiMangaModel] {
        let url = "https://api.remanga.org/api/titles/?last_days=7&ordering=-votes&preference=0"
        let model: ReMangaApiMangaCatalogResult = try await performRequest(makeRequest(url))

        var bookmarks: [ApiMangaBookmarkModel] = []
        do { bookmarks = try await fetchBookmarkTypes() }
        catch { print(error) }

        let res = model.content.map { model in
            var item = ApiMangaModel(from: model)
            item.bookmark = bookmarks.first(where: { model.bookmarkType == $0.name })
            return item
        }

        return res
    }
}
