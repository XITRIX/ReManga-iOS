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

    override func prepare(with item: CatalogModel) {
        title.value = item.title

        ReClient.shared.getCatalog(page: 1, model: item) { result in
            switch result {
            case .success(let model):
                model.content.forEach { self.collection.append($0) }

            case .failure(_):
                break
            }
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
