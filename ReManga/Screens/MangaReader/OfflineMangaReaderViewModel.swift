//
//  OfflineMangaReaderViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 08.05.2023.
//

import MvvmFoundation
import RxRelay
import RxSwift

struct OfflineMangaReaderModel {
    var chapters: [DownloadDetailsChapterViewModel]
    var current: Int
}

class OfflineMangaReaderViewModel: BaseViewModelWith<OfflineMangaReaderModel>, MangaReaderViewModelProtocol {
    let isActionsAvailable = BehaviorRelay<Bool>(value: false)
    private var rawChapters: [DownloadDetailsChapterViewModel] = []
    let chapters = BehaviorRelay<[MangaDetailsChapterViewModel]>(value: [])
    let currentChapter = BehaviorRelay<Int>(value: -1)

    let pages = BehaviorRelay<[MvvmViewModel]>(value: [])

    var bookmarks = BehaviorRelay<[ApiMangaBookmarkModel]>(value: [])
    var currentBookmark = BehaviorRelay<ApiMangaBookmarkModel?>(value: nil)
    var commentsCount = BehaviorRelay<Int>(value: 0)

    let mangaNextLoaderVM = MangaReaderLoadNextViewModel()

    var current: Observable<MangaDetailsChapterViewModel?> {
        Observable.combineLatest(chapters, currentChapter).map { chapters, currentChapter in
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
        Observable.combineLatest(chapters, currentChapter).map { chapters, currentChapter in
            guard !chapters.isEmpty, currentChapter >= 0
            else { return "" }

            return "Глава " + chapters[currentChapter].chapter.value
        }
    }

    override func prepare(with model: OfflineMangaReaderModel) {
        rawChapters = model.chapters
        chapters.accept(model.chapters.map { .init(with: .init(id: "", tome: $0.tome.value, chapter: $0.chapter.value, date: .now, isReaded: true, isLiked: false, likes: 0, isAvailable: true)) })
        currentChapter.accept(model.current)
    }

    override func binding() {
        bind(in: disposeBag) {
            currentChapter.bind { [unowned self] current in
                pages.accept([])

                var items: [MvvmViewModel] = rawChapters[current].pages.value.map { MangaReaderPageViewModel(with: .init(pageModel: $0)) }
                items.append(mangaNextLoaderVM)
                pages.accept(items)
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
//        markCurrentChapterReaded()
    }

    func gotoPreviousChapter() {
        currentChapter.accept(currentChapter.value + 1)
    }

    func gotoNextChapter() {
//        markCurrentChapterReaded()
        currentChapter.accept(currentChapter.value - 1)
    }

    func showComments() {}
    func toggleLike() {}
    func selectBookmark(_ bookmark: ApiMangaBookmarkModel) {}

    private var isNextChapterAvailable: Bool {
        !chapters.value.isEmpty && currentChapter.value > 0
    }

    private func reload() {}
}
