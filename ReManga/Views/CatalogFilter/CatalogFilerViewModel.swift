//
//  CatalogFilerViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 06.11.2021.
//

import Foundation
import Bond

struct CatalogFilterModel {
    var filters: CatalogFiltersModel
    var completion: ((CatalogFiltersModel)->())?
}

class CatalogFilterViewModel: MvvmViewModelWith<CatalogFilterModel> {
    let availableFilters = Observable<ReCatalogFilterContent?>(nil)
    var filters = CatalogFiltersModel()
    var completion: ((CatalogFiltersModel)->())?

    override func prepare(with item: CatalogFilterModel) {
        filters = item.filters
        completion = item.completion
        load()
    }

    func load() {
        state.value = .processing
        ReClient.shared.getCatalogFilters { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let model):
                self.availableFilters.value = model.content
                self.state.value = .done
            case .failure(let error):
                self.state.value = .error(.init(error, retryCallback: self.load))
            }
        }
    }

    func done() {
        dismiss { [unowned self] in
            self.completion?(filters)
        }
    }
}
