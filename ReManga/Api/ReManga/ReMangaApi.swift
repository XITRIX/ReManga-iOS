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

    func makeRequest(_ url: String) -> URLRequest {
        var request = URLRequest(url: URL(string: url)!)
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
        let (result, _) = try await urlSession.data(for: makeRequest(url))
        let model = try JSONDecoder().decode(ReMangaApiMangaCatalogResult.self, from: result)

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

    func fetchSearch(query: String, page: Int) async throws -> [ApiMangaModel] {
        let _query = query.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let url = "https://api.remanga.org/api/search/?query=\(_query)&count=30&field=titles&page=\(page)"
        let (result, _) = try await urlSession.data(for: makeRequest(url))
        let model = try JSONDecoder().decode(ReMangaApiMangaCatalogResult.self, from: result)

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
        let req = makeRequest(url)
        let (result, _) = try await urlSession.data(for: req)
        let model = try JSONDecoder().decode(ReMangaApiDetailsResult.self, from: result)

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

    func fetchTitleChapters(branch: String, count: Int, page: Int) async throws -> [ApiMangaChapterModel] {
        let url = "https://api.remanga.org/api/titles/chapters/?branch_id=\(branch)&ordering=-index&user_data=1&count=\(count)&page=\(page)"
        let (result, _) = try await urlSession.data(for: makeRequest(url))
        let model = try JSONDecoder().decode(ReMangaTitleChaptersResult.self, from: result)

        return model.content.map { .init(from: $0) }
    }

    func fetchChapter(id: String) async throws -> [ApiMangaChapterPageModel] {
        let url = "https://api.remanga.org/api/titles/chapters/\(id)/"
        let (result, _) = try await urlSession.data(for: makeRequest(url))
        let model = try JSONDecoder().decode(ReMangaChapterPagesResult.self, from: result)

        return model.content.pages.flatMap { $0 }.map { .init(from: $0) }
    }

    func fetchComments(id: String, count: Int, page: Int) async throws -> [ApiMangaCommentModel] {
        let url = "https://api.remanga.org/api/activity/comments/?title_id=\(id)&page=\(page)&ordering=-id&count=\(count)"
        let (result, _) = try await urlSession.data(for: makeRequest(url))
        let model = try JSONDecoder().decode(ReMangaCommentsResult.self, from: result)

        return model.content.compactMap { .init(from: $0) }
    }

    func fetchCommentsCount(id: String) async throws -> Int {
        let url = "https://api.remanga.org/api/activity/comments/count/?title_id=\(id)"
        let (result, _) = try await urlSession.data(for: makeRequest(url))
        let model = try JSONDecoder().decode(ReMangaCommentsCountResult.self, from: result)

        return model.content
    }

    func fetchChapterComments(id: String, count: Int, page: Int) async throws -> [ApiMangaCommentModel] {
        let url = "https://api.remanga.org/api/activity/comments/?chapter_id=\(id)&page=\(page)&ordering=-id&count=\(count)"
        let (result, _) = try await urlSession.data(for: makeRequest(url))
        let model = try JSONDecoder().decode(ReMangaCommentsResult.self, from: result)

        return model.content.compactMap { .init(from: $0) }
    }

    func fetchChapterCommentsCount(id: String) async throws -> Int {
        let url = "https://api.remanga.org/api/activity/comments/count/?chapter_id=\(id)"
        let (result, _) = try await urlSession.data(for: makeRequest(url))
        let model = try JSONDecoder().decode(ReMangaCommentsCountResult.self, from: result)

        return model.content
    }

    func fetchCommentsReplies(id: String, count: Int, page: Int) async throws -> [ApiMangaCommentModel] {
        let url = "https://api.remanga.org/api/activity/comments/?reply_to=\(id)&page=\(page)&ordering=-id&count=\(count)"
        let (result, _) = try await urlSession.data(for: makeRequest(url))
        let model = try JSONDecoder().decode(ReMangaCommentsResult.self, from: result)

        return model.content.compactMap { .init(from: $0) }
    }

    func markChapterRead(id: String) async throws {
        let url = "https://api.remanga.org/api/activity/views/"

        var request = makeRequest(url)
        request.httpMethod = "POST"
        request.httpBody = "{ \"chapter\": \(id) }".data(using: .utf8)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        _ = try await urlSession.data(for: request)
    }

    func setChapterLike(id: String, _ value: Bool) async throws {
        guard value else { throw ApiMangaError.operationNotSupported(message: "Remove like is not supported by ReManga") }
        let url = "https://api.remanga.org/api/activity/votes/"

        var request = makeRequest(url)
        request.httpMethod = "POST"
        request.httpBody = "{ \"type\": 0, \"chapter\": \(id) }".data(using: .utf8)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        _ = try await urlSession.data(for: request)
    }

    func buyChapter(id: String) async throws -> Bool {
        let url = "https://api.remanga.org/api/billing/buy-chapter/"

        var request = makeRequest(url)
        request.httpMethod = "POST"
        request.httpBody = "{ \"chapter\": \(id) }".data(using: .utf8)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        let (result, _) = try await urlSession.data(for: request)
        let model = try JSONDecoder().decode(ReMangaChapterBuyResultModel.self, from: result)

        return model.msg == "Ok"
    }

    func markComment(id: String, _ value: Bool?) async throws -> Int {
        let url = "https://api.remanga.org/api/activity/votes/"

        var request = makeRequest(url)
        request.httpMethod = "POST"
        request.httpBody = "{ \"type\": 0, \"comment\": \(id) }".data(using: .utf8)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        _ = try await urlSession.data(for: request)

        // FIXME: - return valid data
        return 0
    }

    func fetchUserInfo() async throws -> ApiMangaUserModel {
        let url = "https://api.remanga.org/api/users/current/"
        let (result, response) = try await urlSession.data(for: makeRequest(url))
        if (response as? HTTPURLResponse)?.statusCode == 401 {
            authToken.accept(nil)
            throw ApiMangaError.unauthorized
        }
        let model = try JSONDecoder().decode(ReMangaUserResult.self, from: result)

        return .init(from: model.content)
    }

    func fetchBookmarkTypes() async throws -> [ApiMangaBookmarkModel] {
        let user = try await fetchUserInfo()

        let url = "https://api.remanga.org/api/users/\(user.id)/user_bookmarks/"
        let (result, _) = try await urlSession.data(for: makeRequest(url))
        let model = try JSONDecoder().decode(ReMangaBookmarkTypesResult.self, from: result)

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

        _ = try await urlSession.data(for: request)
    }

    func fetchBookmarks() async throws -> [ApiMangaModel] {
        let url = "https://api.remanga.org/api/users/11724/bookmarks/?ordering=-chapter_date&type=0&count=99999"

        let (result, _) = try await urlSession.data(for: makeRequest(url))
        let model = try JSONDecoder().decode(ReMangaBookmarksResult.self, from: result)

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

    func deauth() async throws {
        authToken.accept(nil)
        profile.accept(nil)
    }
}
