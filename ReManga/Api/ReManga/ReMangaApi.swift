//
//  ReMangaApi.swift
//  ReManga
//
//  Created by Даниил Виноградов on 12.04.2023.
//

import Foundation
import Kingfisher
import RxRelay

class ReMangaApi: ApiProtocol {
    static let imgPath: String = "https://remanga.org/"
    var authToken = BehaviorRelay<String?>(value: nil)

    var kfAuthModifier: Kingfisher.AnyModifier {
        AnyModifier { $0 }
    }
    
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

    func fetchTitleChapters(branch: String, count: Int) async throws -> [ApiMangaChapterModel] {
        let url = "https://api.remanga.org/api/titles/chapters/?branch_id=\(branch)&ordering=-index&user_data=1&count=\(count)&page=1"
        let (result, _) = try await URLSession.shared.data(from: URL(string: url)!)
        let model = try JSONDecoder().decode(ReMangaTitleChaptersResult.self, from: result)
        
        return model.content.map { .init(from: $0) }
//        fatalError("fetchTitleChapters(manga:) has not been implemented")
    }

    func fetchChapter(id: String) async throws -> [ApiMangaChapterPageModel] {
        let url = "https://api.remanga.org/api/titles/chapters/\(id)/"
        let (result, _) = try await URLSession.shared.data(from: URL(string: url)!)
        let model = try JSONDecoder().decode(ReMangaChapterPagesResult.self, from: result)
        
        return model.content.pages.flatMap { $0 }.map { .init(from: $0) }
    }

    func fetchComments(id: String) async throws -> [ApiMangaCommentModel] {
        return []
    }

    func markChapterRead(id: String) async throws { }

    func setChapterLike(id: String, _ value: Bool) async throws -> Int {
        0
    }

    func buyChapter(id: String) async throws {

    }
    
    func markComment(id: String, _ value: Bool?) async throws -> Int {
        0
    }
}
