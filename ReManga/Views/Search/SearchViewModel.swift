//
//  SearchViewModel.swift
//  REManga
//
//  Created by Даниил Виноградов on 10.03.2021.
//

import Bond
import Foundation
import Alamofire
import MVVMFoundation

struct SearchModel {
    var query: String?
    var callback: (ReSearchContent?, String?)->()
}

class SearchViewModel: MvvmViewModelWith<SearchModel> {
    let content = MutableObservableCollection<[ReSearchContent]>()
    let query = Observable<String?>("")

    private var lock = false
    private var lastRequest: DataRequest?
    private var callback: ((ReSearchContent?, String?)->())?

    required init() {
        super.init()

        query.observeNext { [unowned self] query in
            self.search(query ?? "")
        }.dispose(in: bag)
    }

    override func prepare(with item: SearchModel) {
        callback = item.callback
        query.value = item.query
    }

    private func search(_ query: String) {
        lastRequest?.cancel()
        lastRequest = ReClient.shared.getSearch(query: query, page: 1) { result in
            switch result {
            case .success(let model):
                self.content.replace(with: model.content)
            case .failure(_):
                break
            }
        }
    }

    func loadNext() {
//        page.value += 1
//        ReClient.shared.getSearch(query: query.value, page: page.value) { result in
//            switch result {
//            case .failure(let error):
//                self.setState(.failed(error))
//                break
//            case .success(let model):
//                self.setState(.done)
//
//                var temp = self.content.collection
//                temp.append(contentsOf: model.content)
//                self.content.replace(with: temp)
//                break
//            }
//        }
    }

    func dismissWithCallback() {
        dismiss() { [unowned self] in
            callback?(nil, query.value)
        }
    }

    func itemSelected(_ index: Int) {
        dismiss() { [unowned self] in
            callback?(content.collection[index], query.value)
        }
    }
}
