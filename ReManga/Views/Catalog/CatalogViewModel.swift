//
//  CatalogViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 04.11.2021.
//

import Bond
import Foundation

struct CatalogModel {
    var title: String?
    var filter: ReCatalogFilterModel
    var allowSearching: Bool = false
    var allowFiltering: Bool = false
}

class CatalogViewModel: MvvmViewModelWith<CatalogModel> {
    var allowSearching: Bool = false
    var allowFiltering: Bool = false
    let collection = MutableObservableArray<ReCatalogContent>()
    private var page = 1
    private var model: CatalogModel!
    private var loadingBarrier = false

    required init() {
        super.init()
        prepare(with: CatalogModel(title: "Каталог", filter: ReCatalogFilterModel(ordering: .rating), allowSearching: true))
    }

    override func prepare(with item: CatalogModel) {
        allowSearching = item.allowSearching
        allowFiltering = item.allowFiltering
        title.value = item.title
        model = item
    }

    func loadNext() {
        if loadingBarrier { return }
        loadingBarrier = true

        ReClient.shared.getCatalog(page: page, filter: model.filter) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let model):
                model.content.forEach { self.collection.append($0) }
                self.page += 1
            case .failure:
                break
            }
            self.loadingBarrier = false
        }
    }

    func titleSelected(at index: Int) {
        guard let dir = collection[index].dir
        else { return }

        navigate(to: TitleViewModel.self, prepare: dir)
    }

    func navigateSearch() {
        let model = SearchModel { [weak self] context in
            guard let self = self,
                  let dir = context.dir
            else { return }

            self.navigate(to: TitleViewModel.self, prepare: dir)
        }
        navigate(to: SearchViewModel.self, prepare: model, with: .modal(wrapInNavigation: false))
    }
}
