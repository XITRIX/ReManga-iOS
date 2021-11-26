//
//  MainViewModel.swift
//  ReManga
//
//  Created by Даниил Виноградов on 22.11.2021.
//

import Bond
import Foundation

class MainViewModel: MvvmViewModel {
    let popular = MutableObservableCollection<[ReCatalogContent]>()
    let popularToday = MutableObservableCollection<[ReCatalogContent]>()
    let hotNews = MutableObservableCollection<[ReCatalogContent]>()
    let news = MutableObservableCollection<[ReUploadedChapterContent]>()

    private let loadCounter = Observable<Int>(0)

    required init() {
        super.init()
        title.value = "Главная"

        loadAll()
        binding()
    }

    func binding() {
        loadCounter.observeNext { [unowned self] count in
            guard count == 0 else { return }
            self.state.value = .done
        }.dispose(in: bag)
    }

    func loadAll() {
        state.value = .processing
        loadPopular()
        loadPopularToday()
        loadHotNews()
        loadNews()
    }

    func loadPopular() {
        loadCounter.value += 1
        ReClient.shared.getTopList { [weak self] result in
            guard let self = self else { return }
            self.loadCounter.value -= 1

            switch result {
            case .success(let model):
                self.popular.replace(with: model.content)
            case .failure:
                break
            }
        }
    }

    func loadPopularToday() {
        loadCounter.value += 1
        ReClient.shared.getPopularToday { [weak self] result in
            guard let self = self else { return }
            self.loadCounter.value -= 1

            switch result {
            case .success(let model):
                self.popularToday.replace(with: model.content)
            case .failure:
                break
            }
        }
    }

    func loadHotNews() {
        loadCounter.value += 1
        ReClient.shared.getPopularToday { [weak self] result in
            guard let self = self else { return }
            self.loadCounter.value -= 1

            switch result {
            case .success(let model):
                self.hotNews.replace(with: model.content)
            case .failure:
                break
            }
        }
    }

    func loadNews() {
        loadCounter.value += 1
        ReClient.shared.getNews(onlyReading: true) { [weak self] result in
            guard let self = self else { return }
            self.loadCounter.value -= 1

            switch result {
            case .success(let model):
                self.news.replace(with: model.content)
            case .failure:
                break
            }
        }
    }
}

// MARK: - Navigation
extension MainViewModel {
    func navigateTitle(_ title: String) {
        navigate(to: TitleViewModel.self, prepare: title)
    }
}