//
//  CatalogFilterItemViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 10.06.2023.
//

import MvvmFoundation

class CatalogFilterItemViewModel: MvvmViewModelWith<ApiMangaTag> {
    private(set) var tag: ApiMangaTag!

    override func prepare(with model: ApiMangaTag) {
        tag = model
        title.accept(model.name)
    }
}
