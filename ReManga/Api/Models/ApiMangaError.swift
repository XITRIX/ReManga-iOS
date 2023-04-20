//
//  ApiMangaError.swift
//  ReManga
//
//  Created by Даниил Виноградов on 18.04.2023.
//

import Foundation

enum ApiMangaError: Error {
    case needPayment(MangaDetailsChapterViewModel)
    case operationNotSupported(message: String)
}
