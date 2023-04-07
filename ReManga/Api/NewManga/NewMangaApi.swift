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

    func fetchCatalog(page: Int) async throws -> [ApiMangaModel] {
        try await fetchSearch(query: "", page: page)
    }

    func fetchSearch(query: String, page: Int) async throws -> [ApiMangaModel] {
        let url = URL(string: "https://neo.newmanga.org/catalogue")!

        var request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData
        )

        var body = NewMangaCatalogRequest()
        body.query = query
        body.pagination.page = page

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

    func fetchTitleChapters(branch: String, count: Int? = nil) async throws -> [ApiMangaChapterModel] {
        var _count = count
        if _count == nil {
            let url = "https://api.newmanga.org/v2/branches/\(branch)/chapters?reverse=true&page=1&size=1"
            let (result, _) = try await URLSession.shared.data(from: URL(string: url)!)
            let r_model = try JSONDecoder().decode(NewMangaTitleChapterResult.self, from: result)
            _count = r_model.count
        }

        guard let _count else { fatalError("Undefined behaviour") }

        let url = "https://api.newmanga.org/v2/branches/\(branch)/chapters?reverse=true&page=1&size=\(_count)"
        let (result, _) = try await URLSession.shared.data(from: URL(string: url)!)
        let model = try JSONDecoder().decode(NewMangaTitleChapterResult.self, from: result)

        return await MainActor.run { model.items.map { .init(from: $0) } }
    }
}
