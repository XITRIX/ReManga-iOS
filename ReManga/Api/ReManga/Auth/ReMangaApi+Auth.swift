//
//  ReMangaApi+Auth.swift
//  ReManga
//
//  Created by Даниил Виноградов on 18.04.2023.
//

import MvvmFoundation

extension ReMangaApi: ApiAuthProtocol {
    @MainActor
    func showAuthScreen(from vm: MvvmViewModel) {
        vm.navigate(to: ReMangaAuthViewModel.self, by: .present(wrapInNavigation: true))
    }

    func fetchAuthToken(code: String) async throws -> String {
        let url = "https://api.remanga.org/api/users/social/"
        var request = URLRequest(url: URL(string: url)!)

        request.httpMethod = "POST"
        request.httpBody =
        """
        {
        \"code\": \"\(code)\",
        \"provider\": \"vk\",
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
