//
//  XTRequest.swift
//  XTNetworking
//
//  Created by Даниил Виноградов on 18.07.2023.
//

import Foundation

public class XTRequest {
    private let baseUrl: URL
    private var method: Method = .get
    private let handlers: [RequestHandler]

    public init(url: URL, handlers: [RequestHandler] = []) {
        self.baseUrl = url
        self.handlers = handlers
    }
}

public extension XTRequest {
    convenience init(string: String) {
        guard let url = URL(string: string)
        else { fatalError("Unable to cast \(string) into \(URL.self)") }

        self.init(url: url)
    }
}

public extension XTRequest {
    enum Method {
        case get
        case post(Body? = nil)
    }

    func with(method: Method) -> Self {
        self.method = method
        return self
    }
}

public extension XTRequest.Method {
    enum Body {
        case json(String)
        case codable(Codable)
    }
}

public protocol RequestHandler {
    func send(request: URLRequest) async throws -> (data: Data, responce: HTTPURLResponse)
}

struct ReAuthRequestHandler: RequestHandler {
    private let superHandler: RequestHandler
    private let api: ReMangaApi

    init(_ superHandler: RequestHandler, api: ReMangaApi) {
        self.superHandler = superHandler
        self.api = api
    }

    func send(request: URLRequest) async throws -> (data: Data, responce: HTTPURLResponse) {
        var request = request

        if let authToken = api.authToken.value {
            request.addValue("bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }

        let result = try await superHandler.send(request: request)
        if result.responce.statusCode == 401 {
            api.deauth()
        }

        return result
    }
}

struct URLSessionRequestHandler: RequestHandler {
    func send(request: URLRequest) async throws -> (data: Data, responce: HTTPURLResponse) {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse
        else { throw XTRequest.Error.InvalidResponse }
        return (data, response)
    }
}

public extension XTRequest {
    enum Error: Swift.Error {
        case InvalidResponse
    }
}

public extension XTRequest {
    func get<T: Codable>() async throws -> T {
        var request = URLRequest(url: baseUrl)

        switch method {
        case .get:
            request.httpMethod = "GET"
        case .post(let body):
            request.httpMethod = "POST"
            switch body {
            case .json(let string):
                request.httpBody = string.data(using: .utf8)
                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            case .codable(let obj):
                request.httpBody = try JSONEncoder().encode(obj)
                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            case .none:
                break
            }
        }

//        for handler in self.handlers {
//            try await handler.prepare(&request)
//        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard response is HTTPURLResponse
        else { throw Error.InvalidResponse }

//        for handler in self.handlers.reversed() {
//            try await handler.retrieve(data: data, responce: response)
//        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}
