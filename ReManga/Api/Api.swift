//
//  Api.swift
//  ReManga
//
//  Created by Даниил Виноградов on 07.04.2023.
//

import Foundation

protocol ApiProtocol: AnyObject {
    func fetchCatalog(page: Int, filters: [ApiMangaTag]) async throws -> [ApiMangaModel]
    func fetchSearch(query: String, page: Int) async throws -> [ApiMangaModel]
    func fetchDetails(id: String) async throws -> ApiMangaModel
    func fetchTitleChapters(branch: String, count: Int) async throws -> [ApiMangaChapterModel]
    func fetchChapter(id: String) async throws -> [ApiMangaChapterPageModel]
    func fetchComments(id: String) async throws -> [ApiMangaCommentModel]
}

extension ApiProtocol {
    func fetchTitleChapters(branch: String, count: Int = 30) async throws -> [ApiMangaChapterModel] {
        try await fetchTitleChapters(branch: branch, count: count)
    }
    
    func fetchCatalog(page: Int, filters: [ApiMangaTag] = []) async throws -> [ApiMangaModel] {
        try await fetchCatalog(page: page, filters: filters)
    }
}
