//
//  ReMangaApi.swift
//  ReManga
//
//  Created by Даниил Виноградов on 12.04.2023.
//

import Kingfisher
import MvvmFoundation
import RxRelay
import RxSwift

class ReMangaApi: ApiProtocol {
    private let disposeBag = DisposeBag()
    static let imgPath: String = "https://remanga.org/"
    var authToken = BehaviorRelay<String?>(value: nil)

    let profile = BehaviorRelay<ApiMangaUserModel?>(value: nil)

    var kfAuthModifier: Kingfisher.AnyModifier {
        AnyModifier { [weak self] request in
            var r = request
            if let authToken = self?.authToken.value {
                r.addValue("bearer \(authToken)", forHTTPHeaderField: "Authorization")
            }
            r.addValue("https://remanga.org/", forHTTPHeaderField: "referer")
            return r
        }
    }

    func authRequestModifier(_ request: URLRequest) -> URLRequest {
        var request = request
        if let authToken = authToken.value {
            request.addValue("bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }
        return request
    }

    var urlSession: URLSession {
        let session = URLSession.shared
        return session
    }

    var name: String {
        "Re:Manga"
    }

    var logo: Image {
        .local(name: "ReManga").with(tint: .label)
    }

    var key: ContainerKey.Backend {
        .remanga
    }

    init() {
        authToken.accept(UserDefaults.standard.string(forKey: "ReAuthToken"))
        bind(in: disposeBag) {
            authToken.bind { [unowned self] token in
                UserDefaults.standard.set(token, forKey: "ReAuthToken")
                Task { await refreshUserInfo() }
            }
        }

        Task { await refreshUserInfo() }
    }

    var defaultSortingType: ApiMangaIdModel {
        .init(id: "rating", name: "По популярности")
    }

    func fetchSortingTypes() async throws -> [ApiMangaIdModel] {
        [.init(id: "id", name: "По новизне"),
         .init(id: "chapter_date", name: "По последним обновлениям"),
         .init(id: "rating", name: "По популярности"),
         .init(id: "votes", name: "По лайкам"),
         .init(id: "views", name: "По просмотрам"),
         .init(id: "count_chapters", name: "По кол-ву глав"),
         .init(id: "random", name: "Мне повезет")]
    }

    func fetchCatalog(page: Int, filters: [ApiMangaTag] = [], sorting: ApiMangaIdModel) async throws -> [ApiMangaModel] {
        var tags = ""
        for filter in filters {
            switch filter.kind {
            case .tag:
                tags.append("&categories=\(filter.id)")
            case .type:
                tags.append("&types=\(filter.id)")
            case .genre:
                tags.append("&genres=\(filter.id)")
            case .status:
                tags.append("&status=\(filter.id)")
            case .age:
                tags.append("&age_limit=\(filter.id)")
            }
        }

        let url = "https://api.remanga.org/api/search/catalog/?count=30&ordering=-\(sorting.id)&page=\(page)\(tags)"
        let model: ReMangaApiMangaCatalogResult = try await performRequest(makeRequest(url))

        var bookmarks: [ApiMangaBookmarkModel] = []
        do { bookmarks = try await fetchBookmarkTypes() }
        catch { print(error) }

        let res = model.content.map { model in
            var item = ApiMangaModel(from: model)
            item.bookmark = bookmarks.first(where: { model.bookmarkType == $0.name })
            return item
        }

        return res
    }

    func fetchSearch(query: String, page: Int, sorting: ApiMangaIdModel) async throws -> [ApiMangaModel] {
        let _query = query.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let url = "https://api.remanga.org/api/search/?query=\(_query)&count=30&field=titles&page=\(page)"
        let model: ReMangaApiMangaCatalogResult = try await performRequest(makeRequest(url))

        var bookmarks: [ApiMangaBookmarkModel] = []
        do { bookmarks = try await fetchBookmarkTypes() }
        catch { print(error) }

        let res = model.content.map { model in
            var item = ApiMangaModel(from: model)
            item.bookmark = bookmarks.first(where: { model.bookmarkType == $0.name })
            return item
        }

        return res
    }

    func fetchDetails(id: String) async throws -> ApiMangaModel {
        let url = "https://api.remanga.org/api/titles/\(id)/"
        let model: ReMangaApiDetailsResult = try await performRequest(makeRequest(url))

        var res = ApiMangaModel(from: model.content)

        do {
            let bookmarks = try await fetchBookmarkTypes()
            if let bookmark = model.content.bookmarkType {
                let bookmark = String(bookmark)
                res.bookmark = bookmarks.first(where: { $0.id == bookmark })
            }
        } catch {
            print(error)
        }

        return res
    }

    func fetchSimilarTitles(id: String) async throws -> [ApiMangaModel] {
        let url = "https://api.remanga.org/api/titles/\(id)/similar/?count=10"
        let model: ReMangaApiSimilarResultModel = try await performRequest(makeRequest(url))
        return model.content.map { ApiMangaModel(from: $0) }
    }

    func fetchTitleChapters(branch: String, count: Int, page: Int) async throws -> [ApiMangaChapterModel] {
        let url = "https://api.remanga.org/api/titles/chapters/?branch_id=\(branch)&ordering=-index&user_data=1&count=\(count)&page=\(page)"
        let model: ReMangaTitleChaptersResult = try await performRequest(makeRequest(url))
        return model.content.map { .init(from: $0) }
    }

    func fetchChapter(id: String) async throws -> [ApiMangaChapterPageModel] {
        let url = "https://api.remanga.org/api/titles/chapters/\(id)/"
        let model: ReMangaChapterPagesResult = try await performRequest(makeRequest(url))
        return model.content.pages.flatMap { $0 }.map { .init(from: $0) }
    }

    func fetchComments(id: String, count: Int, page: Int) async throws -> [ApiMangaCommentModel] {
        let url = "https://api.remanga.org/api/activity/comments/?title_id=\(id)&page=\(page)&ordering=-id&count=\(count)"
        let model: ReMangaCommentsResult = try await performRequest(makeRequest(url))
        return model.content.compactMap { .init(from: $0) }
    }

    func fetchCommentsCount(id: String) async throws -> Int {
        let url = "https://api.remanga.org/api/activity/comments/count/?title_id=\(id)"
        let model: ReMangaCommentsCountResult = try await performRequest(makeRequest(url))
        return model.content
    }

    func fetchChapterComments(id: String, count: Int, page: Int) async throws -> [ApiMangaCommentModel] {
        let url = "https://api.remanga.org/api/activity/comments/?chapter_id=\(id)&page=\(page)&ordering=-id&count=\(count)"
        let model: ReMangaCommentsResult = try await performRequest(makeRequest(url))
        return model.content.compactMap { .init(from: $0) }
    }

    func fetchChapterCommentsCount(id: String) async throws -> Int {
        let url = "https://api.remanga.org/api/activity/comments/count/?chapter_id=\(id)"
        let model: ReMangaCommentsCountResult = try await performRequest(makeRequest(url))
        return model.content
    }

    func fetchCommentsReplies(id: String, count: Int, page: Int) async throws -> [ApiMangaCommentModel] {
        let url = "https://api.remanga.org/api/activity/comments/?reply_to=\(id)&page=\(page)&ordering=-id&count=\(count)"
        let model: ReMangaCommentsResult = try await performRequest(makeRequest(url))
        return model.content.compactMap { .init(from: $0) }
    }

    func markChapterRead(id: String) async throws {
        let url = "https://api.remanga.org/api/activity/views/"

        var request = makeRequest(url)
        request.httpMethod = "POST"
        request.httpBody = "{ \"chapter\": \(id) }".data(using: .utf8)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        try await performRequest(request)
    }

    func setChapterLike(id: String, _ value: Bool) async throws {
        guard authToken.value != nil
        else { throw ApiMangaError.unauthorized }

        guard value else { throw ApiMangaError.operationNotSupported(message: "Remove like is not supported by ReManga") }
        let url = "https://api.remanga.org/api/activity/votes/"

        var request = makeRequest(url)
        request.httpMethod = "POST"
        request.httpBody = "{ \"type\": 0, \"chapter\": \(id) }".data(using: .utf8)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        try await performRequest(request)
    }

    func buyChapter(id: String) async throws -> Bool {
        let url = "https://api.remanga.org/api/billing/buy-chapter/"

        var request = makeRequest(url)
        request.httpMethod = "POST"
        request.httpBody = "{ \"chapter\": \(id) }".data(using: .utf8)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        let model: ReMangaChapterBuyResultModel = try await performRequest(request)
        return model.msg == "Ok"
    }

    func markComment(id: String, _ value: Bool?, _ isLikeButton: Bool) async throws -> Int {
        guard authToken.value != nil
        else { throw ApiMangaError.unauthorized }

        let url = "https://api.remanga.org/api/activity/votes/"

        let type: Int = isLikeButton ? 0 : 1

        var request = makeRequest(url)
        request.httpMethod = "POST"
        request.httpBody = "{ \"type\": \(type), \"comment\": \(id) }".data(using: .utf8)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        try await performRequest(request)

        // FIXME: - return valid data
        return 0
    }

    func fetchUserInfo() async throws -> ApiMangaUserModel {
        let url = "https://api.remanga.org/api/users/current/"
        let model: ReMangaUserResult = try await performRequest(makeRequest(url))
        return .init(from: model.content)
    }

    func fetchBookmarkTypes() async throws -> [ApiMangaBookmarkModel] {
        let user = try await fetchUserInfo()
        let url = "https://api.remanga.org/api/users/\(user.id)/user_bookmarks/"
        let model: ReMangaBookmarkTypesResult = try await performRequest(makeRequest(url))
        return model.content.compactMap { .init(from: $0) }
    }

    func setBookmark(title: String, bookmark: ApiMangaBookmarkModel?) async throws {
        let url = "https://api.remanga.org/api/users/bookmarks/"

        var request = makeRequest(url)
        if let bookmark {
            request.httpMethod = "POST"
            request.httpBody = "{ \"type\": \(bookmark.id), \"title\": \(title) }".data(using: .utf8)
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        } else {
            request.httpMethod = "DELETE"
            request.httpBody = "{ \"title\": \(title) }".data(using: .utf8)
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }

        try await performRequest(request)
    }

    func fetchBookmarks() async throws -> [ApiMangaModel] {
        let url = "https://api.remanga.org/api/users/11724/bookmarks/?ordering=-chapter_date&type=0&count=99999"
        let model: ReMangaBookmarksResult = try await performRequest(makeRequest(url))

        var bookmarks: [ApiMangaBookmarkModel] = []
        do { bookmarks = try await fetchBookmarkTypes() }
        catch { print(error) }

        let res = model.content.map { model in
            var item = ApiMangaModel(from: model)
            item.bookmark = bookmarks.first(where: { String(model.type) == $0.id })
            return item
        }

        return res
    }

    func fetchAllTags() async throws -> [ApiMangaTag] {
        let url = "https://api.remanga.org/api/forms/titles/?get=genres&get=categories&get=types&get=status&get=age_limit"
        let model: ReMangaApiTagsResultModel = try await performRequest(makeRequest(url))
        return model.tags
    }
}
