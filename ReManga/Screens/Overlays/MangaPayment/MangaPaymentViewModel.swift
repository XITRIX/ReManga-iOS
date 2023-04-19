//
//  MangaPaymentViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 18.04.2023.
//

import MvvmFoundation
import RxRelay
import RxSwift

class MangaPaymentViewModel: BaseViewModelWith<(MangaDetailsChapterViewModel, (() -> Void)?)> {
    @Injected private var api: ApiProtocol
    private var model: MangaDetailsChapterViewModel!
    private var completion: (()->Void)?

    var cost: Observable<String> {
        model.price.map { "Стоимость \($0 ?? "")" }
    }

    override func prepare(with model: (MangaDetailsChapterViewModel, (() -> Void)?)) {
        self.model = model.0
        self.completion = model.1
    }

    @MainActor
    func pay() {
        state.accept(.loading)
        performTask { [self] in
            try await api.buyChapter(id: model.id.value)
            completion?()
            state.accept(.default)
        }
    }
}
