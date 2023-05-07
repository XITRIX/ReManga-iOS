//
//  NewMangaApi+Auth.swift
//  ReManga
//
//  Created by Даниил Виноградов on 18.04.2023.
//

import MvvmFoundation

extension NewMangaApi: ApiAuthProtocol {
    @MainActor
    func showAuthScreen(from vm: MvvmViewModel) {
        vm.navigate(to: NewMangaAuthViewModel.self, by: .present(wrapInNavigation: true))
    }
}
