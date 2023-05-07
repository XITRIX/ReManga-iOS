//
//  ProfileAccountViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 24.04.2023.
//

import MvvmFoundation
import RxRelay

class ProfileAccountViewModel: MvvmViewModel {
    let subtitle = BehaviorRelay<String?>(value: nil)
    let image = BehaviorRelay<Image?>(value: nil)
}
