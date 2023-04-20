//
//  ReMangaAuthViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 20.04.2023.
//

import MvvmFoundation

class ReMangaAuthViewModel: BaseViewModel {
    @Injected var api: ApiProtocol
    let authUrl = "https://id.vk.com/auth?app_id=6758074&state=dmssL21hbmdhL3NvbG8tbGV2ZWxpbmcsYXV0aA==&response_type=code&redirect_uri=https://remanga.org/social&redirect_uri_hash=a4c5222b2d022b0c11&code_challenge=&code_challenge_method=&return_auth_hash=d6a4d0ba2cb677f18e&scope=4194304&force_hash="

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
