//
//  CatalogViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 07.04.2023.
//

import MvvmFoundation
import RxSwift
import RxRelay

protocol CatalogViewModelProtocol: BaseViewModelProtocol {
    var items: Observable<[MangaCellViewModel]> { get }
    var searchQuery: BehaviorRelay<String?> { get }
    func loadNext()
    func showDetails(for model: MangaCellViewModel)
}

class CatalogViewModel: BaseViewModel, CatalogViewModelProtocol {
    public let allItems = BehaviorRelay<[MangaCellViewModel]>(value: [])
    public let searchItems = BehaviorRelay<[MangaCellViewModel]>(value: [])
    public let searchQuery = BehaviorRelay<String?>(value: "")

    public var items: Observable<[MangaCellViewModel]> {
        Observable.combineLatest(allItems, searchItems).map { (all, search) in
            if search.isEmpty {
                return all
            }
            return search
        }
    }
    
    required init() {
        super.init()
        title.accept("Каталог")

        bind(in: disposeBag) {
            searchQuery.bind { [unowned self] _ in
                _ = Task {
                    await fetchSearchItems()
                }
            }
        }
    }

    func loadNext() {
        guard searchQuery.value.isNilOrEmpty
        else { return }

        Task { await fetchItems() }
    }

    func showDetails(for model: MangaCellViewModel) {
        navigate(to: MangaDetailsViewModel.self, with: model.id.value, by: .show)
    }

    // MARK: - Private
    private var isLoading = false
    private var page = 0
    @Injected private var api: ApiProtocol
}

// MARK: - Private functions
extension CatalogViewModel {
    private func fetchItems() async {
        if isLoading { return }
        isLoading = true
        
        page += 1
        await performTask { [self] in
            let res = try await api.fetchCatalog(page: page)
            allItems.accept(allItems.value + res.map { $0.cellModel })
            isLoading = false
        }
    }

    private func fetchSearchItems() async {
        await performTask { [self] in
            guard let query = searchQuery.value,
                  !query.isEmpty
            else { return searchItems.accept([]) }

            let res = try await api.fetchSearch(query: query, page: 1)
            searchItems.accept(res.map { $0.cellModel })
        }
    }
}

private extension ApiMangaModel {
    var cellModel: MangaCellViewModel {
        let res = MangaCellViewModel()
        res.prepare(with: self)
        return res
    }
}
