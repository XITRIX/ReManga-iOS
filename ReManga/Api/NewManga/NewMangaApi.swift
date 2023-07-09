//
//  NewMangaApi.swift
//  ReManga
//
//  Created by Даниил Виноградов on 12.04.2023.
//

import Foundation
import Kingfisher
import MvvmFoundation
import RxRelay
import RxSwift

class NewMangaApi: ApiProtocol {
    static let imgPath: String = "https://img.newmanga.org/ProjectCard/webp/"
    let disposeBag = DisposeBag()
    let decoder = JSONDecoder()
    var authToken = BehaviorRelay<String?>(value: nil)

    let profile = BehaviorRelay<ApiMangaUserModel?>(value: nil)

    var kfAuthModifier: AnyModifier {
        AnyModifier { [weak self] request in
            var r = request
            if let authToken = self?.authToken.value {
                r.addValue("user_session=\(authToken)", forHTTPHeaderField: "cookie")
            }
            return r
        }
    }

    var name: String {
        "NewManga"
    }

    var logo: Image {
        .local(name: "NewManga")
    }

    var key: ContainerKey.Backend {
        .newmanga
    }

    init() {
        authToken.accept(UserDefaults.standard.string(forKey: "NewAuthToken"))
        bind(in: disposeBag) {
            authToken.bind { [unowned self] token in
                UserDefaults.standard.set(token, forKey: "NewAuthToken")
                Task { await refreshUserInfo() }
            }
        }

        Task { await refreshUserInfo() }
    }

    func authRequestModifier(_ request: URLRequest) -> URLRequest {
        var request = request
        if let authToken = authToken.value {
            request.addValue("user_session=\(authToken)", forHTTPHeaderField: "cookie")
        }
        return request
    }

    var urlSession: URLSession {
        let session = URLSession.shared
        if let authToken = authToken.value,
           let cookie = HTTPCookie(properties: [.name: "user_session", .value: authToken, .domain: ".newmanga.org"])
        {
            session.configuration.httpCookieStorage?.setCookie(cookie)
        }
        return session
    }

    var defaultSortingType: ApiMangaIdModel {
        .init(id: "RATING", name: "По рейтингу")
    }

    func fetchSortingTypes() async throws -> [ApiMangaIdModel] {
        [.init(id: "MATCH", name: "По совпадению"),
         .init(id: "RATING", name: "По рейтингу"),
         .init(id: "VIEWS", name: "По просмотрам"),
         .init(id: "HEARTS", name: "По лайкам"),
         .init(id: "CREATED_AT", name: "По дате создания"),
         .init(id: "COUNT_CHAPTERS", name: "По кол-ву глав"),
         .init(id: "UPDATED_AT", name: "По дате обновления")]
    }

    func fetchCatalog(page: Int, filters: [ApiMangaTag] = [], sorting: ApiMangaIdModel) async throws -> [ApiMangaModel] {
        try await fetchSearch(query: "", page: page, filters: filters, sorting: sorting)
    }

    func fetchSearch(query: String, page: Int, sorting: ApiMangaIdModel) async throws -> [ApiMangaModel] {
        try await fetchSearch(query: query, page: page, filters: [], sorting: sorting)
    }

    func fetchSearch(query: String, page: Int, filters: [ApiMangaTag], sorting: ApiMangaIdModel) async throws -> [ApiMangaModel] {
        let url = "https://neo.newmanga.org/catalogue"

        var request = makeRequest(url)

        var body = NewMangaCatalogRequest()
        body.query = query
        body.pagination.page = page
        body.sort = .init(kind: sorting.id, dir: "DESC")

        for filter in filters {
            switch filter.kind {
            case .tag:
                body.filter.tags.included.append(filter.name)
            case .type:
                body.filter.type.allowed.append(filter.id)
            case .genre:
                body.filter.genres.included.append(filter.name)
            case .status:
                body.filter.translationStatus.allowed.append(filter.id)
            case .age:
                body.filter.adult.allowed.append(filter.id)
            }
        }

        if body.filter.adult.allowed.isEmpty {
            body.filter.adult.allowed = ["ADULT_13", "ADULT_16"]
        }

        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(body)

        let (result, _) = try await urlSession.data(for: request)
        let resModel = try decoder.decode(NewMangaCatalogResult.self, from: result)

        let mangas = resModel.result.hits?.compactMap { $0.document } ?? []

        return await MainActor.run { mangas.map { ApiMangaModel(from: $0) } }
    }

