//
//  BaseViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 12.04.2023.
//

import MvvmFoundation
import RxRelay

enum ViewModelState {
    case `default`
    case loading
    case error(Error)
}

protocol BaseViewModelProtocol: MvvmViewModelProtocol {
    var state: BehaviorRelay<ViewModelState> { get }

    func performTask(_ task: @escaping () async throws -> Void) async
    func handleError(_ error: Error) async
}

@MainActor
class BaseViewModel: MvvmViewModel, BaseViewModelProtocol {
    let state = BehaviorRelay<ViewModelState>(value: .default)

    func performTask(_ task: @escaping () async throws -> Void) {
         Task {
            do {
                try await task()
            } catch {
                handleError(error)
            }
        }
    }

    func performTask(_ task: @escaping () async throws -> Void) async {
        do {
            try await task()
        } catch {
            handleError(error)
        }
    }

    open func handleError(_ error: Error) {
        state.accept(.error(error))
    }
}

class BaseViewModelWith<Model>: BaseViewModel, MvvmViewModelWithProtocol {
    func prepare(with model: Model) { }
}
