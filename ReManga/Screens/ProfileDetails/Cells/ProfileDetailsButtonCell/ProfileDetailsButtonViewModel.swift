//
//  ProfileDetailsButtonViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 06.05.2023.
//

import MvvmFoundation
import RxRelay

class ProfileDetailsButtonViewModel: MvvmViewModel, MvvmSelectableProtocol {
    var selectAction: (() -> Void)?

    let style = BehaviorRelay<Style>(value: .normal)
}

extension ProfileDetailsButtonViewModel {
    enum Style {
        case normal
        case destructive
    }
}
