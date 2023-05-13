//
//  HistoryViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 13.05.2023.
//

import MvvmFoundation
import RxRelay

class HistoryViewModel: BaseViewModel {
    @Injected private var historyManager: MangaHistoryManager
    let sections = BehaviorRelay<[MvvmCollectionSectionModel]>(value: [])

    required init() {
        super.init()
        title.accept("История")
    }

    override func binding() {
        bind(in: disposeBag) {
            historyManager.$history.bind { [unowned self] items in
                reload(with: items.map { .init(with: $0) })
            }
        }
    }

    func itemSelected(_ item: MvvmViewModel) {
        guard let item = item as? HistoryMangaItemViewModel,
              let model = item.model
        else { return }

        navigate(to: MangaDetailsViewModel.self, with: .init(id: model.id, apiKey: model.apiKey), by: .show)
    }

    func removeItem(_ item: MvvmViewModel) {
        guard let item = item as? HistoryMangaItemViewModel,
              let model = item.model
        else { return }

        historyManager.removeItem(model)
    }
}

private extension HistoryViewModel {
    func reload(with items: [HistoryMangaItemViewModel]) {
        sections.accept([.init(id: "History", style: .plain, showsSeparators: true, items: items.reversed())])
    }
}
