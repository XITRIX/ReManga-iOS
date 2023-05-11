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
    @MainActor
    func showAuthScreen(from vm: MvvmViewModel)
}

protocol ApiProtocol: AnyObject, ApiAuthProtocol {
    var authToken: BehaviorRelay<String?> { get set }
    var kfAuthModifier: AnyModifier { get }

    var name: String { get }

    var profile: BehaviorRelay<ApiMangaUserModel?> { get }

    func fetchCatalog(page: Int, filters: [ApiMangaTag]) async throws -> [ApiMangaModel]
    func fetchSearch(query: String, page: Int) async throws -> [ApiMangaModel]
    func fetchDetails(id: String) async throws -> ApiMangaModel
    func fetchTitleChapters(branch: String, count: Int, page: Int) async throws -> [ApiMangaChapterModel]
    func fetchChapter(id: String) async throws -> [ApiMangaChapterPageModel]
    func fetchComments(id: String, count: Int, page: Int) async throws -> [ApiMangaCommentModel]
    func fetchCommentsCount(id: String) async throws -> Int
    func fetchChapterComments(id: String, count: Int, page: Int) async throws -> [ApiMangaCommentModel]
    func fetchChapterCommentsCount(id: String) async throws -> Int
    func fetchCommentsReplies(id: String, count: Int, page: Int) async throws -> [ApiMangaCommentModel]
    func markChapterRead(id: String) async throws
    func setChapterLike(id: String, _ value: Bool) async throws
    func buyChapter(id: String) async throws -> Bool
    func markComment(id: String, _ value: Bool?) async throws -> Int
    func fetchUserInfo() async throws -> ApiMangaUserModel
    func fetchBookmarks() async throws -> [ApiMangaBookmarkModel]
    func setBookmark(title: String, bookmark: ApiMangaBookmarkModel?) async throws
    func deauth() async throws
}

extension ApiProtocol {
    func fetchTitleChapters(branch: String, count: Int = 30, page: Int = 1) async throws -> [ApiMangaChapterModel] {
        try await fetchTitleChapters(branch: branch, count: count, page: page)
    }
    
    func fetchCatalog(page: Int, filters: [ApiMangaTag] = []) async throws -> [ApiMangaModel] {
        try await fetchCatalog(page: page, filters: filters)
    }
}

extension ApiProtocol {
    func refreshUserInfo() async {
        do {
            profile.accept(try await self.fetchUserInfo())
        } catch {
            profile.accept(nil)
        }
    }
}
