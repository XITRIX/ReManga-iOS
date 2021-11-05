//
//  MvvmViewModelProtocol.swift
//  DemoMVVM
//
//  Created by Даниил Виноградов on 04.11.2021.
//

import Foundation
import ReactiveKit
import Bond

protocol MvvmViewModelWithProtocol: MvvmViewModelProtocol {
    associatedtype Model

    func prepare(with item: Model)
}

class MvvmViewModelWith<T>: MvvmViewModel, MvvmViewModelWithProtocol {
    typealias Model = T

    func prepare(with item: Model) {}
}
