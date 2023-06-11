//
//  CatalogFilterHeaderViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 11.06.2023.
//

import MvvmFoundation

class CatalogFilterHeaderViewModel: MvvmViewModelWith<MvvmCollectionSectionModel> {
    var section: MvvmCollectionSectionModel!

    override func prepare(with model: MvvmCollectionSectionModel) {
        section = model
        title.accept(model.header ?? "")
    }
}
