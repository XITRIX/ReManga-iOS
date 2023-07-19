//
//  DownloadDetailsViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 08.05.2023.
//

import MvvmFoundation
import RxSwift
import RxRelay

class DownloadDetailsViewModel: BaseViewModelWith<DownloadsMangaViewModel> {
    @Injected private var downloadManager: MangaDownloadManager
    private var id: String?

    private var allChapters = [DownloadDetailsChapterViewModel]()
    let items = BehaviorRelay<[MvvmCollectionSectionModel]>(value: [])
    let deselectItems = PublishRelay<Void>()

    override func prepare(with model: DownloadsMangaViewModel) {
        id = model.id

        title.accept(model.title.value)
        guard let chaptersBinder else { return }

        bind(in: disposeBag) {
            chaptersBinder.bind { [unowned self] chapters in
                reload(with: chapters)
            }
        }
    }

    func canSelectItem(_ item: MvvmViewModel) -> Bool {
        guard let item = item as? DownloadDetailsChapterViewModel
        else { return false }

        return item.progress.value == nil || item.progress.value == 1
    }

    func itemSelected(_ item: MvvmViewModel) {
        guard let item = item as? DownloadDetailsChapterViewModel,
              (item.progress.value == nil || item.progress.value == 1),
              let index = allChapters.firstIndex(of: item)
        else { return }

        navigate(to: OfflineMangaReaderViewModel.self, with: .init(chapters: allChapters, current: Int(index)), by: .present(wrapInNavigation: false))
        deselectItems.accept(())
    }

    func deleteModel(_ model: MvvmViewModel) {
        guard let model = model as? DownloadDetailsChapterViewModel
        else { return }

        downloadManager.deleteChapter(model.id.value, of: id ?? "")
    }
}

private extension DownloadDetailsViewModel {
    var chaptersBinder: Observable<[DownloadDetailsChapterModelProtocol]>? {
        guard let detailsModel = Array(downloadManager.downloadedManga.value.values).first(where: { $0.id == (id ?? "") })
        else { return nil }

        return Observable.combineLatest(detailsModel.chapters, detailsModel.downloads).map { chapters, downloads -> [DownloadDetailsChapterModelProtocol] in
            Array(chapters.map { $0 as DownloadDetailsChapterModelProtocol }) + Array(downloads.map { $0 as DownloadDetailsChapterModelProtocol })
        }
    }

    func reload(with downloads: [DownloadDetailsChapterModelProtocol]) {
        allChapters = downloads.map { DownloadDetailsChapterViewModel(with: $0) }
            .sorted(using: KeyPathComparator(\.chapter.value, comparator: .localizedStandard))
            .sorted(using: KeyPathComparator(\.tome.value, comparator: .localizedStandard))
            .reversed()

        let section = MvvmCollectionSectionModel(id: "Chapters", style: .plain, showsSeparators: true, items: allChapters)
        items.accept([section])
    }
}
