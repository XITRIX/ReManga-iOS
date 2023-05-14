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
    var model: MangaDetailsChapterViewModel!
    private var completion: (()->Void)?

    var cost: Observable<String> {
        model.price.map { [unowned self] in
            "Стоимость \($0 ?? "")\nНа вашем счету \(api.profile.value?.currency ?? "")"
        }
    }

    override func prepare(with model: MangaPaymentModel) {
        self.api = model.api
        self.model = model.mangaVM
        self.completion = model.completion
    }

    @MainActor
    func pay() {
//        navigate(to: MvvmAlertViewModel.self, with: .init(title: "Подтверждение оплаты", message: "С вашего счёта будет списано \(model.price.value ?? "")"), by: .present(wrapInNavigation: false))
        state.accept(.loading)
        performTask { [self] in
            if try await api.buyChapter(id: model.id.value) {
                model.isAvailable.accept(true)
                Task { await api.refreshUserInfo() }
            }
            completion?()
            state.accept(.default)
        }
    }
}
