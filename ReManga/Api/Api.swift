//
//  Api.swift
//  ReManga
//
//  Created by Даниил Виноградов on 07.04.2023.
//

import MvvmFoundation
import Kingfisher
import RxRelay

protocol ApiAuthProtocol: AnyObject {
    func showAuthScreen(from vm: MvvmViewModel)
}

protocol ApiProtocol: AnyObject, ApiAuthProtocol {
    var authToken: BehaviorRelay<String?> { get set }
    var kfAuthModifier: AnyModifier { get }

    func fetchCatalog(page: Int, filters: [ApiMangaTag]) async throws -> [ApiMangaModel]
    func fetchSearch(query: String, page: Int) async throws -> [ApiMangaModel]
    func fetchDetails(id: String) async throws -> ApiMangaModel
    func fetchTitleChapters(branch: String, count: Int) async throws -> [ApiMangaChapterModel]
    func fetchChapter(id: String) async throws -> [ApiMangaChapterPageModel]
    func fetchComments(id: String) async throws -> [ApiMangaCommentModel]
    func markChapterRead(id: String) async throws
    func setChapterLike(id: String, _ value: Bool) async throws -> Int
    func buyChapter(id: String) async throws
    func markComment(id: String, _ value: Bool?) async throws -> Int
}

extension ApiProtocol {
    func fetchTitleChapters(branch: String, count: Int = 30) async throws -> [ApiMangaChapterModel] {
        try await fetchTitleChapters(branch: branch, count: count)
    }
    
    func fetchCatalog(page: Int, filters: [ApiMangaTag] = []) async throws -> [ApiMangaModel] {
        try await fetchCatalog(page: page, filters: filters)
    }
}
