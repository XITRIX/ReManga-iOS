//
//  DownloadDetailsChapterViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 08.05.2023.
//

import MvvmFoundation
import RxSwift
import RxRelay

protocol DownloadDetailsChapterModelProtocol {
    var id: String { get }
    var title: String? { get }
    var tome: String { get }
    var chapter: String { get }
    var pages: [ApiMangaChapterPageModel] { get }
    var progress: CGFloat? { get }
}

extension MangaChapterDownloadModel: DownloadDetailsChapterModelProtocol {
    var progress: CGFloat? { nil }
}

extension MangaProgressKeyModel: DownloadDetailsChapterModelProtocol {
    var pages: [ApiMangaChapterPageModel] { [] }
    var progress: CGFloat? { 0 }
}

class DownloadDetailsChapterViewModel: MvvmViewModelWith<DownloadDetailsChapterModelProtocol> {
    var id = BehaviorRelay<String>(value: "")
    let tome = BehaviorRelay<String>(value: "")
    let chapter = BehaviorRelay<String>(value: "")
    let progress = BehaviorRelay<CGFloat?>(value: nil)
    var pages = BehaviorRelay<[ApiMangaChapterPageModel]>(value: [])

    @Injected private var downloadManager: MangaDownloadManager

    override func prepare(with model: DownloadDetailsChapterModelProtocol) {
        id.accept(model.id)
        title.accept(model.title)
        tome.accept(model.tome)
        chapter.accept("Глава \(model.chapter)")
        pages.accept(model.pages)

        guard let model = model as? MangaProgressKeyModel,
              let progressBinder = downloadManager.progressBinder(for: model)
        else { return }

        bind(in: disposeBag) {
            progress <- progressBinder
        }
    }

    override func hash(into hasher: inout Hasher) {
        hasher.combine(tome.value)
        hasher.combine(chapter.value)
    }

    override func isEqual(to other: MvvmViewModel) -> Bool {
        guard let other = other as? Self else { return false }
        return tome.value == other.tome.value &&
            chapter.value == other.chapter.value
    }
}
