//
//  ProfileViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 18.04.2023.
//

import MvvmFoundation
import RxRelay
import RxBiBinding

class ProfileViewModel: BaseViewModel {
    let authToken = BehaviorRelay<String?>(value: nil)
    @Injected(key: .Backend.remanga.key) private var remangaApi: ApiProtocol
    @Injected(key: .Backend.newmanga.key) private var newmangaApi: ApiProtocol

    required init() {
        super.init()
        title.accept("Профиль")
    }

    override func binding() {
        bind(in: disposeBag) {
            authToken <-> remangaApi.authToken
        }
    }

    func auth() {
        remangaApi.showAuthScreen(from: self)
    }
}
