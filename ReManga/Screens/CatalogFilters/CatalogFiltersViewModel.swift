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
    var sections = BehaviorRelay<[MvvmCollectionSectionModel]>(value: [])

    private var api: ApiProtocol!

    override func prepare(with model: CatalogFiltersModel) {
        title.accept("Фильтры")
        api = model.apiKey.resolve()
        filters = model.filters
        reload()
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
            guard let item = sections.value[indexPath.section].items[indexPath.item] as? CatalogFilterItemViewModel
            else { continue }

            filters.append(item.tag)
        }
        self.filters.accept(filters)
    }
}

private extension CatalogFiltersViewModel {
    func reload() {
        state.accept(.loading)
        performTask { [self] in
            var res: [MvvmCollectionSectionModel] = []
            var selected: [IndexPath] = []

            let tags = try await api.fetchAllTags()
            let dict = Dictionary(grouping: tags, by: { $0.kind })

            for kind in ApiMangaTag.Kind.allCases.enumerated() {
                guard let arr = dict[kind.element] else { continue }

                var items: [MvvmViewModel] = []
                for item in arr.enumerated() {
                    items.append(CatalogFilterItemViewModel(with: item.element))

                    if filters.value.contains(item.element) {
                        selected.append(.init(item: item.offset, section: kind.offset))
                    }
                }
                res.append(.init(id: kind.element.rawValue, header: kind.element.title, style: .sidebar, showsSeparators: true, items: items))
            }

            sections.accept(res)
            state.accept(.default)
        }
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
