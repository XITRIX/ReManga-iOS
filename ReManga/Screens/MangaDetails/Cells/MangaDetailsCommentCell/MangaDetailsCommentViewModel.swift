//
//  MangaDetailsCommentViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 16.04.2023.
//

import MvvmFoundation
import RxRelay

class MangaDetailsCommentViewModel: BaseViewModelWith<ApiMangaCommentModel> {
    private var id: String = ""
    let name = BehaviorRelay<String?>(value: nil)
    let date = BehaviorRelay<String?>(value: nil)
    let image = BehaviorRelay<String?>(value: nil)
    let score = BehaviorRelay<Int>(value: 0)
    let moreButtonText = BehaviorRelay<String?>(value: nil)
    let content = BehaviorRelay<NSAttributedString?>(value: nil)
    let hierarchy = BehaviorRelay<Int>(value: 0)
    let isExpanded = BehaviorRelay<Bool>(value: false)
    let isPinned = BehaviorRelay<Bool>(value: false)
    let isLiked = BehaviorRelay<Bool?>(value: nil)
    let childrenCount = BehaviorRelay<Int>(value: 0)
    let children = BehaviorRelay<[MangaDetailsCommentViewModel]>(value: [])
    let expandedChanged = PublishRelay<Bool>()
    let repliesLoading = BehaviorRelay<Bool>(value: false)

    private var isLikeDislikeProcessing = false

    @Injected private var api: ApiProtocol

    override func prepare(with model: ApiMangaCommentModel) {
        id = model.id
        name.accept(model.name)
        image.accept(model.imagePath)
        score.accept(model.likes - model.dislikes)
        name.accept(model.name)
        content.accept(model.text)
        hierarchy.accept(model.hierarchy)
        isPinned.accept(model.isPinned)
        isLiked.accept(model.isLiked)
        children.accept(model.children.map { .init(with: $0) })
        childrenCount.accept(model.childrenCount)

        if model.childrenCount > 0 {
            moreButtonText.accept("Ответы (\(model.childrenCount))")
        } else {
            moreButtonText.accept(nil)
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        date.accept(dateFormatter.string(from: model.date))
    }

    override func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    override func isEqual(to other: MvvmViewModel) -> Bool {
        guard let other = other as? Self else { return false }
        return id == other.id
    }

    func toggleReplies() {
        Task {
            if !isExpanded.value,
               childrenCount.value != 0,
               children.value.isEmpty
            {
                var page = 1
                repliesLoading.accept(true)
                // TODO: Rework to support pagination
                while children.value.count < childrenCount.value {
                    let newComments: [MangaDetailsCommentViewModel] = try await api.fetchCommentsReplies(id: id, count: 20, page: page).map { .init(with: $0) }
                    newComments.forEach { $0.hierarchy.accept(hierarchy.value + 1) }
                    children.accept(children.value + newComments)
                    page += 1
                }
                repliesLoading.accept(false)
            }

            isExpanded.accept(!isExpanded.value)
            expandedChanged.accept(isExpanded.value)
        }
    }

    func toggleLike() {
        guard !isLikeDislikeProcessing else { return }
        isLikeDislikeProcessing = true

        Task {
            let oldLiked = isLiked.value
            let value = isLiked.value == true ? nil : true
            try await api.markComment(id: id, value, true)
            self.isLiked.accept(value)
            updateScore(from: oldLiked)
            isLikeDislikeProcessing = false
        }
    }

    func toggleDislike() {
        guard !isLikeDislikeProcessing else { return }
        isLikeDislikeProcessing = true

        Task {
            let oldLiked = isLiked.value
            let value = isLiked.value == false ? nil : false
            try await api.markComment(id: id, value, false)
            self.isLiked.accept(value)
            updateScore(from: oldLiked)
            isLikeDislikeProcessing = false
        }
    }
}

private extension MangaDetailsCommentViewModel {
    func updateScore(from oldLiked: Bool?) {
        let newLiked = isLiked.value
        let score = self.score.value

        if oldLiked == false && newLiked == nil {
            return self.score.accept(score + 1)
        }

        if oldLiked == false && newLiked == true {
            return self.score.accept(score + 2)
        }

        if oldLiked == nil && newLiked == true {
            return self.score.accept(score + 1)
        }

        if oldLiked == nil && newLiked == false {
            return self.score.accept(score - 1)
        }

        if oldLiked == true && newLiked == false {
            return self.score.accept(score - 2)
        }

        if oldLiked == true && newLiked == nil {
            return self.score.accept(score - 1)
        }
    }
}

extension MangaDetailsCommentViewModel {
    var allChildren: [MangaDetailsCommentViewModel] {
        var res: [MangaDetailsCommentViewModel] = []
        res.append(self)
        children.value.forEach { item in
            res.append(contentsOf: item.allChildren)
        }
        return res
    }

    var allExpandedChildren: [MangaDetailsCommentViewModel] {
        var res: [MangaDetailsCommentViewModel] = []
        res.append(self)
        if isExpanded.value {
            children.value.forEach { item in
                res.append(contentsOf: item.allExpandedChildren)
            }
        }
        return res
    }

}
