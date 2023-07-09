//
//  Widget.swift
//  ReManga
//
//  Created by Даниил Виноградов on 04.07.2023.
//

import MvvmFoundation

protocol Widget {
    var apiKey: ContainerKey.Backend { get }
    func getManga() async throws -> [ApiMangaModel]
}
