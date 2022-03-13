//
//  CatalogViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 04.11.2021.
//

import Alamofire
import Bond
import Foundation
import MVVMFoundation

enum ReCatalogSortingFilter: String {
    case rating = "-rating"
}

struct CatalogFiltersModel: Hashable {
    var ordering: ReCatalogSortingFilter? = .rating

    var genres = [ReCatalogFilterItem]()
    var categories = [ReCatalogFilterItem]()
    var types = [ReCatalogFilterItem]()
    var status = [ReCatalogFilterItem]()
    var ageLimit = [ReCatalogFilterItem]()

    var excludedGenres = [ReCatalogFilterItem]()
    var excludedCategories = [ReCatalogFilterItem]()
    var excludedTypes = [ReCatalogFilterItem]()

    static let empty = CatalogFiltersModel()
}

struct CatalogModel {
    var title: String?
    var filter: CatalogFiltersModel
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
    private var searchQuery: String?

    var isFiltersSelected: Bool {
        model.filter != CatalogFiltersModel()
    }

    required init() {
        super.init()
        prepare(with: createDefaultModel())
    }

    override func prepare(with item: CatalogModel) {
        model = item
        state.value = .processing
        page = 1
        currentTask?.cancel()
        loadingBarrier = false
        allowSearching = item.allowSearching
        allowFiltering = item.allowFiltering
        title.value = item.title
        collection.removeAll()
    }

    func createDefaultModel(with filters: CatalogFiltersModel = CatalogFiltersModel()) -> CatalogModel {
        CatalogModel(title: "Каталог", filter: filters, allowSearching: true, allowFiltering: true)
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
                self.collection.append(model.content)
                self.state.value = .done
                self.page += 1
            case .failure(let error):
                self.state.value = .error(.init(error, retryCallback: {
                    self.state.value = .processing
                    self.loadNext()
                }))
            }
            self.loadingBarrier = false
        }
    }

    func titleSelected(at index: Int) {
        guard let dir = collection[index].dir
        else { return }

        navigate(to: TitleViewModel.self, prepare: dir, with: .detail)
    }

    func navigateSearch() {
        let model = SearchModel(query: searchQuery) { [weak self] context, query in
            guard let self = self else { return }
            self.searchQuery = query

            guard let dir = context?.dir else { return }
            self.navigate(to: TitleViewModel.self, prepare: dir, with: .detail)
        }
        navigate(to: SearchViewModel.self, prepare: model, with: .modal(wrapInNavigation: false))
    }

    func navigateFilter() {
        let model = CatalogFilterModel(filters: model.filter) { [weak self] filters in
            guard let self = self else { return }
            if self.model.filter != filters {
                self.prepare(with: self.createDefaultModel(with: filters))
                self.loadNext()
            }
        }
        navigate(to: CatalogFilterViewModel.self, prepare: model, with: .modal(wrapInNavigation: false))
    }
}
