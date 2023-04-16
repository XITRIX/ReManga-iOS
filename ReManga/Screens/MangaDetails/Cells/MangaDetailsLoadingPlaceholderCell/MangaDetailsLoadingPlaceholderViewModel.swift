//
//  MangaDetailsLoadingPlaceholderViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 16.04.2023.
//

import MvvmFoundation
import RxRelay

class MangaDetailsLoadingPlaceholderViewModel: MvvmViewModel {
    let isLoading = BehaviorRelay<Bool>(value: true)
}
