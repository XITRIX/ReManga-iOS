//
//  MainViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 22.11.2021.
//

import UIKit
import Bond

class MainViewController: BaseViewController<MainViewModel> {
    @IBOutlet var tableView: UITableView!

    override func setupView() {
        super.setupView()

        tableView.register(cell: MainTitlesCollectionCell.self)
        tableView.register(cell: MainHeaderCell.self)
        tableView.register(cell: MainTitleCell.self)

        tableView.dataSource = self
        tableView.delegate = self
    }

    override func binding() {
        super.binding()
        
        viewModel.popularToday.observeNext { [unowned self] _ in
            tableView.reloadSections([SectionItem.popular.rawValue], with: .automatic)
        }.dispose(in: bag)

        viewModel.news.observeNext { [unowned self] _ in
            tableView.reloadSections([SectionItem.news.rawValue], with: .automatic)
        }.dispose(in: bag)
    }
}

extension MainViewController {
    enum SectionItem: Int, CaseIterable {
        case top
        case popular
        case hotNews
        case news
    }
}

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        SectionItem.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch SectionItem(rawValue: section)! {
        case .top:
            return 1
        case .popular:
            return 1 + viewModel.popularToday.count
        case .hotNews:
            return 1
        case .news:
            return 1 + viewModel.news.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch SectionItem(rawValue: indexPath.section)! {
        case .top:
            return dequeueTopCell(at: indexPath)
        case .popular:
            return dequeuePopularTodayCells(at: indexPath)
        case .hotNews:
            return dequeueHotNewsCell(at: indexPath)
        case .news:
            return dequeueNewsCells(at: indexPath)
        }
    }

    func dequeueTopCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(for: indexPath) as MainTitlesCollectionCell
        viewModel.popular.bind(to: cell.collectionView) { models, indexPath, collectionView in
            let cell = collectionView.dequeue(for: indexPath) as TitleSimilarCollectionCell
            cell.setModel(models[indexPath.item])
            return cell
        }.dispose(in: cell.bag)
        cell.collectionView.reactive.selectedItemIndexPath.observeNext { [unowned self] indexPath in
            if let dir = viewModel.popular[indexPath.item].dir {
                viewModel.navigateTitle(dir)
            }
        }.dispose(in: cell.bag)
        cell.setTitle(nil)
        return cell
    }

    func dequeuePopularTodayCells(at indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeue(for: indexPath) as MainHeaderCell
            cell.configure(for: "Популярно сегодня")
            return cell
        default:
            let cell = tableView.dequeue(for: indexPath) as MainTitleCell
            cell.configure(for: viewModel.popularToday[indexPath.row - 1])
            return cell
        }
    }

    func dequeueHotNewsCell(at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(for: indexPath) as MainTitlesCollectionCell
        viewModel.hotNews.bind(to: cell.collectionView) { models, indexPath, collectionView in
            let cell = collectionView.dequeue(for: indexPath) as TitleSimilarCollectionCell
            cell.setModel(models[indexPath.item])
            return cell
        }.dispose(in: cell.bag)
        cell.collectionView.reactive.selectedItemIndexPath.observeNext { [unowned self] indexPath in
            if let dir = viewModel.hotNews[indexPath.item].dir {
                viewModel.navigateTitle(dir)
            }
        }.dispose(in: cell.bag)
        cell.setTitle("Горячие новинки")
        return cell
    }

    func dequeueNewsCells(at indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeue(for: indexPath) as MainHeaderCell
            cell.configure(for: "Свежие главы")
            return cell
        default:
            let cell = tableView.dequeue(for: indexPath) as MainTitleCell
            cell.configure(for: viewModel.news[indexPath.row - 1])
            return cell
        }
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch SectionItem(rawValue: indexPath.section)! {
        case .popular:
            let index = indexPath.row - 1
            guard index >= 0,
                  let dir = viewModel.popularToday[index].dir
            else { return }

            viewModel.navigateTitle(dir)
        case .news:
            let index = indexPath.row - 1
            guard index >= 0,
                  let dir = viewModel.news[index].dir
            else { return }

            viewModel.navigateTitle(dir)
        default:
            break
        }
    }
}
