//
//  ErrorViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 12.04.2023.
//

import MvvmFoundation
import RxRelay

class ErrorViewModel: MvvmViewModelWith<(Error, (() -> Void)?)> {
    let error = BehaviorRelay<String?>(value: nil)
    var task = BehaviorRelay<(() -> Void)?>(value: nil)

    override func prepare(with model: (error: Error, task: (() -> Void)?)) {
        error.accept(model.error.localizedDescription)
        task.accept(model.task) 
    }
}
