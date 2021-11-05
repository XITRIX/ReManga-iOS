//
//  CatalogViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 04.11.2021.
//

import Foundation
import Bond

class CatalogViewModel: MvvmViewModel {
    let collection = MutableObservableArray<ReCatalogContent>()

    required init() {
        super.init()

        title.value = "Каталог"
        
        ReClient.shared.getCatalog(page: 1) { result in
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
