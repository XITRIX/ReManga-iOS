//
//  MangaDetailsChaptersMenuViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 23.04.2023.
//

import MvvmFoundation
import RxRelay

class MangaDetailsChaptersMenuViewModel: MvvmViewModel {
    let downloadState = BehaviorRelay<Bool>(value: false)

    func toggleDownload() {
        downloadState.accept(!downloadState.value)
    }
}