    func fetchDetails(id: String) async throws -> ApiMangaModel {
        let url = "https://api.newmanga.org/v2/projects/\(id)"
        let (result, _) = try await urlSession.data(for: makeRequest(url))
        let model = try JSONDecoder().decode(NewMangaDetailsResult.self, from: result)

        var res = await MainActor.run { ApiMangaModel(from: model) }

        do {
            let bookmarks = try await fetchBookmarkTypes()
            if let bookmark = model.bookmark?.type {
                res.bookmark = bookmarks.first(where: { $0.id == bookmark })
            }
        } catch {
            print(error)
        }

        return res
    }

    func fetchSimilarTitles(id: String) async throws -> [ApiMangaModel] {
        let url = "https://api.newmanga.org/v2/projects/\(id)/similar"
        let (result, _) = try await urlSession.data(for: makeRequest(url))
        let model = try JSONDecoder().decode(NewMangaApiSimilarResultModel.self, from: result)

        return await MainActor.run { model.map { .init(from: $0) } }
    }

    func fetchTitleChapters(branch: String, count: Int, page: Int) async throws -> [ApiMangaChapterModel] {
        let url = "https://api.newmanga.org/v3/branches/\(branch)/chapters/all"
        let (result, _) = try await urlSession.data(for: makeRequest(url))
        let model = try JSONDecoder().decode([NewMangaTitleChapterResultItem].self, from: result)

        return await MainActor.run { model.map { .init(from: $0) }.reversed() }
    }

    func fetchChapter(id: String) async throws -> [ApiMangaChapterPageModel] {
        let url = "https://api.newmanga.org/v3/chapters/\(id)/pages"
        let (result, _) = try await urlSession.data(for: makeRequest(url))
        let model = try JSONDecoder().decode(NewMangaChapterPagesResult.self, from: result)

        return await MainActor.run { model.getPages(chapter: id) }
    }

    func fetchComments(id: String, count: Int, page: Int) async throws -> [ApiMangaCommentModel] {
        let url = "https://api.newmanga.org/v2/projects/\(id)/comments?sort_by=new"
        let (result, _) = try await urlSession.data(for: makeRequest(url))
        let model = try JSONDecoder().decode(NewMangaTitleCommentsResult.self, from: result)

        return await MainActor.run { model.compactMap { .init(from: $0) } }
    }

    func fetchCommentsCount(id: String) async throws -> Int {
        throw ApiMangaError.operationNotSupported(message: "No need to fetch comments count on NewManga backend")
    }

    func fetchChapterComments(id: String, count: Int, page: Int) async throws -> [ApiMangaCommentModel] {
        let url = "https://api.newmanga.org/v2/chapters/\(id)/comments?sort_by=new"
        let (result, _) = try await urlSession.data(for: makeRequest(url))
        let model = try JSONDecoder().decode(NewMangaTitleCommentsResult.self, from: result)

        return await MainActor.run { model.compactMap { .init(from: $0) } }
    }

    func fetchChapterCommentsCount(id: String) async throws -> Int {
        try await fetchChapterComments(id: id, count: -1, page: -1).count
    }

    func fetchCommentsReplies(id: String, count: Int, page: Int) async throws -> [ApiMangaCommentModel] {
        throw ApiMangaError.operationNotSupported(message: "No need to fetch comments replies on NewManga backend")
    }

