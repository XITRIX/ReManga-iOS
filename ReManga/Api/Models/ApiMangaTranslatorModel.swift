//
//  ApiMangaTranslatorModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 16.04.2023.
//

import Foundation

struct ApiMangaTranslatorModel: Codable, Hashable {
    var imagePath: String
    var title: String
    var type: String
}
