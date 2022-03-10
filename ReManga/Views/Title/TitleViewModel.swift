//
//  TitleViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 04.11.2021.
//

import Bond
import Foundation

class TitleViewModel: MvvmViewModelWith<String> {
    let sectionSelected = Observable<SectionItem>(.about)

    let id = Observable<Int?>(nil)
    let rusName = Observable<String?>(nil)
    let enName = Observable<String?>(nil)
    let info = Observable<String?>(nil)
    let image = Observable<URL?>(nil)
    let rating = Observable<String?>(nil)
    let branch = Observable<Int?>(nil)
    let branches = MutableObservableCollection<[ReTitleBranch]>()
    let totalVotes = Observable<String?>(nil)
    let totalViews = Observable<String?>(nil)
    let countBookmarks = Observable<String?>(nil)
    let description = Observable<NSAttributedString?>(nil)
    let categories = MutableObservableCollection<[ReTitleStatus]>()
    let publishers = MutableObservableCollection<[ReTitlePublisher]>()
    let continueChapter = Observable<ReTitleChapter?>(nil)
    let firstChapter = Observable<ReTitleChapter?>(nil)
    let bookmark = Observable<String?>(nil)
    let loaded = Observable<Bool>(false)

    let similar = MutableObservableCollection<[ReCatalogContent]>()
    let chapters = MutableObservableCollection<[ReBranchContent]>()

    let descriptionShorten = Observable<Bool>(true)
    let readingStatus = Observable<String>("")
    let readingStatusDetails = Observable<String?>(nil)

    let comments = MutableObservableCollection<[ReCommentsContent]>()

    private var props: ReTitleProps?
    private var commentsPage = 1
    private var commentsId: Int?

    override func prepare(with item: String) {
        branch.observeNext { [unowned self] brunch in
            if let brunch = brunch {
                loadBrunch(brunch)
            }
        }.dispose(in: bag)

        load(item)
    }

    //MARK: - Public
    func navigateTitle(_ title: String) {
        navigate(to: TitleViewModel.self, prepare: title)
    }

    func navigateChapter(_ id: Int) {
        let params = ReaderViewModelParams(chapterId: id, chapters: chapters.collection)
        navigate(to: ReaderViewModel.self, prepare: params, with: .modal(wrapInNavigation: false))
    }

    func navigateCatalog(_ model: CatalogModel) {
        navigate(to: CatalogViewModel.self, prepare: model)
    }

    func navigateCurrentChapter() {
        if let firstChapter = firstChapter.value,
            let id = firstChapter.id {
            let model = ReaderViewModelParams(chapterId: id, chapters: nil)
            navigate(to: ReaderViewModel.self, prepare: model)
        } else if let continueChapter = continueChapter.value,
                  let id = continueChapter.id {
            let model = ReaderViewModelParams(chapterId: id, chapters: nil)
            navigate(to: ReaderViewModel.self, prepare: model)
        }
    }
}

extension TitleViewModel {
    enum SectionItem: Int {
        case about
        case chapters
        case comments
    }
}

private extension TitleViewModel {
    func load(_ title: String) {
        loadTitle(title) { [weak self] result in
            guard let self = self,
                  let model = try? result.get()
            else { return }

            self.commentsId = model.content.id
            self.loadComments()
        }
        loadSimilar(title)
    }

    func loadTitle(_ title: String, completion: ((Result<ReTitleModel, HttpClientError>)->())? = nil) {
        state.value = .processing
        ReClient.shared.getTitle(title: title) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let model):
                self.props = model.props
                self.setModel(model.content)
                self.loaded.value = true
                self.state.value = .done
            case .failure(let error):
                self.state.value = .error(.init(error, retryCallback: {
                    self.load(title)
                }))
            }
            completion?(result)
        }
    }

    func loadSimilar(_ title: String) {
        ReClient.shared.getSimilar(title: title) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let model):
                self.similar.replace(with: model.content)
            case .failure:
                break
            }
        }
    }

    func loadBrunch(_ branch: Int) {
        ReClient.shared.getBranch(branch: branch) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .failure(_):
                break
            case .success(let model):
                self.chapters.replace(with: model.content)
            }
        }
    }

    func loadComments() {
        guard let commentsId = commentsId else { return }
        ReClient.shared.getTitleComments(titleId: commentsId, page: commentsPage) { result in
            switch result {
            case .success(let model):
                self.comments.append(model.content)
                self.commentsPage += 1
            case .failure(_):
                break
            }
        }
    }

    func setModel(_ model: ReTitleContent) {
        descriptionShorten.value = true

        id.value = model.id
        rusName.value = model.rusName
        enName.value = model.enName
        rating.value = "\(model.avgRating.text) (голосов: \(model.countRating.text))"
        info.value = "\((model.type?.name).text) \(model.issueYear.text) \((model.status?.name).text)"
        totalVotes.value = model.totalVotes?.cropText()
        totalViews.value = model.totalViews?.cropText()
        countBookmarks.value = model.countBookmarks?.cropText()
        description.value = model.contentDescription?.htmlAttributedString()
        categories.replace(with: model.categories ?? [])
        publishers.replace(with: model.publishers ?? [])
        branches.replace(with: model.branches ?? [])
        continueChapter.value = model.continueReading
        firstChapter.value = model.firstChapter
        if let bookmarkType = model.bookmarkType {
            bookmark.value = props?.bookmarkTypes?[bookmarkType].name
        }
        if bookmark.value == nil {
            bookmark.value = "Добавить в закладки"
        }

        if let img = model.img?.high {
            image.value = URL(string: ReClient.baseUrl + img)
        }
        if let _branch = model.activeBranch ?? model.branches?.first?.id {
            branch.value = _branch
        }

        if model.firstChapter != nil {
            readingStatus.value = "Читать"
        } else if model.continueReading != nil {
            readingStatus.value = "Продолжить"
        } else {
            readingStatus.value = "Прочитано"
        }

        readingStatusDetails.value = model.continueReading != nil ? "Том \((model.continueReading!.tome).text) Глава \((model.continueReading!.chapter).text)" : nil
    }
}
