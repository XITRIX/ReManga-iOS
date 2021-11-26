//
//  ReClient+Main.swift
//  ReManga
//
//  Created by Даниил Виноградов on 22.11.2021.
//

import Alamofire
import Foundation

extension ReClient {
    @discardableResult
    func getTopList(completionHandler: ((Result<ReCatalogModel, HttpClientError>) -> ())? = nil) -> DataRequest? {
        let api = "api/titles/?ordering=-votes&count=30"
        return baseRequest(api, completionHandler: completionHandler)
    }

    @discardableResult
    func getPopularToday(completionHandler: ((Result<ReCatalogModel, HttpClientError>) -> ())? = nil) -> DataRequest? {
        let api = "api/titles/daily-top/?count=7"
        return baseRequest(api, completionHandler: completionHandler)
    }

    @discardableResult
    func getHotNews(completionHandler: ((Result<ReCatalogModel, HttpClientError>) -> ())? = nil) -> DataRequest? {
        let api = "api/titles/?last_days=7&ordering=-votes"
        return baseRequest(api, completionHandler: completionHandler)
    }

    @discardableResult
    func getNews(onlyReading: Bool, completionHandler: ((Result<ReUploadedChapterModel, HttpClientError>) -> ())? = nil) -> DataRequest? {
        let api = "api/titles/last-chapters/?\(onlyReading ? "only_reading=1&" : "")page=1&count=40"
        return baseRequest(api, completionHandler: completionHandler)
    }
}
