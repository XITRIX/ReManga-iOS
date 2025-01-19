//
//  ReMangaVKAuthViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 20.04.2023.
//

import MvvmFoundation

protocol OAuthViewModel: BaseViewModelProtocol {
    var authUrl: String { get }
    func performWebViewNavigation(from response: URLResponse) -> Bool
}

class ReMangaVKAuthViewModel: BaseViewModel, OAuthViewModel {
    @Injected(key: .Backend.remanga.key) private var api: ApiProtocol
    let authUrl = "https://oauth.vk.com/authorize?client_id=6758074&display=popup&redirect_uri=https://remanga.org/social&scope=email&response_type=code&v=5.101&state=dmssLyxhdXRo"
    let newAuthUrl = "https://id.vk.com/auth?app_id=51784295&response_type=silent_token&v=1.61.1&redirect_uri=https%3A%2F%2Fremanga.org%2Fvk&uuid=8_wgEdO8Oqg2VYWWO4ECF&redirect_state=SuNZF"

    func performWebViewNavigation(from response: URLResponse) -> Bool {
        guard let url = response.url?.absoluteString,
              url.starts(with: "https://remanga.org/social?code="),
              let code = response.url?.queryParameters?["code"]
        else { return false }

        fetchToken(code: code)
        return true
    }
}

private extension ReMangaVKAuthViewModel {
    func fetchToken(code: String) {
        guard let api = api as? ReMangaApi else { return }
        Task {
            api.setApiToken(try await api.fetchAuthToken(code: code, source: .vk))
            dismiss()
        }
    }
}

extension URL {
    var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { result, item in
            result[item.name] = item.value
        }
    }
}
