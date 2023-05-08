//
//  DownloadsMangaViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 07.05.2023.
//

import MvvmFoundation
import RxRelay

class DownloadsMangaViewModel: MvvmViewModelWith<MangaDownloadModel> {
    var id: String?
    let image = BehaviorRelay<String?>(value: nil)
    let chapters = BehaviorRelay<String?>(value: nil)
    var date = BehaviorRelay<Date?>(value: nil)

    override func prepare(with model: MangaDownloadModel) {
        id = model.id

        bind(in: disposeBag) {
            title <- model.name
            image <- model.image
            date <- model.date
            chapters <- model.chapters.map { "Глав скачано: \($0.count)" }
        }
    }

    override func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    override func isEqual(to other: MvvmViewModel) -> Bool {
        guard let other = other as? Self else { return false }
        return id == other.id
    }
}