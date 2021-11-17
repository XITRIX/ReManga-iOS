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

struct CatalogFiltersModel: Hashable {
    var ordering: ReCatalogSortingFilter?

    var genres = [ReCatalogFilterItem]()
    var categories = [ReCatalogFilterItem]()
    var types = [ReCatalogFilterItem]()
    var status = [ReCatalogFilterItem]()
    var ageLimit = [ReCatalogFilterItem]()

    var excludedGenres = [ReCatalogFilterItem]()
    var excludedCategories = [ReCatalogFilterItem]()
    var excludedTypes = [ReCatalogFilterItem]()
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

    required init() {
        super.init()
        prepare(with: createDefaultModel())
    }

    override func prepare(with item: CatalogModel) {
        state.value = .processing
        page = 1
        currentTask?.cancel()
        loadingBarrier = false
        allowSearching = item.allowSearching
        allowFiltering = item.allowFiltering
        title.value = item.title
        model = item
        collection.removeAll()
    }

    func createDefaultModel(with filters: CatalogFiltersModel = CatalogFiltersModel(ordering: .rating)) -> CatalogModel {
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
