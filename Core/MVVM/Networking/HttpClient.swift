//
//  HttpClient.swift
//  DemoMVVM
//
//  Created by Даниил Виноградов on 03.11.2021.
//

import Foundation

enum HttpClientError: Error {
    case badUrl
    case description(String)
    case withCode(code: Int, description: String?)
    case error(Error)
}

class HttpClient {
    func get(url: String, completion: @escaping (Result<Data, HttpClientError>)->()) -> URLSessionDataTask? {
        if let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
            let url = URL(string: encodedUrl) {
            return URLSession.shared.dataTask(with: url) { data, responce, error in
                if let error = error {
                    completion(.failure(.description(error.localizedDescription)))
                } else if let responce = responce as? HTTPURLResponse,
                    responce.statusCode != 200 {
                    completion(.failure(.withCode(code: responce.statusCode, description: nil)))
                } else if let data = data {
                    completion(.success(data))
                }
            }
        }
        completion(.failure(.badUrl))
        return nil
    }
}
