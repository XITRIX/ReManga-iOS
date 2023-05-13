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
        guard let model = model as? DownloadsMangaViewModel
        else { return }

        navigate(to: DownloadDetailsViewModel.self, with: model, by: .show)
    }

    func deleteModel(_ model: MvvmViewModel) {
        guard let model = model as? DownloadsMangaViewModel
        else { return }

        downloadManager.deleteChapters(of: model.id)
    }
}

@MainActor
private extension DownloadsViewModel {
    func reload(with items: [MangaDownloadModel]) {
        let items = items.sorted(by: { $0.date.value > $1.date.value }).map { DownloadsMangaViewModel(with: $0) }
        let section = MvvmCollectionSectionModel(id: "Manga", style: .plain, showsSeparators: true, items: items)
        self.items.accept([section])
    }
}
