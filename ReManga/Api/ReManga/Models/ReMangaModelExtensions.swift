//
//  ReMangaModelExtensions.swift
//  ReManga
//
//  Created by Даниил Виноградов on 12.04.2023.
//

import Foundation

extension ApiMangaModel {
    init(from model: ReMangaApiMangaModel) {
        id = model.dir
        title = model.enName
        rusTitle = model.rusName
        img = model.img.low
    }
}
