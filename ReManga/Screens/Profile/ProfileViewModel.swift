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
    @Injected private var api: ApiProtocol

    required init() {
        super.init()
        title.accept("Профиль")
    }

    override func binding() {
        bind(in: disposeBag) {
            authToken <-> api.authToken
        }
    }

    func auth() {
        api.showAuthScreen(from: self)
    }
}
