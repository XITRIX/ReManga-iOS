//
//  MangaDetailsDescriptionTextViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 14.04.2023.
//

import MvvmFoundation
import RxRelay

class MangaDetailsDescriptionTextViewModel: MvvmViewModel {
    let isExpanded = BehaviorRelay<Bool>(value: false)
}
