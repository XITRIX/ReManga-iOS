//
//  HistoryMangaItemViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 13.05.2023.
//

import MvvmFoundation
import RxRelay
import RxSwift

class HistoryMangaItemViewModel: MvvmViewModelWith<MangaHistoryItem>, ListViewMangaViewModelProtocol {
    var model: MangaHistoryItem?
    let image = BehaviorRelay<String?>(value: nil)
    let backendImage = BehaviorRelay<Image?>(value: nil)
    let subtitle = BehaviorRelay<String?>(value: nil)
    let hasContinueButton = BehaviorRelay<Bool>(value: true)
    let continueButtonLoading = BehaviorRelay<Bool>(value: false)

    private var continueChapterDisposeBag = DisposeBag()

    override func prepare(with model: MangaHistoryItem) {
        self.model = model
        title.accept(model.title)
        subtitle.accept(model.details)
        image.accept(model.image)
        backendImage.accept(model.apiKey.resolve().logo)
    }

    override func hash(into hasher: inout Hasher) {
        hasher.combine(image.value)
        hasher.combine(subtitle.value)
    }

    override func isEqual(to other: MvvmViewModel) -> Bool {
        guard let other = other as? Self else { return false }
        return hashValue == other.hashValue
    }

    @MainActor
    func continueReading() {
        guard let model, !continueButtonLoading.value else { return }

        continueButtonLoading.accept(true)
        let detailsVM = MangaDetailsViewModel(with: .init(id: model.id, apiKey: model.apiKey))
        detailsVM.navigationService = navigationService
        detailsVM.$isChaptersFetchingDone.bind { [unowned self] done in
            if done {
                detailsVM.continueReading(done)
                continueButtonLoading.accept(false)
                continueChapterDisposeBag = disposeBag
            }
        }.disposed(by: continueChapterDisposeBag)
    }
}
