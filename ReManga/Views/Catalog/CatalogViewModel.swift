//
//  CatalogViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 04.11.2021.
//

import Bond
import Foundation
import Alamofire

enum ReCatalogSortingFilter: String {
    case rating = "-rating"
}

struct CatalogFilterModel {
    var ordering: ReCatalogSortingFilter?

    var genres: [ReCatalogFilterItem]?
    var categories: [ReCatalogFilterItem]?
    var types: [ReCatalogFilterItem]?
    var status: [ReCatalogFilterItem]?
    var ageLimit: [ReCatalogFilterItem]?

    var excludedGenres: [ReCatalogFilterItem]?
    var excludedCategories: [ReCatalogFilterItem]?
    var excludedTypes: [ReCatalogFilterItem]?
}

struct CatalogModel {
    var title: String?
    var filter: CatalogFilterModel
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
    private var currentTask: DataRequest?

    required init() {
        super.init()
        prepare(with: CatalogModel(title: "Каталог", filter: CatalogFilterModel(ordering: .rating), allowSearching: true, allowFiltering: true))
    }

    override func prepare(with item: CatalogModel) {
        page = 1
        currentTask?.cancel()
        loadingBarrier = false
        collection.removeAll()
        allowSearching = item.allowSearching
        allowFiltering = item.allowFiltering
        title.value = item.title
        model = item
    }

    override func appear() {
        loadNext()
    }

    func loadNext() {
        if loadingBarrier { return }
        loadingBarrier = true

        currentTask = ReClient.shared.getCatalog(page: page, filter: model.filter) { [weak self] result in
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

    func navigateFilter() {
        let model = CatalogFilterModel()
        navigate(to: CatalogFilterViewModel.self, prepare: model, with: .modal(wrapInNavigation: false))
    }
}
