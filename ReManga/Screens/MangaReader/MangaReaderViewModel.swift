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
    var titleVM: MangaDetailsViewModel
    var chapters: [MangaDetailsChapterViewModel]
    var current: Int
    var api: ApiProtocol
}

protocol MangaReaderViewModelProtocol: BaseViewModelProtocol {
    var isActionsAvailable: BehaviorRelay<Bool> { get }
    var chapters: BehaviorRelay<[MangaDetailsChapterViewModel]> { get }
    var currentChapter: BehaviorRelay<Int> { get }

    var current: Observable<MangaDetailsChapterViewModel?> { get }
    var pages: BehaviorRelay<[MvvmViewModel]> { get }
    var previousActionAvailable: Observable<Bool> { get }
    var nextActionAvailable: Observable<Bool> { get }
    var chapterName: Observable<String?> { get }
    var bookmarks: BehaviorRelay<[ApiMangaBookmarkModel]> { get }
    var currentBookmark: BehaviorRelay<ApiMangaBookmarkModel?> { get }
    var commentsCount: BehaviorRelay<Int> { get }
    
    func gotoPreviousChapter()
    func gotoNextChapter()
    func toggleLike()
    func selectBookmark(_ bookmark: ApiMangaBookmarkModel)
}

class MangaReaderViewModel: BaseViewModelWith<MangaReaderModel>, MangaReaderViewModelProtocol {
    var api: ApiProtocol!

    let isActionsAvailable = BehaviorRelay<Bool>(value: true)

    var titleVM: MangaDetailsViewModel!
    let chapters = BehaviorRelay<[MangaDetailsChapterViewModel]>(value: [])
    let currentChapter = BehaviorRelay<Int>(value: -1)
    let pages = BehaviorRelay<[MvvmViewModel]>(value: [])
    let mangaNextLoaderVM = MangaReaderLoadNextViewModel()
    let commentsCount = BehaviorRelay<Int>(value: 0)

    var bookmarks: BehaviorRelay<[ApiMangaBookmarkModel]> {
        titleVM.bookmarks
    }

    var currentBookmark: BehaviorRelay<ApiMangaBookmarkModel?> {
        titleVM.currentBookmark
    }

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
        api = model.api
        titleVM = model.titleVM
        chapters.accept(model.chapters)
        currentChapter.accept(model.current)
    }

    override func binding() {
        bind(in: disposeBag) {
            current.bind { [unowned self] current in
                guard let current else { return pages.accept([]) }

                loadPages(for: current)
                loadCommentsCount(for: current)
            }
            mangaNextLoaderVM.nextAvailable <- nextActionAvailable
            mangaNextLoaderVM.loadNext.bind { [unowned self] _ in
                if isNextChapterAvailable {
                    gotoNextChapter()
                } else {
                    dismiss()
                }
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

    func selectBookmark(_ bookmark: ApiMangaBookmarkModel) {
        titleVM.selectBookmark(bookmark)
    }

    func markCurrentChapterReaded() {
        guard !chapters.value.isEmpty, currentChapter.value != -1
        else { return }

        let current = chapters.value[currentChapter.value]

        guard current.isAvailable.value
        else { return }

        Task {
            try await api.markChapterRead(id: current.id.value)
            current.isReaded.accept(true)
        }
    }

    func toggleLike() {
        guard !chapters.value.isEmpty, currentChapter.value != -1
        else { return }

        let current = chapters.value[currentChapter.value]

        guard current.isAvailable.value
        else { return }
        
        Task {
            let newValue = !current.isLiked.value
            _ = try await api.setChapterLike(id: current.id.value, newValue)
            current.isLiked.accept(newValue)
            current.likes.accept(current.likes.value + (newValue ? 1 : -1))
        }
    }
}

private extension MangaReaderViewModel {
    var isNextChapterAvailable: Bool {
        !chapters.value.isEmpty && currentChapter.value > 0
    }

    func loadCommentsCount(for model: MangaDetailsChapterViewModel) {
        commentsCount.accept(0)
        Task { try await commentsCount.accept(api.fetchChapterCommentsCount(id: model.id.value)) }
    }

    func loadPages(for model: MangaDetailsChapterViewModel) {
        state.accept(.loading)
        performTask { [self] in
            pages.accept([])

            guard model.isAvailable.value else {
                state.accept(.error(ApiMangaError.needPayment(model)) { [weak self] in
                    self?.loadPages(for: model)
                })
                return
            }

            var items: [MvvmViewModel] = try await api.fetchChapter(id: model.id.value).map { MangaReaderPageViewModel(with: $0) }
            items.append(mangaNextLoaderVM)
            pages.accept(items)
            state.accept(.default)
        }
    }
}
