//
//  BookmarksFilterHeaderViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 06.06.2023.
//

import MvvmFoundation
import RxRelay

class BookmarksFilterHeaderViewModel: MvvmViewModel {
    let filtersList = BehaviorRelay<[ApiMangaBookmarkModel]>(value: [])
    let selectedFilter = BehaviorRelay<ApiMangaBookmarkModel?>(value: nil)
    let blurAlpha = BehaviorRelay<CGFloat>(value: 0)
}
