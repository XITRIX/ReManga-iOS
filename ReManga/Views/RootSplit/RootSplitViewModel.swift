//
//  RootSplitViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 11.12.2021.
//

import Foundation

class RootSplitViewModel: MvvmViewModel, MvvmSplitViewModelProtocol {
    var primaryViewModel: MvvmViewModel.Type { RootTabsViewModel.self }
    var secondaryViewModel: MvvmViewModel.Type?
}
