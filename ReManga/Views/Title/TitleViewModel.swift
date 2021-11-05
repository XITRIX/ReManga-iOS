//
//  TitleViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 04.11.2021.
//

import Bond
import Foundation

class TitleViewModel: MvvmViewModelWith<String> {
    var sectionSelected = Observable<SectionItem>(.about)

    var props: ReTitleProps?

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

    let similar = MutableObservableCollection<[ReSimilarContent]>()
    let chapters = MutableObservableCollection<[ReBranchContent]>()

    let descriptionShorten = Observable<Bool>(true)

    override func prepare(with item: String) {
        branch.observeNext { [unowned self] brunch in
            if let brunch = brunch {
                loadBrunch(brunch)
            }
        }.dispose(in: bag)

        loadTitle(item)
        loadSimilar(item)
    }

    //MARK: - Public
    func navigateTitle(_ title: String) {
        navigate(to: TitleViewModel.self, prepare: title)
    }

    func navigateChapter(_ id: Int) {
        let params = ReaderViewModelParams(chapterId: id, chapters: chapters.collection)
        navigate(to: ReaderViewModel.self, prepare: params)
    }

    func navigateCatalog(_ model: CatalogModel) {
        navigate(to: CatalogViewModel.self, prepare: model)
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
    func loadTitle(_ title: String) {
        ReClient.shared.getTitle(title: title) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let model):
                self.setModel(model.content)
                self.loaded.value = true
            case .failure:
                break
            }
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
    }
}
