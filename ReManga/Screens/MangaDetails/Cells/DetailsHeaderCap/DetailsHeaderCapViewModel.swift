//
//  DetailsHeaderCapViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 14.04.2023.
//

import MvvmFoundation
import RxRelay

class DetailsHeaderCapViewModel: MvvmViewModel {
    let rating = BehaviorRelay<String?>(value: "--")
    let likes = BehaviorRelay<String?>(value: "--")
    let sees = BehaviorRelay<String?>(value: "--")
    let bookmarks = BehaviorRelay<String?>(value: "--")
}
