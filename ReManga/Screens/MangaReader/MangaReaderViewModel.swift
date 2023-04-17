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
    let pages = BehaviorRelay<[ApiMangaChapterPageModel]>(value: [])

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
            Observable.combineLatest(chapters, currentChapter).bind { [unowned self] (chapters, current) in
                guard !chapters.isEmpty, current >= 0
                else { return pages.accept([]) }

                Task { await loadPages(for: chapters[current]) }
            }
        }
    }

    func gotoPreviousChapter() {
        currentChapter.accept(currentChapter.value + 1)
    }

    func gotoNextChapter() {
        currentChapter.accept(currentChapter.value - 1)
    }
}

private extension MangaReaderViewModel {
    func loadPages(for model: MangaDetailsChapterViewModel) {
        state.accept(.loading)
        performTask { [self] in
            pages.accept([])
            pages.accept(try await api.fetchChapter(id: model.id.value))
            state.accept(.default)
        }
    }
}
