//
//  DownloadsViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 07.05.2023.
//

import MvvmFoundation
import RxRelay

class DownloadsViewModel: BaseViewModel {
    @Injected private var downloadManager: MangaDownloadManager
    let items = BehaviorRelay<[MvvmCollectionSectionModel]>(value: [])

    required init() {
        super.init()
        title.accept("Загрузки")
    }

    override func binding() {
        bind(in: disposeBag) {
            downloadManager.downloadedManga.bind { [unowned self] items in
                reload(with: Array(items.values))
            }
        }
    }

    func modelSelected(_ model: MvvmViewModel) {
        navigate(to: DownloadDetailsViewModel.self, by: .show)
    }
}

@MainActor
private extension DownloadsViewModel {
    func reload(with items: [MangaDownloadModel]) {
        let section = MvvmCollectionSectionModel(id: "Manga", style: .plain, showsSeparators: true, items: items.map { DownloadsMangaViewModel.init(with: $0) })
        self.items.accept([section])
    }
}
