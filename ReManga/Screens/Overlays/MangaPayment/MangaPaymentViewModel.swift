//
//  MangaPaymentViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 18.04.2023.
//

import MvvmFoundation
import RxRelay
import RxSwift

struct MangaPaymentModel {
    var mangaVM: MangaDetailsChapterViewModel
    var completion: (() -> Void)?
    var api: ApiProtocol
}

class MangaPaymentViewModel: BaseViewModelWith<MangaPaymentModel> {
    private var api: ApiProtocol!
    private var model: MangaDetailsChapterViewModel!
    private var completion: (()->Void)?

    var cost: Observable<String> {
        model.price.map { "Стоимость \($0 ?? "")" }
    }

    override func prepare(with model: MangaPaymentModel) {
        self.api = model.api
        self.model = model.mangaVM
        self.completion = model.completion
    }

    @MainActor
    func pay() {
        state.accept(.loading)
        performTask { [self] in
            try await api.buyChapter(id: model.id.value)
            model.isAvailable.accept(true)
            completion?()
            state.accept(.default)
        }
    }
}
