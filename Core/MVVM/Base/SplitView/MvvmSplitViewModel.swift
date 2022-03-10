//
//  MvvmSplitViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 11.12.2021.
//

import Foundation
import Bond

protocol MvvmSplitViewModelProtocol: MvvmViewModel {
    var primaryViewModel: MvvmViewModel.Type { get }
    var secondaryViewModel: MvvmViewModel.Type? { get }
}
