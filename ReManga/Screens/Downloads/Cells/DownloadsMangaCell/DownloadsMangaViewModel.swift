//
//  DownloadsMangaViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 07.05.2023.
//

import MvvmFoundation
import RxRelay

class DownloadsMangaViewModel: MvvmViewModelWith<MangaDownloadModel> {
    let image = BehaviorRelay<String?>(value: nil)
    let chapters = BehaviorRelay<String?>(value: nil)

    override func prepare(with model: MangaDownloadModel) {
        title.accept(model.name)
        image.accept(model.image)
        chapters.accept("Глав скачано: \(model.chapters.count)")
    }
}
