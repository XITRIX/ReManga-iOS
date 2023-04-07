//
//  Api.swift
//  ReManga
//
//  Created by Даниил Виноградов on 07.04.2023.
//

import Foundation

protocol ApiProtocol: AnyObject {
    func fetchCatalog(page: Int) async throws -> [ApiMangaModel]
    func fetchSearch(query: String, page: Int) async throws -> [ApiMangaModel]
    func fetchDetails(id: String) async throws -> ApiMangaModel
    func fetchTitleChapters(branch: String, count: Int?) async throws -> [ApiMangaChapterModel]
}
