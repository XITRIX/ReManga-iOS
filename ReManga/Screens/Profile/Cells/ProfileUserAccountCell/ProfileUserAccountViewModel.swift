//
//  ProfileUserAccountViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 25.04.2023.
//

import MvvmFoundation
import RxRelay

class ProfileUserAccountViewModel: MvvmViewModelWith<ApiMangaUserModel>, MvvmSelectableProtocol {
    var selectAction: (() -> Void)?

    public let currency = BehaviorRelay<String?>(value: nil)
    public let image = BehaviorRelay<String?>(value: nil)

    override func prepare(with model: ApiMangaUserModel) {
        title.accept(model.username)
        currency.accept(model.currency)
        image.accept(model.image)
    }
}
