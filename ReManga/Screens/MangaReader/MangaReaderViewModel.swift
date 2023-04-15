//
//  MangaReaderViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 15.04.2023.
//

import MvvmFoundation
import RxRelay

class MangaReaderViewModel: BaseViewModelWith<MangaDetailsChapterViewModel> {
    @Injected var api: ApiProtocol
    let pages = BehaviorRelay<[ApiMangaChapterPageModel]>(value: [])

    override func prepare(with model: MangaDetailsChapterViewModel) {
        loadPages(for: model)
    }
}

private extension MangaReaderViewModel {
    func loadPages(for model: MangaDetailsChapterViewModel) {
        state.accept(.loading)
        performTask { [self] in
            pages.accept(try await api.fetchChapter(id: model.id.value))
            state.accept(.default)
        }
    }
}
