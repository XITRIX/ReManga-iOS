//
//  BookmarksViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 14.05.2023.
//

import MvvmFoundation
import RxRelay
import RxSwift

struct BookmarksModel {
    var apiKey: ContainerKey.Backend
}

class BookmarksViewModel: BaseViewModelWith<BookmarksModel> {
    private let allItems = BehaviorRelay<[MangaCellViewModel]>(value: [])
    private let allBookmarksTypes = BehaviorRelay<[ApiMangaBookmarkModel]>(value: [])
    private var api: ApiProtocol!

    public let selectedBookmarkType = BehaviorRelay<ApiMangaBookmarkModel?>(value: nil)

    public var bookmarkTypes: Observable<[ApiMangaBookmarkModel]> {
        Observable.combineLatest(allBookmarksTypes, allItems).map { allTypes, allItems in
            let presentedBookmarks = allItems.compactMap { $0.bookmark.value }.unique
            return allTypes.filter { presentedBookmarks.contains($0) }
        }
    }

    public var isFilterButtonAvailable: Observable<Bool> {
        bookmarkTypes.map { $0.count > 1 }
    }

    public var items: Observable<[MangaCellViewModel]> {
        Observable.combineLatest(allItems, selectedBookmarkType).map { allItems, selectedBookmarkType in
            if selectedBookmarkType == nil { return allItems }
            return allItems.filter { $0.bookmark.value == selectedBookmarkType }
        }
    }

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
        allBookmarksTypes.accept(try await api.fetchBookmarkTypes())
        allItems.accept(models.map { .init(with: $0) })
        state.accept(.default)
    }
}
