//
//  ProfileDetailsViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 06.05.2023.
//

import MvvmFoundation
import RxRelay

class ProfileDetailsViewModel: MvvmViewModelWith<ApiProtocol> {
    private var api: ApiProtocol!
    public let items = BehaviorRelay<[MvvmCollectionSectionModel]>(value: [])

    required init() {
        super.init()
        reload()
    }

    override func prepare(with model: ApiProtocol) {
        title.accept(model.name)
        api = model
    }

    func itemSelected(_ model: MvvmViewModel) {
        guard let item = model as? MvvmSelectableProtocol
        else { return }

        item.selectAction?()
    }
}

private extension ProfileDetailsViewModel {
    func reload() {
        var items: [MvvmCollectionSectionModel] = []

        let exitButton = ProfileDetailsButtonViewModel()
        exitButton.title.accept("Выйти из профиля")
        exitButton.style.accept(.destructive)
        exitButton.selectAction = { [unowned self] in
            Task {
                try await api.deauth()
                await dismiss()
            }
        }
        items.append(.init(id: "Exit", style: .insetGrouped, showsSeparators: true, items: [exitButton]))

        self.items.accept(items)
    }
}
