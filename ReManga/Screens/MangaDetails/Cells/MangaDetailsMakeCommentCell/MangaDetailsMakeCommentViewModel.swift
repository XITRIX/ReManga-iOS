//
//  MangaDetailsMakeCommentViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 12.06.2023.
//

import MvvmFoundation
import RxRelay

class MangaDetailsMakeCommentViewModel: MvvmViewModel {
    let commentText = BehaviorRelay<String?>(value: nil)
}
