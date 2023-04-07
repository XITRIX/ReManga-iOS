//
//  MangaDetailsSelectorViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 14.04.2023.
//

import MvvmFoundation
import RxRelay

class MangaDetailsSelectorViewModel: MvvmViewModel {
    let segments = BehaviorRelay<[String]>(value: ["Описание", "Главы", "Коментарии"])
    let selected = BehaviorRelay<Int>(value: 0)
}

extension MangaDetailsSelectorViewModel {

}
