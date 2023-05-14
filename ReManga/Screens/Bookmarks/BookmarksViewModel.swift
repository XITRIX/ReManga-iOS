//
//  BookmarksViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 14.05.2023.
//

import MvvmFoundation
import RxRelay

struct BookmarksModel {
    var apiKey: ContainerKey.Backend
}

class BookmarksViewModel: BaseViewModelWith<BookmarksModel> {
    public let items = BehaviorRelay<[MangaCellViewModel]>(value: [])
    private var api: ApiProtocol!

    override func prepare(with model: BookmarksModel) {
        title.accept("Закладки")
        api = model.apiKey.resolve()
        state.accept(.loading)
    }

    override func willAppear() {
        Task { try await reload() }
    }

    func showDetails(for model: MangaCellViewModel) {
        navigate(to: MangaDetailsViewModel.self, with: .init(id: model.id.value, apiKey: api.key), by: .show)
    }
}

private extension BookmarksViewModel {
    func reload() async throws {
        let models = try await api.fetchBookmarks()
        items.accept(models.map { .init(with: $0) })
        state.accept(.default)
    }
}
