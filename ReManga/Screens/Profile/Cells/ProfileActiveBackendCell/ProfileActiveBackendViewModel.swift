//
//  ProfileActiveBackendViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 10.05.2023.
//

import MvvmFoundation
import RxRelay

class ProfileActiveBackendViewModel: MvvmViewModel, MvvmSelectableProtocol {
    var selectAction: (() -> Void)?

    let detailsTitle = BehaviorRelay<String?>(value: nil)

    required init() {
        super.init()
        title.accept("Главный ресурс")
    }
}
