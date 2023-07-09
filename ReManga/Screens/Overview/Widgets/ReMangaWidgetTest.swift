//
//  ReMangaWidgetTest.swift
//  ReManga
//
//  Created by Даниил Виноградов on 04.07.2023.
//

import MvvmFoundation

class ReMangaPopularWidget: Widget {
    var apiKey: ContainerKey.Backend { .remanga }

    func getManga() async throws -> [ApiMangaModel] {
        let api = Mvvm.shared.container.resolve(type: ApiProtocol.self, key: apiKey.key) as! ReMangaApi
        return try await api.fetchPopulars()
    }
}
