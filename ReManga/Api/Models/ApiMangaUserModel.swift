//
//  ApiMangaUserModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 23.04.2023.
//

import Foundation

struct ApiMangaUserModel: Hashable {
    var id: Int
    var username: String
    var image: String?
    var currency: String?
}
