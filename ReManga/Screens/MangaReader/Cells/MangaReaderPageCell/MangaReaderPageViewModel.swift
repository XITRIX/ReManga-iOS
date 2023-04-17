//
//  MangaReaderPageViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 17.04.2023.
//

import MvvmFoundation
import RxRelay

class MangaReaderPageViewModel: MvvmViewModelWith<ApiMangaChapterPageModel> {
    let imageSize = BehaviorRelay<CGSize>(value: .zero)
    let imageUrl = BehaviorRelay<String?>(value: nil)

    override func prepare(with model: ApiMangaChapterPageModel) {
        imageSize.accept(model.size)
        imageUrl.accept(model.path)
    }
}
