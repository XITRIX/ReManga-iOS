//
//  MangaDetailsTagViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 14.04.2023.
//

import MvvmFoundation
import RxRelay

class MangaDetailsTagViewModel: MvvmViewModel {
    let tag = BehaviorRelay<ApiMangaTag?>(value: nil)
}
