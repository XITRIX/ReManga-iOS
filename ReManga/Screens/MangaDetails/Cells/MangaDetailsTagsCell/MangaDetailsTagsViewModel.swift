//
//  MangaDetailsTagsViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 14.04.2023.
//

import MvvmFoundation
import RxRelay

class MangaDetailsTagsViewModel: MvvmViewModel {
    let tags = BehaviorRelay<[MangaDetailsTagViewModel]>(value: [])
    let isExpanded = BehaviorRelay<Bool>(value: false)
    let tagSelected = PublishRelay<ApiMangaTag>()
}
