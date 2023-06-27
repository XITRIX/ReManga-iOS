//
//  MangaReaderPageViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 17.04.2023.
//

import MvvmFoundation
import RxRelay

struct MangaReaderPageModel {
    var pageModel: ApiMangaChapterPageModel
    var api: ApiProtocol?
}

class MangaReaderPageViewModel: MvvmViewModelWith<MangaReaderPageModel> {
    var api: ApiProtocol?
    let imageSize = BehaviorRelay<CGSize>(value: .zero)
    let imageUrl = BehaviorRelay<String?>(value: nil)

    override func prepare(with model: MangaReaderPageModel) {
        api = model.api
        imageSize.accept(model.pageModel.size)
        if api != nil {
            imageUrl.accept(model.pageModel.path)
        } else {
            imageUrl.accept(MangaDownloadManager.imageLocalPath.appending(path: model.pageModel.path).absoluteString)
        }
    }
}
