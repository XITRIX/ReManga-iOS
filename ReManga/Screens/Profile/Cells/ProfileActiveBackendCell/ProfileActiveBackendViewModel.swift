//
//  ProfileActiveBackendViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 10.05.2023.
//

import MvvmFoundation
import RxRelay

class ProfileActiveBackendViewModel: MvvmViewModel, MvvmSelectableProtocol {
    var selectAction: (() -> Void)?

    let detailsTitle = BehaviorRelay<String?>(value: nil)
    let backends: [ContainerKey.Backend] = [.remanga, .newmanga]

    required init() {
        super.init()
        title.accept("Главный ресурс")
    }

    override func binding() {
        bind(in: disposeBag) {
            detailsTitle <- Properties.shared.$backendKey.map { $0.title }
        }
    }

    func selectBackend(_ backend: ContainerKey.Backend) {
        Properties.shared.backendKey = backend
    }
}
