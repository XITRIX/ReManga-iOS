//
//  ReMangaApi+Auth.swift
//  ReManga
//
//  Created by Даниил Виноградов on 18.04.2023.
//

import MvvmFoundation

extension ApiAuthSource {
    var remangaProviderKey: String {
        switch self {
        case .vk:
            return "vk"
        case .google:
            return "google"
        case .yandex:
            return "yandex"
        }
    }
}

extension ReMangaApi: ApiAuthProtocol {
    @MainActor
    func showAuthScreen(from vm: MvvmViewModel) {
        vm.alert(title: "Войти в аккаунт", message: nil, actions: [
            .init(title: "Через Вконтакте", style: .default, action: {
                vm.navigate(to: ReMangaVKAuthViewModel.self, by: .present(wrapInNavigation: true))
            }),
            .init(title: "Через Яндекс", style: .default, action: {
                vm.navigate(to: ReMangaVKAuthViewModel.self, by: .present(wrapInNavigation: true))
            }),
            .init(title: "Через Google", style: .default, action: {
                vm.navigate(to: ReMangaGoogleAuthViewModel.self, by: .present(wrapInNavigation: true))
            }),
            .init(title: "Закрыть", style: .cancel)
        ])
    }

    func fetchAuthToken(code: String, source: ApiAuthSource) async throws -> String {
        let url = "https://api.remanga.org/api/users/social/"
        var request = URLRequest(url: URL(string: url)!)

        request.httpMethod = "POST"

        request.httpBody =
        """
        {
        \"code\": \"\(code)\",
        \"provider\": \"\(source.remangaProviderKey)\",
        \"referral\": \"\",
        \"redirect_uri\": \"https://remanga.org/social\"
        }
        """.data(using: .utf8)

        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        let (result, _) = try await URLSession.shared.data(for: request)
        let model = try JSONDecoder().decode(ReMangaAuthResult.self, from: result)

        return await MainActor.run { model.content.accessToken }
    }
}
