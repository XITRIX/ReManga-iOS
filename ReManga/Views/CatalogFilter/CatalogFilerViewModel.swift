//
//  CatalogFilerViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 06.11.2021.
//

import Foundation
import Bond

class CatalogFilterViewModel: MvvmViewModelWith<CatalogFilterModel> {
    let availableFilters = Observable<ReCatalogFilterContent?>(nil)
    let filters = Observable(CatalogFilterModel())

    override func prepare(with item: CatalogFilterModel) {
        filters.value = item

        ReClient.shared.getCatalogFilters { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let model):
                self.availableFilters.value = model.content
            case .failure(_):
                break
            }
        }
    }
}
