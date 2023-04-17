//
//  MangaReaderViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 15.04.2023.
//

import MvvmFoundation
import RxSwift
import RxRelay

struct MangaReaderModel {
    var chapters: [MangaDetailsChapterViewModel]
    var current: Int
}

class MangaReaderViewModel: BaseViewModelWith<MangaReaderModel> {
    @Injected var api: ApiProtocol
    let chapters = BehaviorRelay<[MangaDetailsChapterViewModel]>(value: [])
    let currentChapter = BehaviorRelay<Int>(value: -1)
    let pages = BehaviorRelay<[MvvmViewModel]>(value: [])
    let mangaNextLoaderVM = MangaReaderLoadNextViewModel()

    var current: Observable<MangaDetailsChapterViewModel?> {
        Observable.combineLatest(chapters, currentChapter).map { (chapters, currentChapter) in
            guard !chapters.isEmpty, currentChapter >= 0
            else { return nil }

            return chapters[currentChapter]
        }
    }

    var previousActionAvailable: Observable<Bool> {
        Observable.combineLatest(chapters, currentChapter).map { !$0.0.isEmpty && $0.1 < $0.0.count - 1 }
    }

    var nextActionAvailable: Observable<Bool> {
        Observable.combineLatest(chapters, currentChapter).map { !$0.0.isEmpty && $0.1 > 0 }
    }

    var chapterName: Observable<String?> {
        Observable.combineLatest(chapters, currentChapter).map { (chapters, currentChapter) in
            guard !chapters.isEmpty, currentChapter >= 0
            else { return "" }
            
            return chapters[currentChapter].chapter.value
        }
    }

    override func prepare(with model: MangaReaderModel) {
        chapters.accept(model.chapters)
        currentChapter.accept(model.current)
    }

    override func binding() {
        bind(in: disposeBag) {
            current.bind { [unowned self] current in
                guard let current else { return pages.accept([]) }

                loadPages(for: current)
            }
            mangaNextLoaderVM.loadNext.bind { [unowned self] _ in
                gotoNextChapter()
            }
        }
    }

    override func willDisappear() {
        markCurrentChapterReaded()
    }

    func gotoPreviousChapter() {
        currentChapter.accept(currentChapter.value + 1)
    }

    func gotoNextChapter() {
        markCurrentChapterReaded()
        currentChapter.accept(currentChapter.value - 1)
    }

    func markCurrentChapterReaded() {
        guard !chapters.value.isEmpty, currentChapter.value != -1
        else { return }

        let current = chapters.value[currentChapter.value]
        Task {
            try await api.markChapterRead(id: current.id.value)
            current.isReaded.accept(true)
        }
    }

    func toggleLike() {
        guard !chapters.value.isEmpty, currentChapter.value != -1
        else { return }

        let current = chapters.value[currentChapter.value]
        Task {
            let newValue = !current.isLiked.value
            _ = try await api.setChapterLike(id: current.id.value, newValue)
            current.isLiked.accept(newValue)
            current.likes.accept(current.likes.value + (newValue ? 1 : -1))
        }
    }
}

private extension MangaReaderViewModel {
    func loadPages(for model: MangaDetailsChapterViewModel) {
        state.accept(.loading)
        performTask { [self] in
            pages.accept([])
            var items: [MvvmViewModel] = try await api.fetchChapter(id: model.id.value).map { MangaReaderPageViewModel(with: $0) }
            if !chapters.value.isEmpty && currentChapter.value > 0 {
                items.append(mangaNextLoaderVM)
            }
            pages.accept(items)
            state.accept(.default)
        }
    }
}
