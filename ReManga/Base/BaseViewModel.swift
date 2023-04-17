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
    case error(Error, (() -> Void)? = nil)
}

protocol BaseViewModelProtocol: MvvmViewModelProtocol {
    var state: BehaviorRelay<ViewModelState> { get }

    func performTask(_ task: @escaping () async throws -> Void) async
    func handleError(_ error: Error, task: (() -> Void)?) async
}

extension BaseViewModelProtocol {
    func handleError(_ error: Error, task: (() -> Void)? = nil) async {
        await handleError(error, task: task)
    }
}

@MainActor
class BaseViewModel: MvvmViewModel, BaseViewModelProtocol {
    let state = BehaviorRelay<ViewModelState>(value: .default)

    func performTask(_ task: @escaping () async throws -> Void) {
        Task {
            do {
                try await task()
            } catch {
                await handleError(error) { [weak self] in
                    self?.performTask {
                        self?.state.accept(.loading)
                        try await task()
                    }
                }
            }
        }
    }

    func performTask(_ task: @escaping () async throws -> Void) async {
        do {
            try await task()
        } catch {
            await handleError(error) { [weak self] in
                self?.performTask {
                    self?.state.accept(.loading)
                    try await task()
                }
            }
        }
    }

    open func handleError(_ error: Error, task: (() -> Void)? = nil) {
        state.accept(.error(error, task))
    }
}

class BaseViewModelWith<Model>: BaseViewModel, MvvmViewModelWithProtocol {
    func prepare(with model: Model) {}
}
