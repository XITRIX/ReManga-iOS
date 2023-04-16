//
//  MangaDetailsCommentViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 16.04.2023.
//

import MvvmFoundation
import RxRelay

class MangaDetailsCommentViewModel: MvvmViewModelWith<ApiMangaCommentModel> {
    let name = BehaviorRelay<String?>(value: nil)
    let date = BehaviorRelay<String?>(value: nil)
    let image = BehaviorRelay<String?>(value: nil)
    let score = BehaviorRelay<String?>(value: nil)
    let content = BehaviorRelay<NSAttributedString?>(value: nil)

    override func prepare(with model: ApiMangaCommentModel) {
        name.accept(model.name)
        image.accept(model.imagePath)
        score.accept(String(model.score))
        name.accept(model.name)
        content.accept(model.text)
//        date.accept(model.date)
    }
}
