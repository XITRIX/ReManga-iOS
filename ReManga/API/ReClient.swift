//
//  ReClient.swift
//  REManga
//
//  Created by Daniil Vinogradov on 21.02.2021.
//

import Alamofire
import Foundation

class ReClient {
    static let baseUrl = "https://api.remanga.org/"

    static let shared = ReClient()

    private(set) var token = "RbusBKDSEPoqFJNj4S7cViyphSvczf"

    @discardableResult
    func getTitle(title: String, completionHandler: @escaping (Result<ReTitleModel, HttpClientError>) -> ()) -> DataRequest? {
        let api = "api/titles/\(title)/"
        return baseRequest(api, completionHandler: completionHandler)
    }

    @discardableResult
    func getBranch(branch: Int, completionHandler: @escaping (Result<ReBranchModel, HttpClientError>) -> ()) -> DataRequest? {
        let api = "api/titles/chapters/?branch_id=\(String(branch))"
        return baseRequest(api, completionHandler: completionHandler)
    }

    @discardableResult
    func getSimilar(title: String, completionHandler: @escaping (Result<ReSimilarModel, HttpClientError>) -> ()) -> DataRequest? {
        let api = "api/titles/\(title)/similar"
        return baseRequest(api, completionHandler: completionHandler)
    }

    @discardableResult
    func getChapter(chapter: Int, completionHandler: @escaping (Result<ReChapterModel, HttpClientError>) -> ()) -> DataRequest? {
        let api = "api/titles/chapters/\(chapter)/"
        return baseRequest(api, completionHandler: completionHandler)
    }

    @discardableResult
    func getCatalog(page: Int, count: Int = 30, filter: CatalogFiltersModel, completionHandler: @escaping (Result<ReCatalogModel, HttpClientError>) -> ()) -> DataRequest? {
        var api = "api/search/catalog/?"

        if let ordering = filter.ordering {
            api.append(contentsOf: "&ordering=\(ordering.rawValue)")
        }

        filter.genres.forEach { api.append(contentsOf: "&genres=\($0.id)") }
        filter.categories.forEach { api.append(contentsOf: "&categories=\($0.id)") }
        filter.types.forEach { api.append(contentsOf: "&types=\($0.id)") }
        filter.status.forEach { api.append(contentsOf: "&genres=\($0.id)") }
        filter.ageLimit.forEach { api.append(contentsOf: "&age_limit=\($0.id)") }
        
        filter.excludedGenres.forEach { api.append(contentsOf: "&exclude_genres=\($0.id)") }
        filter.excludedCategories.forEach { api.append(contentsOf: "&exclude_categories=\($0.id)") }
        filter.excludedTypes.forEach { api.append(contentsOf: "&exclude_types=\($0.id)") }
        api.append(contentsOf: "&page=\(page)&count=\(count)")

        return baseRequest(api, completionHandler: completionHandler)
    }

    @discardableResult
    func getCatalogFilters(completionHandler: @escaping (Result<ReCatalogFilterModel, HttpClientError>) -> ()) -> DataRequest? {
        let api = "api/forms/titles/?get=genres&get=categories&get=types&get=status&get=age_limit"
        return baseRequest(api, completionHandler: completionHandler)
    }

    @discardableResult
    func getSearch(query: String, page: Int, count: Int = 30, completionHandler: @escaping (Result<ReSearchModel, HttpClientError>) -> ()) -> DataRequest? {
        let api = "api/search/?query=\(query)&page=\(page)&count=\(count)"
        return baseRequest(api, completionHandler: completionHandler)
    }
    
    @discardableResult
    func getTitleComments(titleId: Int, page: Int, completionHandler: @escaping (Result<ReCommentsModel, HttpClientError>) -> ()) -> DataRequest? {
        let api = "api/activity/comments/?title_id=\(titleId)&page=\(page)&ordering=-id"
        return baseRequest(api, completionHandler: completionHandler)
    }

    @discardableResult
    func getCurrent(completionHandler: @escaping (Result<ReUserModel, HttpClientError>) -> ()) -> DataRequest? {
        let api = "api/users/current/"
        return baseRequest(api, completionHandler: completionHandler)
    }
    
    @discardableResult
    func setViews(chapter: Int, completionHandler: ((Result<String, HttpClientError>) -> ())? = nil) -> DataRequest? {
        let api = "api/activity/views/"
        
        let parameters: [String: String] = [
            "chapter": "\(chapter)"
        ]

        return baseRequest(api, method: .post, parameters: parameters, completionHandler: completionHandler)
    }

    @discardableResult
    func baseRequest<T: Decodable>(_ api: String, method: HTTPMethod = .get, parameters: Parameters? = nil, completionHandler: ((Result<T, HttpClientError>) -> ())? = nil) -> DataRequest? {
        guard let apiUrl = api.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                else {
                    completionHandler?(.failure(.description("Wrong url: \(api)")))
            return nil
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        return AF.request(ReClient.baseUrl + apiUrl, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseData { response in
            switch response.result {
            case .success(let res):
                if T.self == String.self {
                    completionHandler?(.success(String(data: res, encoding: .utf8) as! T))
                    return
                }
                
                do {
                    let title = try JSONDecoder().decode(T.self, from: res)
                    completionHandler?(.success(title))
//                    print(title)
                } catch {
                    completionHandler?(.failure(.error(error)))
                    print(error)
                }
            case .failure(let error):
                completionHandler?(.failure(.error(error)))
            }
        }
    }
}
