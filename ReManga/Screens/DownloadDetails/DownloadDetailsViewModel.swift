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
        
        bind(in: disposeBag) {
            downloadManager.downloadedManga.bind { [unowned self] downloads in
                reload(with: Array(downloads.values))
            }
        }
    }

    func itemSelected(_ item: MvvmViewModel) {
        guard let item = item as? DownloadDetailsChapterViewModel,
              let index = allChapters.firstIndex(of: item)
        else { return }

        navigate(to: OfflineMangaReaderViewModel.self, with: .init(chapters: allChapters, current: Int(index)), by: .present(wrapInNavigation: false))
        deselectItems.accept(())
    }
}

private extension DownloadDetailsViewModel {
    func reload(with downloads: [MangaDownloadModel]) {
        let models = downloads.first(where: { $0.id == (id ?? "") })?.chapters.value ?? []
        allChapters = models.map { DownloadDetailsChapterViewModel(with: $0) }
        allChapters.sort { l, r in
            if l.tome.value == r.tome.value {
                return l.chapter.value > r.chapter.value
            }
            return l.tome.value > r.tome.value
        }
        let section = MvvmCollectionSectionModel(id: "Chapters", style: .plain, showsSeparators: true, items: allChapters)
        items.accept([section])
    }
}
