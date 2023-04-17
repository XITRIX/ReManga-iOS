//
//  MangaDetailsChapterViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 14.04.2023.
//

import MvvmFoundation
import RxRelay

class MangaDetailsChapterViewModel: MvvmViewModelWith<ApiMangaChapterModel> {
    let id = BehaviorRelay<String>(value: "")
    let tome = BehaviorRelay<String>(value: "")
    let chapter = BehaviorRelay<String>(value: "")
    let team = BehaviorRelay<String?>(value: "")
    let date = BehaviorRelay<String>(value: "11.11.11")
    let isReaded = BehaviorRelay<Bool>(value: false)
    let isLiked = BehaviorRelay<Bool>(value: false)
    let likes = BehaviorRelay<Int>(value: 0)

    override func prepare(with model: ApiMangaChapterModel) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"

        tome.accept("\(model.tome)")
        chapter.accept("Глава \(model.chapter)")
        date.accept(dateFormatter.string(from: model.date))
        id.accept(model.id)
        team.accept(model.team)
        isReaded.accept(model.isReaded)
        isLiked.accept(model.isLiked)
        likes.accept(model.likes)
    }
}
