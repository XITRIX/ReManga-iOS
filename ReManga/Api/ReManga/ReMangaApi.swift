//
//  ReMangaApi.swift
//  ReManga
//
//  Created by Даниил Виноградов on 12.04.2023.
//

import Foundation

class ReMangaApi: ApiProtocol {
    func fetchCatalog(page: Int, filters: [ApiMangaTag] = []) async throws -> [ApiMangaModel] {
        let url = "https://api.remanga.org/api/search/catalog/?count=30&ordering=-rating&page=\(page)"
        let (result, _) = try await URLSession.shared.data(from: URL(string: url)!)
        let model = try JSONDecoder().decode(ReMangaApiMangaCatalogResult.self, from: result)

        return await MainActor.run { model.content.map { ApiMangaModel(from: $0) } }
    }

    func fetchSearch(query: String, page: Int) async throws -> [ApiMangaModel] {
        fatalError("fetchSearch(query:, page:) has not been implemented")
    }

    func fetchDetails(id: String) async throws -> ApiMangaModel {
        fatalError("fetchSearch(query:, page:) has not been implemented")
    }

    func fetchTitleChapters(branch: String) async throws -> [ApiMangaChapterModel] {
        fatalError("fetchTitleChapters(manga:) has not been implemented")
    }

    func fetchChapter(id: String) async throws -> [ApiMangaChapterPageModel] {
        fatalError("fetchChapter(id:) has not been implemented")
    }
}
