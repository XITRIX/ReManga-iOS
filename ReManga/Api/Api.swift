//
//  Api.swift
//  ReManga
//
//  Created by Даниил Виноградов on 07.04.2023.
//

import MvvmFoundation
import Kingfisher
import RxRelay

enum ApiAuthSource {
    case vk
    case google
    case yandex
}

protocol ApiAuthProtocol: AnyObject {
    @MainActor
    func showAuthScreen(from vm: MvvmViewModel)
}

protocol ApiProtocol: AnyObject, ApiAuthProtocol {
    var urlSession: URLSession { get }

    var authToken: BehaviorRelay<String?> { get set }
    var kfAuthModifier: AnyModifier { get }

    var name: String { get }
    var logo: Image { get }
    var key: ContainerKey.Backend { get }

    var profile: BehaviorRelay<ApiMangaUserModel?> { get }

    var defaultSortingType: ApiMangaIdModel { get }
    func fetchSortingTypes() async throws -> [ApiMangaIdModel]
    func fetchCatalog(page: Int, filters: [ApiMangaTag], sorting: ApiMangaIdModel) async throws -> [ApiMangaModel]
    func fetchSearch(query: String, page: Int, sorting: ApiMangaIdModel) async throws -> [ApiMangaModel]
    func fetchDetails(id: String) async throws -> ApiMangaModel
    func fetchSimilarTitles(id: String) async throws -> [ApiMangaModel]
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
    @discardableResult
    func markComment(id: String, _ value: Bool?, _ isLikeButton: Bool) async throws -> Int
    func fetchUserInfo() async throws -> ApiMangaUserModel
    func fetchBookmarkTypes() async throws -> [ApiMangaBookmarkModel]
    func setBookmark(title: String, bookmark: ApiMangaBookmarkModel?) async throws
    func fetchBookmarks() async throws -> [ApiMangaModel]
    func fetchAllTags() async throws -> [ApiMangaTag]
    func deauth()

    func authRequestModifier(_ request: URLRequest) -> URLRequest
}

extension ApiProtocol {
    func makeRequest(_ url: String) -> URLRequest {
        let request = URLRequest(url: URL(string: url)!)
        return authRequestModifier(request)
    }

    func fetchTitleChapters(branch: String, count: Int = 30, page: Int = 1) async throws -> [ApiMangaChapterModel] {
        try await fetchTitleChapters(branch: branch, count: count, page: page)
    }
    
    func fetchCatalog(page: Int, filters: [ApiMangaTag] = [], sorting: ApiMangaIdModel? = nil) async throws -> [ApiMangaModel] {
        try await fetchCatalog(page: page, filters: filters, sorting: sorting ?? defaultSortingType)
    }

    func fetchSearch(query: String, page: Int, sorting: ApiMangaIdModel? = nil) async throws -> [ApiMangaModel] {
        try await fetchSearch(query: query, page: page, sorting: sorting ?? defaultSortingType)
    }

    func deauth() {
        authToken.accept(nil)
        profile.accept(nil)
    }

    func refreshUserInfo() async {
        guard !authToken.value.isNilOrEmpty
        else { return }

        do {
            profile.accept(try await self.fetchUserInfo())
        } catch {
            profile.accept(nil)
        }
    }
}

extension ApiProtocol {
    func performRequest<T: Codable>(_ request: URLRequest) async throws -> T {
        let (result, response) = try await urlSession.data(for: request)

        if (response as? HTTPURLResponse)?.statusCode == 401 {
            deauth()
            throw ApiMangaError.unauthorized
        }

        return try JSONDecoder().decode(T.self, from: result)
    }

    func performRequest(_ request: URLRequest) async throws {
        let (_, response) = try await urlSession.data(for: request)

        if (response as? HTTPURLResponse)?.statusCode == 401 {
            deauth()
            throw ApiMangaError.unauthorized
        }
    }

}
