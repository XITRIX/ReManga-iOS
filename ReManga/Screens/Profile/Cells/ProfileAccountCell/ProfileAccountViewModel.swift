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

//    override func hash(into hasher: inout Hasher) {
//        hasher.combine(title.value)
//        hasher.combine(subtitle.value)
//    }
//
//    override func isEqual(to other: MvvmViewModel) -> Bool {
//        guard let other = other as? Self else { return false }
//        return title.value == other.title.value &&
//            subtitle.value == other.subtitle.value
//    }
}
