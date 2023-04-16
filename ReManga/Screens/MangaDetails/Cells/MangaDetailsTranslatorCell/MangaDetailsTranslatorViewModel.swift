//
//  MangaDetailsTranslatorViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 16.04.2023.
//

import MvvmFoundation
import RxRelay

class MangaDetailsTranslatorViewModel: MvvmViewModelWith<ApiMangaTranslatorModel> {
    let subtitle = BehaviorRelay<String?>(value: "")
    let image = BehaviorRelay<String?>(value: nil)

    override func prepare(with model: ApiMangaTranslatorModel) {
        title.accept(model.title)
        subtitle.accept(model.type)
        image.accept(model.imagePath)
    }
}
