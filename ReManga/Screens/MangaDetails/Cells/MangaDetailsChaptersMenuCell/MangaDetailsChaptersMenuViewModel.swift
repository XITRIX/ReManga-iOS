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
    let chaptersReverted = BehaviorRelay<Bool>(value: false)
    let selectAll = PublishRelay<Void>()

    func toggleDownload() {
        downloadState.accept(!downloadState.value)
    }

    func downloadButtonTap() {
        if !downloadState.value {
            downloadState.accept(true)
            return
        }
    }

    func downloadCancelTap() {
        downloadState.accept(false)
    }

    func revertChapters() {
        chaptersReverted.accept(true)
    }

    func unrevertChapters() {
        chaptersReverted.accept(false)
    }
}
