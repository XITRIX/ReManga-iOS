//
//  NewMangaApi.swift
//  ReManga
//
//  Created by Даниил Виноградов on 12.04.2023.
//

import Foundation

class NewMangaApi: ApiProtocol {
    let decoder = JSONDecoder()
    static let imgPath: String = "https://img.newmanga.org/ProjectCard/webp/"

    func fetchCatalog(page: Int, filters: [ApiMangaTag] = []) async throws -> [ApiMangaModel] {
        try await fetchSearch(query: "", page: page, filters: filters)
    }

    func fetchSearch(query: String, page: Int) async throws -> [ApiMangaModel] {
        try await fetchSearch(query: query, page: page, filters: [])
    }

    func fetchSearch(query: String, page: Int, filters: [ApiMangaTag]) async throws -> [ApiMangaModel] {
        let url = URL(string: "https://neo.newmanga.org/catalogue")!

        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData
        )

        var body = NewMangaCatalogRequest()
        body.query = query
        body.pagination.page = page

        for filter in filters {
            switch filter.kind {
            case .tag:
                body.filter.tags.included.append(filter.name)
            case .type:
                body.filter.type.allowed.append(filter.name)
            case .genre:
                body.filter.genres.included.append(filter.name)
            }
        }

        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(body)

        let (result, _) = try await URLSession.shared.data(for: request)
        let resModel = try decoder.decode(NewMangaCatalogResult.self, from: result)

        let mangas = resModel.result.hits?.compactMap { $0.document } ?? []

        return await MainActor.run { mangas.map { ApiMangaModel(from: $0) } }
    }

    func fetchDetails(id: String) async throws -> ApiMangaModel {
        let url = "https://api.newmanga.org/v2/projects/\(id)"
        let (result, _) = try await URLSession.shared.data(from: URL(string: url)!)
        let model = try JSONDecoder().decode(NewMangaDetailsResult.self, from: result)

        return await MainActor.run { ApiMangaModel(from: model) }
    }

    func fetchTitleChapters(branch: String) async throws -> [ApiMangaChapterModel] {
        let url = "https://api.newmanga.org/v3/branches/\(branch)/chapters/all"
        let (result, _) = try await URLSession.shared.data(from: URL(string: url)!)
        let model = try JSONDecoder().decode([NewMangaTitleChapterResultItem].self, from: result)

        return await MainActor.run { model.map { .init(from: $0) }.reversed() }
    }

    func fetchChapter(id: String) async throws -> [ApiMangaChapterPageModel] {
        let url = "https://api.newmanga.org/v3/chapters/\(id)/pages"
        let (result, _) = try await URLSession.shared.data(from: URL(string: url)!)
        let model = try JSONDecoder().decode(NewMangaChapterPagesResult.self, from: result)

        return await MainActor.run { model.getPages(chapter: id) }
    }
}
