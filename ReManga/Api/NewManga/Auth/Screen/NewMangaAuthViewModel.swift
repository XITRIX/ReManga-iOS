//
//  NewMangaAuthViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 18.04.2023.
//

import MvvmFoundation

class NewMangaAuthViewModel: BaseViewModel {
    @Injected var api: ApiProtocol
    let authUrl = "https://oauth.vk.com/authorize?client_id=7782992&display=page&response_type=code&redirect_uri=https://api.newmanga.org/v2/oauth/vk"

    func setApiToken(_ token: String) {
        api.authToken.accept(token)
    }
}
