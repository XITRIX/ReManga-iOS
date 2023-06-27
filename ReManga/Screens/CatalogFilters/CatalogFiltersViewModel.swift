//
//  CatalogFiltersViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 10.06.2023.
//

import MvvmFoundation
import RxRelay

struct CatalogFiltersModel {
    var apiKey: ContainerKey.Backend
    var filters: BehaviorRelay<[ApiMangaTag]>
}

class CatalogFiltersViewModel: BaseViewModelWith<CatalogFiltersModel> {
    var filters: BehaviorRelay<[ApiMangaTag]>!
    let selectedItems = BehaviorRelay<[IndexPath]>(value: [])
    let sections = BehaviorRelay<[MvvmCollectionSectionModel]>(value: [])
    let deselectAll = PublishRelay<Void>()

    private var api: ApiProtocol!

    override func prepare(with model: CatalogFiltersModel) {
        title.accept("Фильтры")
        api = model.apiKey.resolve()
        filters = model.filters
        Task {
            await reload()
            findSelectedFilters()
        }
    }

    override func binding() {
        bind(in: disposeBag) {
            selectedItems.bind { [unowned self] indexPaths in
                applySelection(with: indexPaths)
            }
        }
    }

    func applySelection(with indexPaths: [IndexPath]) {
        guard !sections.value.isEmpty else { return }

        var filters: [ApiMangaTag] = []
        for indexPath in indexPaths {
            // item - 1 in case header also counts as item
            guard let item = sections.value[indexPath.section].items[indexPath.item - 1] as? CatalogFilterItemViewModel
            else { continue }

            filters.append(item.tag)
        }

        if self.filters.value != filters {
            self.filters.accept(filters)
        }
    }

    func clearFilters() {
        selectedItems.accept([])
        deselectAll.accept(())
    }
}

private extension CatalogFiltersViewModel {
    func reload() async {
        state.accept(.loading)
        await performTask { [self] in
            var res: [MvvmCollectionSectionModel] = []

            let tags = try await api.fetchAllTags()
            let dict = Dictionary(grouping: tags, by: { $0.kind })

            for kind in ApiMangaTag.Kind.allCases.enumerated() {
                guard let arr = dict[kind.element] else { continue }

                let items: [MvvmViewModel] = arr.map { CatalogFilterItemViewModel(with: $0) }
                res.append(.init(id: kind.element.rawValue, header: kind.element.title, style: .sidebar, showsSeparators: true, items: items))
            }

            sections.accept(res)
            state.accept(.default)
        }
    }

    func findSelectedFilters() {
        var selected: [IndexPath] = []

        for section in sections.value.enumerated() {
            for filter in sections.value[section.offset].items.enumerated() {
                guard let filterVM = filter.element as? CatalogFilterItemViewModel,
                      let filterTag = filterVM.tag,
                      let filters,
                      filters.value.contains(filterTag)
                else { continue }

                // offset + 1 in case header also counts as item
                selected.append(.init(item: filter.offset + 1, section: section.offset))
            }
        }

//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            selectedItems.accept(selected)
//        }
    }
}

extension ApiMangaTag.Kind {
    var title: String {
        switch self {
        case .tag:
            return "Теги"
        case .type:
            return "Типы"
        case .genre:
            return "Жанры"
        case .status:
            return "Статус проекта"
        case .age:
            return "Возростной рейтинг"
        }
    }
}
