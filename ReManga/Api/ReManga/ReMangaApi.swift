//
//  ReMangaApi.swift
//  ReManga
//
//  Created by Даниил Виноградов on 12.04.2023.
//

import Foundation

class ReMangaApi: ApiProtocol {
    static let imgPath: String = "https://remanga.org/"
    
    func fetchCatalog(page: Int, filters: [ApiMangaTag] = []) async throws -> [ApiMangaModel] {
        var tags = ""
        for filter in filters {
            switch filter.kind {
            case .tag:
                tags.append("&categories=\(filter.id)")
            case .type:
                tags.append("&types=\(filter.id)")
            case .genre:
                tags.append("&genres=\(filter.id)")
            }
        }

        let url = "https://api.remanga.org/api/search/catalog/?count=30&ordering=-rating&page=\(page)\(tags)"
        let (result, _) = try await URLSession.shared.data(from: URL(string: url)!)
        let model = try JSONDecoder().decode(ReMangaApiMangaCatalogResult.self, from: result)

        return await MainActor.run { model.content.map { ApiMangaModel(from: $0) } }
    }

    func fetchSearch(query: String, page: Int) async throws -> [ApiMangaModel] {
        let _query = query.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let url = "https://api.remanga.org/api/search/?query=\(_query)&count=30&field=titles&page=\(page)"
        let (result, _) = try await URLSession.shared.data(from: URL(string: url)!)
        let model = try JSONDecoder().decode(ReMangaApiMangaCatalogResult.self, from: result)

        return await MainActor.run { model.content.map { ApiMangaModel(from: $0) } }
    }

    func fetchDetails(id: String) async throws -> ApiMangaModel {
        let url = "https://api.remanga.org/api/titles/\(id)"
        let (result, _) = try await URLSession.shared.data(from: URL(string: url)!)
        let model = try JSONDecoder().decode(ReMangaApiDetailsResult.self, from: result)

        return await MainActor.run { ApiMangaModel(from: model.content) }
    }

    func fetchTitleChapters(branch: String) async throws -> [ApiMangaChapterModel] {
        return []
//        fatalError("fetchTitleChapters(manga:) has not been implemented")
    }

    func fetchChapter(id: String) async throws -> [ApiMangaChapterPageModel] {
        return []
//        fatalError("fetchChapter(id:) has not been implemented")
    }

    func fetchComments(id: String) async throws -> [ApiMangaCommentModel] {
        return []
//        fatalError("fetchComments(id:) has not been implemented")
    }
}
