//
//  MangaDetailsChapterViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 14.04.2023.
//

import MvvmFoundation
import RxRelay

class MangaDetailsChapterViewModel: MvvmViewModelWith<ApiMangaChapterModel> {
    let tome = BehaviorRelay<String>(value: "")
    let chapter = BehaviorRelay<String>(value: "")
    let date = BehaviorRelay<String>(value: "11.11.11")

    override func prepare(with model: ApiMangaChapterModel) {
        tome.accept("\(model.tome)")
        chapter.accept("Глава \(model.chapter)")
        date.accept(model.date)
    }
}
