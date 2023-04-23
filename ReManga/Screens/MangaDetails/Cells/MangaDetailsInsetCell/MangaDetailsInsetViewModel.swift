//
//  MangaDetailsInsetViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 23.04.2023.
//

import MvvmFoundation
import RxRelay

class MangaDetailsInsetViewModel: MvvmViewModel {
    let height = BehaviorRelay<CGFloat>(value: 0)
}
