//
//  MangaDexApi.swift
//  ReManga
//
//  Created by Даниил Виноградов on 19.01.2025.
//

import Foundation
import Kingfisher
import MvvmFoundation
import RxRelay
import RxSwift

class MangaDexApi: ApiProtocol {
    static let imgPath: String = "https://mangadex.org/covers/"

    var urlSession: URLSession {
        let session = URLSession.shared
        return session
    }

    var authToken = BehaviorRelay<String?>(value: nil)

    var kfAuthModifier: AnyModifier {
        AnyModifier { [weak self] request in
            var r = request
            //            if let authToken = self?.authToken.value {
            //                r.addValue("user_session=\(authToken)", forHTTPHeaderField: "cookie")
            //            }
            return r
        }
    }

    var name: String { "MangaDex" }

    var logo: MvvmFoundation.Image{
        .local(name: "ReManga").with(tint: .label)
    }

    var key: ContainerKey.Backend { .mangadex }

    var profile = BehaviorRelay<ApiMangaUserModel?>(value: nil)

    var defaultSortingType: ApiMangaIdModel {
        .init(id: "rating", name: "По популярности")
    }

    func fetchSortingTypes() async throws -> [ApiMangaIdModel] {
        []
    }

    func fetchDetails(id: String) async throws -> ApiMangaModel {
        let url = "https://api.mangadex.org/manga/\(id)?includes[]=artist&includes[]=author&includes[]=cover_art"
        let stats = "https://api.mangadex.org/statistics/manga/\(id)"

        do {
            let model: MangaDexDetailsResult = try await performRequest(makeRequest(url))
            let statisticsModel: MangaDexStatisticsResult = try await performRequest(makeRequest(stats))

            guard let statistics = statisticsModel.statistics.values.first
            else { throw ApiMangaError.wrongUrl }

            return ApiMangaModel(from: model.data, statistics)
        } catch {
            throw error
        }

//        var res = ApiMangaModel(from: model.data)

//        do {
//            let bookmarks = try await fetchBookmarkTypes()
//            if let bookmark = model.bookmark?.type {
//                res.bookmark = bookmarks.first(where: { $0.id == bookmark })
//            }
//        } catch {
//            print(error)
//        }

//        return res
    }

    func fetchSimilarTitles(id: String) async throws -> [ApiMangaModel] {
        []
    }

    func fetchChapter(id: String) async throws -> [ApiMangaChapterPageModel] {
//        let url = "https://api.mangadex.org/manga/\(id)/feed?limit=96&includes[]=scanlation_group&includes[]=user&order[volume]=desc&order[chapter]=desc&offset=0&contentRating[]=safe&contentRating[]=suggestive&contentRating[]=erotica&contentRating[]=pornographic"
//        let model: MangaDexChaptersModel = try await performRequest(makeRequest(url))
//        return model.data.map { .init(from: $0) }
        return []
    }

    func fetchComments(id: String, count: Int, page: Int) async throws -> [ApiMangaCommentModel] {
        []
    }

    func fetchCommentsCount(id: String) async throws -> Int {
        0
    }

    func fetchChapterComments(id: String, count: Int, page: Int) async throws -> [ApiMangaCommentModel] {
        []
    }

    func fetchChapterCommentsCount(id: String) async throws -> Int {
        0
    }

    func fetchCommentsReplies(id: String, count: Int, page: Int) async throws -> [ApiMangaCommentModel] {
        []
    }

    func markChapterRead(id: String) async throws {

    }

    func setChapterLike(id: String, _ value: Bool) async throws {

    }

    func buyChapter(id: String) async throws -> Bool {
        throw ApiMangaError.notImplemented
    }

    func markComment(id: String, _ value: Bool?, _ isLikeButton: Bool) async throws -> Int {
        throw ApiMangaError.notImplemented
    }

    func fetchUserInfo() async throws -> ApiMangaUserModel {
        throw ApiMangaError.notImplemented
    }

    func fetchBookmarkTypes() async throws -> [ApiMangaBookmarkModel] {
        []
    }

    func setBookmark(title: String, bookmark: ApiMangaBookmarkModel?) async throws {
        throw ApiMangaError.notImplemented
    }

    func fetchBookmarks() async throws -> [ApiMangaModel] {
        throw ApiMangaError.notImplemented
    }

    func fetchAllTags() async throws -> [ApiMangaTag] {
        throw ApiMangaError.notImplemented
    }

    func authRequestModifier(_ request: URLRequest) -> URLRequest {
        var request = request
        //        if let authToken = authToken.value {
        //            request.addValue("bearer \(authToken)", forHTTPHeaderField: "Authorization")
        //        }
        return request
    }

    func showAuthScreen(from vm: MvvmFoundation.MvvmViewModel) {

    }

    func fetchTitleChapters(branch: String, count: Int, page: Int) async throws -> (models: [ApiMangaChapterModel], complete: Bool?) {
        let url = "https://api.mangadex.org/manga/\(branch)/feed?limit=\(500)&includes[]=scanlation_group&includes[]=user&order[volume]=desc&order[chapter]=desc&offset=\((page - 1) * 500)&contentRating[]=safe&contentRating[]=suggestive&contentRating[]=erotica&contentRating[]=pornographic"
        do {
            let model: MangaDexChaptersModel = try await performRequest(makeRequest(url))
            return (model.data.filter { $0.attributes.translatedLanguage == "ru" }.map { .init(from: $0) }, model.limit + model.offset >= model.total)
        } catch {
            throw error
        }
    }

    func fetchCatalog(page: Int, filters: [ApiMangaTag], sorting: ApiMangaIdModel) async throws -> [ApiMangaModel] {
        try await fetchSearch(query: "", page: page, filters: filters, sorting: sorting)
    }

    func fetchSearch(query: String, page: Int, sorting: ApiMangaIdModel) async throws -> [ApiMangaModel] {
        try await fetchSearch(query: query, page: page, filters: [], sorting: sorting)
    }

    private func fetchSearch(query: String, page: Int, filters: [ApiMangaTag], sorting: ApiMangaIdModel) async throws -> [ApiMangaModel] {
        let filterString = filters.map { "includedTags[]=" + $0.id }.joined(separator: "&")
        let url = "https://api.mangadex.org/manga?limit=\(30)&offset=\((page - 1) * 30)&includes[]=cover_art&contentRating[]=safe&contentRating[]=suggestive&contentRating[]=erotica&title=\(query)&order[rating]=desc&\(filterString)&includedTagsMode=AND&excludedTagsMode=OR"
        do {
            let model: MangaDexMangaCatalogResult = try await performRequest(makeRequest(url))
            return model.data.map { .init(from: $0) }
        } catch {
            throw error
        }
    }
}
