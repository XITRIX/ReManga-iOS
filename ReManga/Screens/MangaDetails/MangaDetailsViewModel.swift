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

    let insetVM = MangaDetailsInsetViewModel()
    let statusVM = DetailsHeaderCapViewModel()
    let descriptionVM = MangaDetailsDescriptionTextViewModel()
    let selectorVM = MangaDetailsSelectorViewModel()
    let tagsVM = MangaDetailsTagsViewModel()
    let chaptersMenuVM = MangaDetailsChaptersMenuViewModel()

    let detail = BehaviorRelay<String?>(value: nil)
    let items = BehaviorRelay<[MvvmCollectionSectionModel]>(value: [])
    let chapters = BehaviorRelay<[MangaDetailsChapterViewModel]>(value: [])
    let translators = BehaviorRelay<[MangaDetailsTranslatorViewModel]>(value: [])
    let comments = BehaviorRelay<[MangaDetailsCommentViewModel]>(value: [])

    let bookmarks = BehaviorRelay<[ApiMangaBookmarkModel]>(value: [])
    let currentBookmark = BehaviorRelay<ApiMangaBookmarkModel?>(value: nil)

    var branch: ApiMangaBranchModel?
    var isChaptersDone = false
    var chaptersPage = 1
    var chaptersIsLoading = false

    var isCommentsDone = false
    var commentsPage = 1
    var commentsIsLoading = false
    var commentsCount: Int = 0

    var dir: String!
    var id: String!

    var downloadingTableState: BehaviorRelay<Bool> {
        chaptersMenuVM.downloadState
    }

    override func prepare(with model: String) {
        loadDetails(for: model)
    }

    override func binding() {
        super.binding()
        bind(in: disposeBag) {
            downloadingTableState.bind { [unowned self] state in
                
            }
            selectorVM.selected.bind { [unowned self] segment in
                selectSegment(segment)
            }
            tagsVM.tagSelected.bind { [unowned self] tag in
                tagSelected(tag)
            }
            chapters.bind { [unowned self] chapters in
                if selectorVM.selected.value == 1 {
                    refresh()
                }
            }
            comments.bind { [unowned self] comments in
                let allComments = comments.flatMap { $0.allChildren }
                allComments.forEach { comment in
                    bind(in: comment.disposeBag) {
                        comment.expandedChanged.bind { [unowned self] _ in
                            if selectorVM.selected.value == 2 {
                                refresh()
                            }
                        }
                    }
                }

                if selectorVM.selected.value == 2 {
                    refresh()
                }
            }
        }
    }

    func itemSelected(at indexPath: IndexPath) {
        guard !downloadingTableState.value,
              let mangaModel = items.value[indexPath.section].items[indexPath.item] as? MangaDetailsChapterViewModel
        else { return }

        let model = MangaReaderModel(titleVM: self, chapters: chapters.value, current: chapters.value.firstIndex(of: mangaModel) ?? 0)

        navigate(to: MangaReaderViewModel.self, with: model, by: .present(wrapInNavigation: false))
//        navigate(to: TestViewModel.self, by: .present(wrapInNavigation: false))
    }

    func tagSelected(_ tag: ApiMangaTag) {
        navigate(to: CatalogViewModel.self, with: .init(title: tag.name.capitalizedSentence, isSearchAvailable: false, filters: [tag]), by: .show)
    }

    func bottomReached() {
        switch selectorVM.selected.value {
        case 1:
            performTask { try await self.loadNextChapters() }
        case 2:
            performTask { try await self.loadNextComments() }
        default:
            break
        }
    }

    func selectBookmark(_ bookmark: ApiMangaBookmarkModel) {
        Task {
            let bookmark = currentBookmark.value == bookmark ? nil : bookmark
            try await api.setBookmark(title: id, bookmark: bookmark)
            currentBookmark.accept(bookmark)
        }
    }
}

private extension MangaDetailsViewModel {
    func refresh() {
        selectSegment(selectorVM.selected.value)
    }

    func selectSegment(_ segment: Int) {
        let insetSection: MvvmCollectionSectionModel = .init(id: "inset", style: .plain, showsSeparators: false, backgroundColor: .clear, items: [insetVM])
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
            items.accept([insetSection, headerSection, descriptionSection])
        case 1:
            var chaptersSection: MvvmCollectionSectionModel = .init(id: "chapters", style: .plain, showsSeparators: true, items: [])

            chaptersSection.items.append(chaptersMenuVM)
            chaptersSection.items.append(contentsOf: chapters.value)

            if !isChaptersDone {
                let loader = MangaDetailsLoadingPlaceholderViewModel()
                loader.isCompact.accept(true)
                chaptersSection.items.append(loader)
            }
            items.accept([insetSection, headerSection, chaptersSection])
        case 2:
            var commentsSection = MvvmCollectionSectionModel(id: "comments", style: .plain, showsSeparators: false, items: [])
            if !comments.value.isEmpty || commentsIsLoading {
                commentsSection.items.append(contentsOf: comments.value.flatMap { $0.allExpandedChildren })
                if !isCommentsDone {
                    let loader = MangaDetailsLoadingPlaceholderViewModel()
                    loader.isCompact.accept(true)
                    commentsSection.items.append(loader)
                }
            } else {
                commentsSection.items.append(MangaDetailsLoadingPlaceholderViewModel())
                // Several empty items to workaround wierd animation bug
                commentsSection.items.append(MangaDetailsHeaderViewModel(with: ""))
                commentsSection.items.append(MangaDetailsHeaderViewModel(with: ""))
            }
            items.accept([insetSection, headerSection, commentsSection])
        default:
            items.accept([insetSection, headerSection])
        }
    }

    func loadDetails(for id: String) {
        state.accept(.loading)
        performTask { [self] in
            let res = try await api.fetchDetails(id: id)
            title.accept(res.rusTitle ?? res.title)
            image.accept(res.img)

            self.dir = id
            self.id = res.id

            branch = res.branches.first
            try await loadNextChapters()

            do {
                bookmarks.accept(try await api.fetchBookmarks())
            } catch {}

            currentBookmark.accept(res.bookmark)

            Task {
                do {
                    commentsCount = try await api.fetchCommentsCount(id: self.id)
                    try await loadNextComments()
                } catch {
                    print(error)
                }
//                await comments.accept(try api.fetchComments(id: id, count: 30, page: commentsPage).map { .init(with: $0) })
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

    func loadNextChapters() async throws {
        guard !chaptersIsLoading, !isChaptersDone else { return }
        defer { chaptersIsLoading = false }
        chaptersIsLoading = true

        if let branch {
            let count = 30
            let chaptersRes = try await api.fetchTitleChapters(branch: branch.id, count: count, page: chaptersPage)
            isChaptersDone = chaptersRes.count != count
            chaptersPage += 1

            chapters.accept(chapters.value + chaptersRes.map { chapter in
                let res = MangaDetailsChapterViewModel()
                res.prepare(with: chapter)
                return res
            })
        }
    }

    func loadNextComments() async throws {
        guard !commentsIsLoading, !isCommentsDone else { return }
        defer { commentsIsLoading = false }
        commentsIsLoading = true

        let count = 20
        let commentsRes = try await api.fetchComments(id: id, count: count, page: commentsPage)
        commentsPage += 1

        let newValue = comments.value + commentsRes.map { .init(with: $0) }
        isCommentsDone = newValue.count >= commentsCount
        comments.accept(newValue)
    }
}
