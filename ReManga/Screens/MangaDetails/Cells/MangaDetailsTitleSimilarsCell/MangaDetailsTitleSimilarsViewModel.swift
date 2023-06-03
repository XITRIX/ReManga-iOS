//
//  MangaDetailsTitleSimilarsViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 03.06.2023.
//

import MvvmFoundation
import RxRelay

class MangaDetailsTitleSimilarsViewModel: MvvmViewModel {
    let similars = BehaviorRelay<[ApiMangaModel]>(value: [])

    let selected = PublishRelay<String>()
}
