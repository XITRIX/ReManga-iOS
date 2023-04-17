//
//  MangaReaderLoadNextViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 17.04.2023.
//

import MvvmFoundation
import RxRelay

class MangaReaderLoadNextViewModel: MvvmViewModel {
    let loadNext = PublishRelay<Void>()
}
