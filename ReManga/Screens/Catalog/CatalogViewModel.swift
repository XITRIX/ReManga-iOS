//
//  CatalogViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 07.04.2023.
//

import MvvmFoundation
import RxRelay
import RxSwift

struct CatalogViewConfig {
    var title: String
    var isSearchAvailable: Bool
    var isFiltersAvailable: Bool
    var isApiSwitchAvailable: Bool
    var filters: [ApiMangaTag]
    var apiKey: ContainerKey.Backend?

    static var `default`: CatalogViewConfig {
        .init(title: "Каталог", isSearchAvailable: true, isFiltersAvailable: true, isApiSwitchAvailable: true, filters: [], apiKey: nil)
    }
}

protocol CatalogViewModelProtocol: BaseViewModelProtocol {
    var items: Observable<[MangaCellViewModel]> { get }
    var searchQuery: BehaviorRelay<String?> { get }
    var isSearchAvailable: BehaviorRelay<Bool> { get }
    var isFiltersAvailable: BehaviorRelay<Bool> { get }
    var filters: BehaviorRelay<[ApiMangaTag]> { get }
    var sortTypes: BehaviorRelay<[ApiMangaIdModel]> { get }
    var sortType: ApiMangaIdModel? { get }

    func loadNext()
    func setSortType(_ sort: ApiMangaIdModel)
    func showDetails(for model: MangaCellViewModel)
    func showFilters()
}

class CatalogViewModel: BaseViewModelWith<CatalogViewConfig>, CatalogViewModelProtocol {
    public let allItems = BehaviorRelay<[MangaCellViewModel]>(value: [])
    public let searchItems = BehaviorRelay<[MangaCellViewModel]>(value: [])
    public let searchQuery = BehaviorRelay<String?>(value: "")
    public let isSearchAvailable = BehaviorRelay<Bool>(value: true)
    public let isFiltersAvailable = BehaviorRelay<Bool>(value: true)
    public let filters = BehaviorRelay<[ApiMangaTag]>(value: [])
    public let sortTypes = BehaviorRelay<[ApiMangaIdModel]>(value: [])
    public var sortType: ApiMangaIdModel?

    private var currentSearchTask: Task<Void, Never>?

    public var items: Observable<[MangaCellViewModel]> {
        Observable.combineLatest(allItems, searchItems).map { [unowned self] all, search in
            if searchQuery.value.isNilOrEmpty {
                return all
            }
            return search
        }
    }

    override func binding() {
        super.binding()

        if apiKey == nil {
            ($apiKey <- Properties.shared.$backendKey).disposed(by: disposeBag)
        }

        bind(in: disposeBag) {
            searchQuery.bind { [unowned self] _ in
                currentSearchTask?.cancel()
                currentSearchTask = Task {
                    await fetchSearchItems()
                }
            }

            $apiKey.bind { [unowned self] key in
                api = Mvvm.shared.container.resolve(key: key?.key)
                sortType = api.defaultSortingType
                filters.accept([])
                resetVM()
            }

            filters.throttle(.seconds(1), scheduler: MainScheduler.instance).bind { [unowned self] _ in
                resetVM()
            }
        }
    }

    override func prepare(with model: CatalogViewConfig) {
        apiKey = model.apiKey
        title.accept(model.title)
        isSearchAvailable.accept(model.isSearchAvailable)
        isFiltersAvailable.accept(model.isFiltersAvailable)
        filters.accept(model.filters)
        state.accept(.loading)
    }

    override func handleError(_ error: Error, task: (() -> Void)? = nil) {
        if (error as NSError).code == NSURLErrorCancelled { return }
        super.handleError(error, task: task)
    }

    func loadNext() {
        guard searchQuery.value.isNilOrEmpty
        else { return }

        if isLoading { return }
        isLoading = true

        currentFetchTask?.cancel()
        currentFetchTask = Task { await fetchItems() }
    }

    func showDetails(for model: MangaCellViewModel) {
        navigate(to: MangaDetailsViewModel.self, with: .init(id: model.id.value, apiKey: api.key), by: .show)
    }

    func showFilters() {
//        navigate(to: CatalogFiltersViewModel.self, with: .init(apiKey: api.key, filters: filters), by: .custom(transaction: { from, to in
//            let vc = BottomSheetController(rootViewController: to, with: .init(withDragger: true))
//            from.present(vc, animated: true)
//        }))
        navigate(to: CatalogFiltersViewModel.self, with: .init(apiKey: api.key, filters: filters), by: .present(wrapInNavigation: true))
    }

    func setSortType(_ sort: ApiMangaIdModel) {
        sortType = sort
        resetVM()
    }

    // MARK: - Private
    private var isLoading = false
    private var page = startingPage
    private var currentFetchTask: Task<Void, Never>?
    private var api: ApiProtocol = Mvvm.shared.container.resolve()
    @Binding private var apiKey: ContainerKey.Backend?
    private static let startingPage = 1
}

// MARK: - Private functions
extension CatalogViewModel {
    private func resetVM() {
        currentFetchTask?.cancel()
        currentFetchTask = nil

        state.accept(.loading)
        isLoading = false
        page = Self.startingPage
        allItems.accept([])
        sortTypes.accept([])
        
        Task { try await sortTypes.accept(api.fetchSortingTypes()) }
        loadNext()
    }

    private func fetchItems() async {
        await performTask { [self] in
            let res = try await api.fetchCatalog(page: page, filters: filters.value, sorting: sortType)
            page += 1
            try Task.checkCancellation()
            allItems.accept(allItems.value + res.map { $0.cellModel })
            isLoading = false
            currentFetchTask = nil
            state.accept(.default)
        }
    }

    private func fetchSearchItems() async {
        await performTask { [self] in
            guard let query = searchQuery.value,
                  !query.isEmpty
            else { return searchItems.accept([]) }

            let res = try await api.fetchSearch(query: query, page: 1, sorting: sortType)
            searchItems.accept(res.map { $0.cellModel })
            state.accept(.default)
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
