//
//  ReMangaAuthViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 20.04.2023.
//

import MvvmFoundation

class ReMangaAuthViewModel: BaseViewModel {
    @Injected(key: .Backend.remanga.key) var api: ApiProtocol
    let authUrl = "https://id.vk.com/auth?app_id=6758074&state=dmssLyxhdXRo&response_type=code&redirect_uri=https%3A%2F%2Fremanga.org%2Fsocial&redirect_uri_hash=5b0f01862fd522f962&code_challenge=&code_challenge_method=&scope=4194304&force_hash="

    func fetchToken(code: String) {
        guard let api = api as? ReMangaApi else { return }
        Task {
            setApiToken(try await api.fetchAuthToken(code: code))
            dismiss()
        }
    }

    private func setApiToken(_ token: String) {
        api.authToken.accept(token)
    }
}
