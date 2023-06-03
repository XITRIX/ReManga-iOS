//
//  MangaDetailsViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 13.04.2023.
//

import MvvmFoundation
import RxRelay

struct MangaDetailsModel {
    var id: String
    var apiKey: ContainerKey.Backend
}

class MangaDetailsViewModel: BaseViewModelWith<MangaDetailsModel> {
    enum Id: String {
        case inset
        case header
        case description
        case chapters
        case comments
    }

    var api: ApiProtocol!
    @Injected var downloadManager: MangaDownloadManager
    @Injected var historyManager: MangaHistoryManager

    let image = BehaviorRelay<String?>(value: nil)

    let insetVM = MangaDetailsInsetViewModel()
    let statusVM = DetailsHeaderCapViewModel()
    let descriptionVM = MangaDetailsDescriptionTextViewModel()
    let selectorVM = MangaDetailsSelectorViewModel()
    let tagsVM = MangaDetailsTagsViewModel()
    let chaptersMenuVM = MangaDetailsChaptersMenuViewModel()
    let similarsVM = MangaDetailsTitleSimilarsViewModel()

    let detail = BehaviorRelay<String?>(value: nil)
    let items = BehaviorRelay<[MvvmCollectionSectionModel]>(value: [])
    let chapters = BehaviorRelay<[MangaDetailsChapterViewModel]>(value: [])
    let translators = BehaviorRelay<[MangaDetailsTranslatorViewModel]>(value: [])
    let comments = BehaviorRelay<[MangaDetailsCommentViewModel]>(value: [])

    let currentChapter = BehaviorRelay<ApiMangaChapterModel?>(value: nil)
    let selectedItems = BehaviorRelay<[IndexPath]>(value: [])

    let bookmarks = BehaviorRelay<[ApiMangaBookmarkModel]>(value: [])
    let currentBookmark = BehaviorRelay<ApiMangaBookmarkModel?>(value: nil)

    var branch: ApiMangaBranchModel?
    var chaptersPage = 1
    var chaptersIsLoading = false
    @Binding var isChaptersFetchingDone = false

    var isCommentsFetchingDone = false
    var commentsPage = 1
    var commentsIsLoading = false
    var commentsCount: Int = 0

    var dir: String!
    var id: String!

    var downloadingTableState: BehaviorRelay<Bool> {
        chaptersMenuVM.downloadState
    }

    override func prepare(with model: MangaDetailsModel) {
        api = model.apiKey.resolve()
        loadDetails(for: model.id)
    }

