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

    override func prepare(with model: ApiMangaChapterModel) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"

        tome.accept("\(model.tome)")
        chapter.accept("Глава \(model.chapter)")
        date.accept(dateFormatter.string(from: model.date))
        id.accept(model.id)
        team.accept(model.team)
    }
}
