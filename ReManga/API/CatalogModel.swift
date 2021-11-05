//
//  CatalogSearchModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 05.11.2021.
//

import Foundation

enum CatalogSorting: String {
    case rating = "-rating"
}

struct CatalogModel {
    var title: String?
    var ordering: CatalogSorting? = .rating
    var genres: [Int] = []
    var categories: [Int] = []
}
