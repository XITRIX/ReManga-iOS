//
//  DetailsTitleHeaderViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 13.04.2023.
//

import MvvmFoundation
import RxRelay

class DetailsTitleHeaderViewModel: MvvmViewModel {
    let detail = BehaviorRelay<String?>(value: nil)
}
