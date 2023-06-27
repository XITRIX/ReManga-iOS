//
//  DownloadDetailsChapterViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 08.05.2023.
//

import MvvmFoundation
import RxRelay

class DownloadDetailsChapterViewModel: MvvmViewModelWith<MangaChapterDownloadModel> {
    let tome = BehaviorRelay<String>(value: "")
    let chapter = BehaviorRelay<String>(value: "")
    var pages = BehaviorRelay<[ApiMangaChapterPageModel]>(value: [])

    override func prepare(with model: MangaChapterDownloadModel) {
        title.accept(model.title)
        tome.accept(model.tome)
        chapter.accept("Глава \(model.chapter)")
        pages.accept(model.pages)
    }

    override func hash(into hasher: inout Hasher) {
        hasher.combine(tome.value)
        hasher.combine(chapter.value)
    }

    override func isEqual(to other: MvvmViewModel) -> Bool {
        guard let other = other as? Self else { return false }
        return tome.value == other.tome.value &&
            chapter.value == other.chapter.value
    }
}
