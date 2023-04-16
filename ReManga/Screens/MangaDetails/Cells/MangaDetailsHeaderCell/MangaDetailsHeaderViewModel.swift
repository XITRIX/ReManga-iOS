//
//  MangaDetailsHeaderViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 16.04.2023.
//

import MvvmFoundation

class MangaDetailsHeaderViewModel: MvvmViewModelWith<String> {
    override func prepare(with model: String) {
        title.accept(model)
    }
}
