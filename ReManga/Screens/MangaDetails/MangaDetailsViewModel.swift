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

    let id: String
    var style: Style
    var showsSeparators: Bool
    var backgroundColor: UIColor? = .clear
    var items: [MvvmViewModel]

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: MvvmCollectionSectionModel, rhs: MvvmCollectionSectionModel) -> Bool {
        lhs.id == rhs.id &&
        lhs.style == rhs.style &&
        lhs.showsSeparators == rhs.showsSeparators &&
        lhs.backgroundColor == rhs.backgroundColor
    }
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
    let translators = BehaviorRelay<[MangaDetailsTranslatorViewModel]>(value: [])
    let comments = BehaviorRelay<[MangaDetailsCommentViewModel]?>(value: nil)

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
            tagsVM.tagSelected.bind { [unowned self] tag in
                Task { await tagSelected(tag) }
            }
            comments.bind { [unowned self] comments in
                let allComments = comments?.flatMap { $0.allChildren }
                allComments?.forEach { comment in
                    bind(in: comment.disposeBag) {
                        comment.expandedChanged.bind { [unowned self] _ in
                            if selectorVM.selected.value == 2 {
                                Task { await refresh() }
                            }
                        }
                    }
                }


                if selectorVM.selected.value == 2 {
                    Task { await refresh() }
                }
            }
        }
    }

    func itemSelected(at indexPath: IndexPath) {
        guard let model = items.value[indexPath.section].items[indexPath.item] as? MangaDetailsChapterViewModel
        else { return }

        navigate(to: MangaReaderViewModel.self, with: model, by: .present(wrapInNavigation: true))
    }

    func tagSelected(_ tag: ApiMangaTag) {
        navigate(to: CatalogViewModel.self, with: .init(title: tag.name.capitalizedSentence, isSearchAvailable: false, filters: [tag]), by: .show)
    }
}

private extension MangaDetailsViewModel {
    func refresh() {
        selectSegment(selectorVM.selected.value)
    }

    func selectSegment(_ segment: Int) {
        let headerSection: MvvmCollectionSectionModel = .init(id: "header", style: .plain, showsSeparators: false, items: [statusVM, selectorVM])
        switch segment {
        case 0:
            var descriptionSection: MvvmCollectionSectionModel = .init(id: "description", style: .plain, showsSeparators: false, items: [])
            if !(descriptionVM.text.value?.string.isEmpty ?? true) {
                descriptionSection.items.append(descriptionVM)
            }
            if !tagsVM.tags.value.isEmpty {
                descriptionSection.items.append(tagsVM)
            }
            if !translators.value.isEmpty {
                descriptionSection.items.append(MangaDetailsHeaderViewModel(with: "Переводчики"))
                translators.value.forEach { descriptionSection.items.append($0) }
            }
            items.accept([headerSection, descriptionSection])
        case 1:
            let chaptersSection: MvvmCollectionSectionModel = .init(id: "chapters", style: .plain, showsSeparators: true, items: chapters.value)
            items.accept([headerSection, chaptersSection])
        case 2:
            var commentsSection = MvvmCollectionSectionModel(id: "comments", style: .plain, showsSeparators: false, items: [])
            if let comments = comments.value {


                commentsSection.items.append(contentsOf: comments.flatMap { $0.allExpandedChildren })

                
            } else {
                commentsSection.items.append(MangaDetailsLoadingPlaceholderViewModel())
                // Several empty items to workaround wierd animation bug
                commentsSection.items.append(MangaDetailsHeaderViewModel(with: ""))
                commentsSection.items.append(MangaDetailsHeaderViewModel(with: ""))
            }
            items.accept([headerSection, commentsSection])
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
                let chaptersRes = try await api.fetchTitleChapters(branch: branch.id)
                chapters.accept(chaptersRes.map { chapter in
                    let res = MangaDetailsChapterViewModel()
                    res.prepare(with: chapter)
                    return res
                })
            }

            Task {
                await comments.accept(try api.fetchComments(id: id).map { .init(with: $0) })
            }

            statusVM.rating.accept(res.rating)
            statusVM.likes.accept(res.likes)
            statusVM.sees.accept(res.sees)
            statusVM.bookmarks.accept(res.bookmarks)

//            titleVM.title.accept(title.value)
            detail.accept(res.subtitle)
            descriptionVM.text.accept(res.description)

            let tags = res.genres + res.tags

            tagsVM.tags.accept(tags.map { tag in
                let res = MangaDetailsTagViewModel()
                res.tag.accept(tag)
                return res
            })

            translators.accept(res.branches.flatMap { $0.translators }.map { .init(with: $0) })

            refresh()
            state.accept(.default)
        }
    }
}
