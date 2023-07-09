//
//  WidgetHCollectionViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 04.07.2023.
//

import MvvmFoundation
import RxRelay
import RxSwift

class WidgetHCollectionViewModel: BaseViewModelWith<Widget> {
    let isLoading = BehaviorRelay<Bool>(value: true)
    let items = BehaviorRelay<[ApiMangaModel]>(value: [])

    var model: Widget!

    override func prepare(with model: Widget) {
        self.model = model
        performTask { [self] in
            items.accept(try await model.getManga())
            isLoading.accept(false)
        }
    }

    func select(item: String) {
        navigate(to: MangaDetailsViewModel.self, with: .init(id: item, apiKey: model.apiKey), by: .show)
    }
}
