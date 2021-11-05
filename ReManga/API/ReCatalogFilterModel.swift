//
//  CatalogSearchModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 05.11.2021.
//

import Foundation

enum ReCatalogSortingFilter: String {
    case rating = "-rating"
}

struct ReCatalogFilterModel {
    var ordering: ReCatalogSortingFilter? = .rating
    var genres: [Int] = []
    var categories: [Int] = []
}
