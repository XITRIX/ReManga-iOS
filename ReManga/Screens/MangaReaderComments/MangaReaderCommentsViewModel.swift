//
//  MangaReaderCommentsViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 04.06.2023.
//

import MvvmFoundation
import RxRelay
import RxSwift

class MangaReaderCommentsViewModel: BaseViewModelWith<BehaviorRelay<[MangaDetailsCommentViewModel]>> {
    let commentText = BehaviorRelay<String?>(value: nil)
    let items = BehaviorRelay<[MvvmCollectionSectionModel]>(value: [])
    var commentVMs: BehaviorRelay<[MangaDetailsCommentViewModel]>!
    var commentsDisposalBag = DisposeBag()

    required init() {
        super.init()
        title.accept("Коментарии")
    }

    deinit {
        print("\(Self.self) deinited")
    }

    override func prepare(with model: BehaviorRelay<[MangaDetailsCommentViewModel]>) {
        commentVMs = model
    }

    override func binding() {
        bind(in: disposeBag) {
            commentVMs.bind { [unowned self] comments in
                commentsDisposalBag = DisposeBag()
                let allComments = comments.flatMap { $0.allChildren }
                allComments.forEach { comment in
                    bind(in: commentsDisposalBag) {
                        comment.expandedChanged.bind { [unowned self] _ in
                            reload(with: comments)
                        }
                    }
                }
                reload(with: comments)
            }
        }
    }

    @MainActor
    func reload(with models: [MangaDetailsCommentViewModel]) {
        var cells: [MvvmViewModel] = []
        for model in models {
            cells.append(contentsOf: model.allExpandedChildren)
        }
        let section = MvvmCollectionSectionModel(id: "Comments", style: .plain, showsSeparators: false, items: cells)
        self.items.accept([section])
    }
}
