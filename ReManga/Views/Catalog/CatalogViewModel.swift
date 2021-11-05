//
//  CatalogViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 04.11.2021.
//

import Foundation
import Bond

class CatalogViewModel: MvvmViewModelWith<CatalogModel> {
    let collection = MutableObservableArray<ReCatalogContent>()
    private var page = 1
    private var model: CatalogModel!
    private var loadingBarrier = false

    override func prepare(with item: CatalogModel) {
        title.value = item.title
        model = item
        loadNext()
    }

    func loadNext() {
        if loadingBarrier { return }
        loadingBarrier = true

        ReClient.shared.getCatalog(page: page, model: model) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let model):
                model.content.forEach { self.collection.append($0) }
                self.page += 1
            case .failure(_):
                break
            }
            self.loadingBarrier = false
        }
    }

    func titleSelected(at index: Int) {
        guard let _ = collection[index].dir
        else { return }

        if let dir = collection[index].dir {
            navigate(to: TitleViewModel.self, prepare: dir)
        }
    }
}
