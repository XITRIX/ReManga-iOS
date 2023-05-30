//
//  ReMangaGoogleAuthViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 19.05.2023.
//

import MvvmFoundation

class ReMangaGoogleAuthViewModel: BaseViewModel, OAuthViewModel {
    @Injected(key: .Backend.remanga.key) private var api: ApiProtocol
    let authUrl = "https://accounts.google.com/o/oauth2/auth?response_type=code&client_id=870103191341-ni2q6s2m6gviad50d07kolo9u75cgadd.apps.googleusercontent.com&redirect_uri=https://remanga.org/social&scope=openid%20email%20profile&state=Z29vZ2xlLC8sYXV0aA=="

    func performWebViewNavigation(from response: URLResponse) -> Bool {
        guard let url = response.url?.absoluteString,
              url.starts(with: "https://remanga.org/social?"),
              let code = response.url?.queryParameters?["code"]
        else { return false }

        fetchToken(code: code)
        return true
    }
}

private extension ReMangaGoogleAuthViewModel {
    func fetchToken(code: String) {
        guard let api = api as? ReMangaApi else { return }
        Task {
            setApiToken(try await api.fetchAuthToken(code: code, source: .google))
            dismiss()
        }
    }

    func setApiToken(_ token: String) {
        api.authToken.accept(token)
    }
}
