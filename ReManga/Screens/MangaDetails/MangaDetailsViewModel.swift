//
//  MangaDetailsViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 13.04.2023.
//

import MvvmFoundation
import RxRelay

struct MvvmCollectionSectionModel: Hashable {
    enum Style {
        case plain
        case grouped
        case insetGrouped
    }

    var style: Style
    var showsSeparators: Bool
    var backgroundColor: UIColor? = .clear
    var items: [MvvmViewModel]
}

class MangaDetailsViewModel: BaseViewModelWith<String> {
    @Injected var api: ApiProtocol
    let image = BehaviorRelay<String?>(value: nil)
//    let titleVM = DetailsTitleHeaderViewModel()

    let statusVM = DetailsHeaderCapViewModel()
    let descriptionVM = MangaDetailsDescriptionTextViewModel()
    let selectorVM = MangaDetailsSelectorViewModel()
    let tagsVM = MangaDetailsTagsViewModel()

    let detail = BehaviorRelay<String?>(value: nil)
    let items = BehaviorRelay<[MvvmCollectionSectionModel]>(value: [])
    let chapters = BehaviorRelay<[MangaDetailsChapterViewModel]>(value: [])

    override func prepare(with model: String) {
        loadDetails(for: model)
//        items.accept([.init(style: .plain, showsSeparators: true, items: [statusVM, selectorVM])])
    }

    override func binding() {
        super.binding()
        bind(in: disposeBag) {
            selectorVM.selected.bind { [unowned self] segment in
                Task { await selectSegment(segment) }
            }
        }
    }

    func refresh() {
        selectSegment(selectorVM.selected.value)
    }

    func selectSegment(_ segment: Int) {
        let headerSection: MvvmCollectionSectionModel = .init(style: .plain, showsSeparators: false, items: [statusVM, selectorVM])
        switch segment {
        case 0:
            let descriptionSection: MvvmCollectionSectionModel = .init(style: .plain, showsSeparators: false, items: [tagsVM, descriptionVM])
            items.accept([headerSection, descriptionSection])
        case 1:
            let chaptersSection: MvvmCollectionSectionModel = .init(style: .plain, showsSeparators: true, items: chapters.value)
            items.accept([headerSection, chaptersSection])
        default:
            items.accept([headerSection])
        }
    }

    func loadDetails(for id: String) {
        state.accept(.loading)
        performTask { [self] in
            let res = try await api.fetchDetails(id: id)
            title.accept(res.rusTitle ?? res.title)
            image.accept(res.img)

            if let branch = res.branches.first {
                let chaptersRes = try await api.fetchTitleChapters(branch: branch.id, count: branch.count)
                chapters.accept(chaptersRes.map { chapter in
                    let res = MangaDetailsChapterViewModel()
                    res.prepare(with: chapter)
                    return res
                })
            }

            statusVM.rating.accept(res.rating)
            statusVM.likes.accept(res.likes)
            statusVM.sees.accept(res.sees)
            statusVM.bookmarks.accept(res.bookmarks)

//            titleVM.title.accept(title.value)
            detail.accept(res.subtitle)
            descriptionVM.title.accept(res.description)

            tagsVM.tags.accept(res.tags.map { tag in
                let res = MangaDetailsTagViewModel()
                res.title.accept(tag)
                return res
            })

            refresh()
            state.accept(.default)
        }
    }
}