    func markChapterRead(id: String) async throws {
        let url = "https://api.newmanga.org/v2/chapters/\(id)/read"
        var request = makeRequest(url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        _ = try await urlSession.data(for: request)
    }

    func setChapterLike(id: String, _ value: Bool) async throws {
        guard authToken.value != nil
        else { throw ApiMangaError.unauthorized }

        let url = "https://api.newmanga.org/v2/chapters/\(id)/heart"

        var request = makeRequest(url)
        request.httpMethod = "POST"
        request.httpBody = "{ \"value\": \(value) }".data(using: .utf8)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        let (result, _) = try await urlSession.data(for: request)
        _ = try JSONDecoder().decode(NewMangaLikeResultModel.self, from: result)
    }

    func buyChapter(id: String) async throws -> Bool {
        let url = "https://api.newmanga.org/v2/chapters/\(id)/buy"
        var request = makeRequest(url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        _ = try await urlSession.data(for: request)
        return true
    }

    func markComment(id: String, _ value: Bool?, _ isLikeButton: Bool) async throws -> Int {
        guard authToken.value != nil
        else { throw ApiMangaError.unauthorized }
        
        let url = "https://api.newmanga.org/v2/comments/\(id)/mark"

        var request = makeRequest(url)
        request.httpMethod = "POST"
        request.httpBody = "{ \"value\": \(String(describing: value?.toString ?? "null")) }".data(using: .utf8)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        let (result, _) = try await urlSession.data(for: request)
        let model = try JSONDecoder().decode(NewMangaMarkCommentResultModel.self, from: result)

        return await MainActor.run { model.likes - model.dislikes }
    }

    func fetchUserInfo() async throws -> ApiMangaUserModel {
        let url = "https://api.newmanga.org/v2/user"
        let (result, response) = try await urlSession.data(for: makeRequest(url))
        if (response as? HTTPURLResponse)?.statusCode == 401 {
            authToken.accept(nil)
            throw ApiMangaError.unauthorized
        }

        let model = try JSONDecoder().decode(NewMangaUserResult.self, from: result)
        return .init(from: model)
    }

    func fetchBookmarkTypes() async throws -> [ApiMangaBookmarkModel] {
        let user = try await fetchUserInfo()

        let url = "https://api.newmanga.org/v2/users/\(user.id)/bookmarks/types"
        let (result, _) = try await urlSession.data(for: makeRequest(url))
        let model = try JSONDecoder().decode(NewMangaBookmarkTypesResult.self, from: result)

        let apiResults: [ApiMangaBookmarkModel] = model.compactMap { .init(id: $0.type, name: $0.type) }

        var defaultResults: [ApiMangaBookmarkModel] = ["Читаю", "Буду читать", "Прочитано", "Отложено", "Брошено", "Не интересно"].map { .init(id: $0, name: $0) }
        defaultResults.append(contentsOf: apiResults.filter { !defaultResults.contains($0) })

        return defaultResults
    }

    func setBookmark(title: String, bookmark: ApiMangaBookmarkModel?) async throws {
        let url = "https://api.newmanga.org/v2/projects/\(title)/bookmark"

        var request = makeRequest(url)
        if let bookmark {
            request.httpMethod = "POST"
            request.httpBody = "{ \"type\": \"\(bookmark.id)\" }".data(using: .utf8)
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        } else {
            request.httpMethod = "DELETE"
        }

        _ = try await urlSession.data(for: request)
    }

    func fetchBookmarks() async throws -> [ApiMangaModel] {
        let url = "https://api.newmanga.org/v2/user/bookmarks"
        let (result, _) = try await urlSession.data(for: makeRequest(url))
        let model = try JSONDecoder().decode(NewMangaBookmarksResult.self, from: result)

        return model.map { .init(from: $0) }
    }

    func fetchAllTags() async throws -> [ApiMangaTag] {
        var res: [ApiMangaTag] = []

        let urlGenres = "https://api.newmanga.org/v2/genres"
        let genres: NewMangaApiTagsResultModel = try await performRequest(makeRequest(urlGenres))
        res.append(contentsOf: genres.map { $0.toTag(with: .genre) })

        let urlTags = "https://api.newmanga.org/v2/tags"
        let tags: NewMangaApiTagsResultModel = try await performRequest(makeRequest(urlTags))
        res.append(contentsOf: tags.map { $0.toTag(with: .tag) })

        res.append(.init(id: "MANGA", name: "манга", kind: .type))
        res.append(.init(id: "MANHWA", name: "манхва", kind: .type))
        res.append(.init(id: "MANHYA", name: "маньхуа", kind: .type))
        res.append(.init(id: "SINGLE", name: "сингл", kind: .type))
        res.append(.init(id: "OEL", name: "OEL-манга", kind: .type))
        res.append(.init(id: "COMICS", name: "комикс", kind: .type))
        res.append(.init(id: "RUSSIAN", name: "руманга", kind: .type))

        res.append(.init(id: "ON_GOING", name: "выпускается", kind: .status))
        res.append(.init(id: "ABANDONED", name: "заброшен", kind: .status))
        res.append(.init(id: "COMPLETED", name: "завершён", kind: .status))

        res.append(.init(id: "ADULT_13", name: "13+", kind: .age))
        res.append(.init(id: "ADULT_16", name: "16+", kind: .age))
        res.append(.init(id: "ADULT_18", name: "18+", kind: .age))

        return res
    }
}