    override func binding() {
        super.binding()
        bind(in: disposeBag) {

            chaptersMenuVM.selectAll.bind { [unowned self] _ in
                guard let id = items.value.firstIndex(where: { $0.id == Id.chapters.rawValue })
                else { return }

                selectedItems.accept(chapters.value.enumerated().map { .init(item: $0.offset, section: id) })
            }

            chaptersMenuVM.downloadSelected.bind { [unowned self] _ in
                let chapters = selectedItems.value.compactMap { items.value[$0.section].items[$0.item] as? MangaDetailsChapterViewModel }
                Task { try await downloadManager.downloadChapters(api: api, manga: self, chapters: chapters) }
            }

            downloadingTableState.bind { [unowned self] state in
                refresh()
            }
            chaptersMenuVM.chaptersReverted.bind { [unowned self] _ in
                refresh()
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
            similarsVM.selected.bind { [unowned self] id in
                navigate(to: MangaDetailsViewModel.self, with: .init(id: id, apiKey: api.key), by: .show)
            }
        }
    }

    func itemSelected(at indexPath: IndexPath) {
        guard !downloadingTableState.value,
              let mangaModel = items.value[indexPath.section].items[indexPath.item] as? MangaDetailsChapterViewModel
        else { return }

        let model = MangaReaderModel(titleVM: self, chapters: chapters.value, current: chapters.value.firstIndex(of: mangaModel) ?? 0, api: api)

        navigate(to: MangaReaderViewModel.self, with: model, by: .present(wrapInNavigation: false))
    }

    func tagSelected(_ tag: ApiMangaTag) {
        navigate(to: CatalogViewModel.self, with: .init(title: tag.name.capitalizedSentence, isSearchAvailable: false, isApiSwitchAvailable: false, filters: [tag]), by: .show)
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

    func shouldSelectModel(_ model: MvvmViewModel) -> Bool {
        guard let chapter = model as? MangaDetailsChapterViewModel,
              downloadingTableState.value
        else { return true }

        return chapter.loadingProgress.value == nil && chapter.unlockedValue != false
    }

    func continueReading() {
        guard isChaptersFetchingDone else { return }

        if let historyItem = historyManager.history.first(where: { $0.id == dir && $0.apiKey == api.key }) {
            let model = MangaReaderModel(titleVM: self, chapters: chapters.value, current: chapters.value.firstIndex(where: { $0.id.value == historyItem.chapterId }) ?? 0, api: api)

            navigate(to: MangaReaderViewModel.self, with: model, by: .present(wrapInNavigation: false))
            return
        }

        if let current = currentChapter.value {
            let model = MangaReaderModel(titleVM: self, chapters: chapters.value, current: chapters.value.firstIndex(where: { $0.id.value == current.id }) ?? 0, api: api)

            navigate(to: MangaReaderViewModel.self, with: model, by: .present(wrapInNavigation: false))
            return
        }

        let model = MangaReaderModel(titleVM: self, chapters: chapters.value, current: 0, api: api)
        navigate(to: MangaReaderViewModel.self, with: model, by: .present(wrapInNavigation: false))
    }
}

private extension MangaDetailsViewModel {
    func refresh() {
        selectSegment(selectorVM.selected.value)
    }

    func selectSegment(_ segment: Int) {
        let insetSection: MvvmCollectionSectionModel = .init(id: Id.inset.rawValue, style: .plain, showsSeparators: false, backgroundColor: .clear, items: [insetVM])
        var headerSection: MvvmCollectionSectionModel = .init(id: Id.header.rawValue, style: .plain, showsSeparators: false, backgroundColor: .systemBackground, items: [statusVM])

        if !downloadingTableState.value {
            headerSection.items.append(selectorVM)
        }

        var sections: [MvvmCollectionSectionModel] = [insetSection, headerSection]
        switch segment {
        case 0:
            var descriptionSection: MvvmCollectionSectionModel = .init(id: Id.description.rawValue, style: .plain, showsSeparators: false, items: [])
            if !(descriptionVM.text.value?.string.isEmpty ?? true) {
                descriptionSection.items.append(descriptionVM)
            }
            if !tagsVM.tags.value.isEmpty {
                descriptionSection.items.append(MangaDetailsHeaderViewModel(with: "Теги"))
                descriptionSection.items.append(tagsVM)
            }
            if !translators.value.isEmpty {
                descriptionSection.items.append(MangaDetailsHeaderViewModel(with: "Переводчики"))
                translators.value.forEach { descriptionSection.items.append($0) }
            }
            if !similarsVM.similars.value.isEmpty {
                descriptionSection.items.append(MangaDetailsHeaderViewModel(with: "Похожее"))
                descriptionSection.items.append(similarsVM)
            }
            sections.append(descriptionSection)
            items.accept(sections)
        case 1:
            var chaptersSection: MvvmCollectionSectionModel = .init(id: Id.chapters.rawValue, style: .plain, showsSeparators: true, items: [])

            chaptersSection.items.append(chaptersMenuVM)
            chaptersSection.items.append(contentsOf: chaptersMenuVM.chaptersReverted.value ? chapters.value.reversed() : chapters.value)

            if !isChaptersFetchingDone {
                let loader = MangaDetailsLoadingPlaceholderViewModel()
                loader.isCompact.accept(true)
                chaptersSection.items.append(loader)
            }
            sections.append(chaptersSection)
            items.accept(sections)
        case 2:
            var commentsSection = MvvmCollectionSectionModel(id: Id.comments.rawValue, style: .plain, showsSeparators: false, items: [])
            if !comments.value.isEmpty || commentsIsLoading {
                commentsSection.items.append(contentsOf: comments.value.flatMap { $0.allExpandedChildren })
                if !isCommentsFetchingDone {
                    let loader = MangaDetailsLoadingPlaceholderViewModel()
                    loader.isCompact.accept(true)
                    commentsSection.items.append(loader)
                }
            } else {
                commentsSection.items.append(MangaDetailsLoadingPlaceholderViewModel())
                
                /// WORKAROUND: -  Several empty items to workaround wierd animation bug
                commentsSection.items.append(MangaDetailsHeaderViewModel(with: ""))
                commentsSection.items.append(MangaDetailsHeaderViewModel(with: ""))
            }
            sections.append(commentsSection)
            items.accept(sections)
        default:
            items.accept(sections)
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

            currentChapter.accept(res.continueChapter)

            branch = res.branches.first
            try await loadNextChapters()

            similarsVM.similars.accept(try await api.fetchSimilarTitles(id: id))

            do {
                bookmarks.accept(try await api.fetchBookmarkTypes())
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
        guard !chaptersIsLoading, !isChaptersFetchingDone else { return }
        defer {
            chaptersIsLoading = false
            Task {
                guard !isChaptersFetchingDone else { return }
                try await loadNextChapters()
            }
        }
        chaptersIsLoading = true

        if let branch {
            let count = 30
            let chaptersRes = try await api.fetchTitleChapters(branch: branch.id, count: count, page: chaptersPage)
            isChaptersFetchingDone = chaptersRes.count != count
            chaptersPage += 1

            chapters.accept(chapters.value + chaptersRes.map { chapter in
                let res = MangaDetailsChapterViewModel()
                res.prepare(with: chapter)
                downloadManager.bindChapterToDownloadManager(chapter: res, of: self, from: api)
                return res
            })
        }
    }

    func loadNextComments() async throws {
        guard !commentsIsLoading, !isCommentsFetchingDone else { return }
        defer { commentsIsLoading = false }
        commentsIsLoading = true

        let count = 20
        let commentsRes = try await api.fetchComments(id: id, count: count, page: commentsPage)
        commentsPage += 1

        let newValue = comments.value + commentsRes.map { .init(with: $0) }
        isCommentsFetchingDone = newValue.count >= commentsCount
        comments.accept(newValue)
    }
}
