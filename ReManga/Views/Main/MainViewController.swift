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

        viewModel.newChapters.observeNext { [unowned self] _ in
            tableView.reloadSections([SectionItem.newCapters.rawValue], with: .automatic)
        }.dispose(in: bag)
    }
}

extension MainViewController {
    enum SectionItem: Int, CaseIterable {
        case top
        case popular
        case hotNews
        case newCapters
        case newTitles
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
        case .newCapters:
            return 1 + viewModel.newChapters.count
        case .newTitles:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch SectionItem(rawValue: indexPath.section)! {
        case .top:
            return dequeueCollectionCell(at: indexPath, title: nil, with: viewModel.popular)
        case .popular:
            return dequeuePopularTodayCells(at: indexPath)
        case .hotNews:
            return dequeueCollectionCell(at: indexPath, title: "Горячие новинки", with: viewModel.hotNews)
        case .newCapters:
            return dequeueNewChaptersCells(at: indexPath)
        case .newTitles:
            return dequeueCollectionCell(at: indexPath, title: "Новая манга", with: viewModel.newTitles)
        }
    }

    func dequeueCollectionCell(at indexPath: IndexPath, title: String?, with data: MutableObservableCollection<[ReCatalogContent]>) -> UITableViewCell {
        let cell = tableView.dequeue(for: indexPath) as MainTitlesCollectionCell
        data.bind(to: cell.collectionView) { models, indexPath, collectionView in
            let cell = collectionView.dequeue(for: indexPath) as TitleSimilarCollectionCell
            cell.setModel(models[indexPath.item])
            return cell
        }.dispose(in: cell.bag)
        cell.collectionView.reactive.selectedItemIndexPath.observeNext { [unowned self] indexPath in
            if let dir = data[indexPath.item].dir {
                viewModel.navigateTitle(dir)
            }
        }.dispose(in: cell.bag)
        cell.setTitle(title)
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

    func dequeueNewChaptersCells(at indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeue(for: indexPath) as MainHeaderCell
            cell.configure(for: "Свежие главы")
            return cell
        default:
            let cell = tableView.dequeue(for: indexPath) as MainTitleCell
            cell.configure(for: viewModel.newChapters[indexPath.row - 1])
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
        case .newCapters:
            let index = indexPath.row - 1
            guard index >= 0,
                  let dir = viewModel.newChapters[index].dir
            else { return }

            viewModel.navigateTitle(dir)
        default:
            break
        }
    }
}
