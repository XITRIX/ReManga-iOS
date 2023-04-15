//
//  CatalogViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 07.04.2023.
//

import MvvmFoundation
import RxSwift
import RxRelay

struct CatalogViewConfig {
    var title: String
    var isSearchAvailable: Bool
    var filters: [ApiMangaTag]

    static var `default`: CatalogViewConfig {
        .init(title: "Каталог", isSearchAvailable: true, filters: [])
    }
}

protocol CatalogViewModelProtocol: BaseViewModelProtocol {
    var items: Observable<[MangaCellViewModel]> { get }
    var searchQuery: BehaviorRelay<String?> { get }
    var isSearchAvailable: BehaviorRelay<Bool> { get }
    var filters: BehaviorRelay<[ApiMangaTag]> { get }
    func loadNext()
    func showDetails(for model: MangaCellViewModel)
}

class CatalogViewModel: BaseViewModelWith<CatalogViewConfig>, CatalogViewModelProtocol {
    public let allItems = BehaviorRelay<[MangaCellViewModel]>(value: [])
    public let searchItems = BehaviorRelay<[MangaCellViewModel]>(value: [])
    public let searchQuery = BehaviorRelay<String?>(value: "")
    public let isSearchAvailable = BehaviorRelay<Bool>(value: true)
    public let filters = BehaviorRelay<[ApiMangaTag]>(value: [])

    public var items: Observable<[MangaCellViewModel]> {
        Observable.combineLatest(allItems, searchItems).map { [unowned self] (all, search) in
            if searchQuery.value.isNilOrEmpty {
                return all
            }
            return search
        }
    }
    
    required init() {
        super.init()

        bind(in: disposeBag) {
            searchQuery.bind { [unowned self] _ in
                _ = Task {
                    await fetchSearchItems()
                }
            }
        }
    }

    override func prepare(with model: CatalogViewConfig) {
        title.accept(model.title)
        isSearchAvailable.accept(model.isSearchAvailable)
        filters.accept(model.filters)
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
            let res = try await api.fetchCatalog(page: page, filters: filters.value)
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
