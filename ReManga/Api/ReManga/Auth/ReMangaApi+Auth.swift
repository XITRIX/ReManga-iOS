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
            .init(title: "Почта", style: .default, action: {
                vm.alert {
                    let alert = UIAlertController(title: "Авторизация", message: nil, preferredStyle: .alert)
                    alert.addTextField { textFielt in
                        textFielt.placeholder = "Почта"
                        textFielt.textContentType = .username
                    }
                    alert.addTextField { textFielt in
                        textFielt.placeholder = "Пароль"
                        textFielt.textContentType = .password
                        textFielt.isSecureTextEntry = true
                    }

                    alert.addAction(.init(title: "Закрыть", style: .cancel))
                    alert.addAction(.init(title: "Продолжить", style: .default, handler: { [unowned self] _ in
                        guard let login = alert.textFields?[0].text,
                              let password = alert.textFields?[1].text
                        else { return }

                        Task {
                            try await process(login: login, password: password, from: vm)
                        }

                    }))

                    return alert
                }
            }),
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

    @MainActor
    func process(login: String, password: String, from vm: MvvmViewModel) async throws {
        let url = "https://api.remanga.org/api/users/login/"
        var request = URLRequest(url: URL(string: url)!)

        request.httpMethod = "POST"

        request.httpBody =
            """
            {
            \"g-recaptcha-response\": \"WITHOUT_TOKEN\",
            \"password\": \"\(password)\",
            \"user\": \"\(login)\"
            }
            """.data(using: .utf8)

        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        do {
            let (result, _) = try await URLSession.shared.data(for: request)
            let model = try JSONDecoder().decode(ReMangaAuthResult.self, from: result)

            setApiToken(model.content.accessToken)
        } catch {
            vm.alert(title: "Ошибка", message: "Неверный логин или пароль", actions: [
                .init(title: "ОК", style: .cancel)
            ])
        }
    }

    func setApiToken(_ token: String) {
        authToken.accept(token)
    }
}
