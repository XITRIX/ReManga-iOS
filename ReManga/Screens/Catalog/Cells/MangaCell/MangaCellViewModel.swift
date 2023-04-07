//
//  MangaCellViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 07.04.2023.
//

import MvvmFoundation
import RxSwift
import RxRelay

protocol MangaCellViewModelProtocol: MvvmViewModelWithProtocol {
    var img: BehaviorRelay<String?> { get }
    var id: BehaviorRelay<String> { get }
}

class MangaCellViewModel: MvvmViewModelWith<ApiMangaModel>, MangaCellViewModelProtocol {
    let img = BehaviorRelay<String?>(value: nil)
    let id = BehaviorRelay<String>(value: "")

    override func prepare(with model: ApiMangaModel) {
        title.accept(model.rusTitle ?? model.title)
        img.accept(model.img)
        id.accept(model.id)
    }

    override func hash(into hasher: inout Hasher) {
        hasher.combine(id.value)
    }

    override func isEqual(to other: MvvmViewModel) -> Bool {
        guard let other = other as? Self
        else { return false }

        return id.value == other.id.value
    }
}
