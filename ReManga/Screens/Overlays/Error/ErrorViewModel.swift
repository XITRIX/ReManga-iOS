//
//  ErrorViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 12.04.2023.
//

import MvvmFoundation
import RxRelay

class ErrorViewModel: MvvmViewModelWith<Error> {
    let error = BehaviorRelay<String?>(value: nil)

    override func prepare(with model: Error) {
        error.accept(model.localizedDescription)
    }
}
