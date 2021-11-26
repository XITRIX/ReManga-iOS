//
//  ReaderViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 05.11.2021.
//

import Bond
import UIKit

class ReaderViewController: BaseViewController<ReaderViewModel> {
    @IBOutlet var closeButtons: [UIButton]!
    @IBOutlet var chapter: UIButton!
    @IBOutlet var prevChapterButtons: [UIButton]!
    @IBOutlet var nextChapterButtons: [UIButton]!
    @IBOutlet var bookmark: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var topBar: UIVisualEffectView!
    @IBOutlet var topBarContainer: UIView!
    @IBOutlet var bottomBar: UIVisualEffectView!
    @IBOutlet var bottomBarContainer: UIView!

    @IBOutlet var lastFrameView: UIView!
    @IBOutlet var likesLabel: UILabel!
    @IBOutlet var likeButton: UIButton!

    var _navigationBarIsHidden: Bool = false

    override var swipeAnywhereDisabled: Bool {
        true
    }

    override var hidesBottomBarWhenPushed: Bool {
        get { true }
        set {}
    }

    override func setupView() {
        super.setupView()

        navigationBarIsHidden = true

        tableView.register(cell: ReaderPageCell.self)
        tableView.delegate = self

        lastFrameView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        lastFrameView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.tableFooterView = lastFrameView

        tableView.minimumZoomScale = 0.5
        tableView.maximumZoomScale = 4
        tableView.bouncesZoom = true

        tableView.contentInset.top = topBarContainer.frame.height
        tableView.contentOffset.y = -topBarContainer.frame.height

        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleNavigationHidden)))
    }

    override func binding() {
        super.binding()

        bindingContext {
            viewModel.score.bind(to: likesLabel)
            viewModel.name.bind(to: chapter.reactive.title)

            viewModel.rated.observeNext { [unowned self] rated in
                likeButton.setImage(UIImage(systemName: rated ? "heart.fill" : "heart"), for: .normal)
            }
            
            viewModel.pages.bind(to: tableView) { (pages, indexPath, tableView) -> UITableViewCell in
                let cell = tableView.dequeue(for: indexPath) as ReaderPageCell
                cell.setModel(pages[indexPath.row])
                return cell
            }
        }

        closeButtons.forEach { $0.bind(viewModel.dismiss).dispose(in: bag) }

        prevChapterButtons.forEach {
            viewModel.prevAvailable.bind(to: $0.reactive.isEnabled).dispose(in: bag)
            $0.bind(viewModel.loadPrevChapter).dispose(in: bag)
        }

        nextChapterButtons.forEach {
            viewModel.nextAvailable.bind(to: $0.reactive.isEnabled).dispose(in: bag)
            $0.bind(viewModel.loadNextChapter).dispose(in: bag)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.contentInset.top = topBarContainer.frame.height
    }

    override func updateOverlay(_ old: UIViewController?) {
        if overlay == old { return }

        old?.remove()
        overlay?.insert(to: self, at: 2, in: view)
    }

    @objc func toggleNavigationHidden() {
        if tableView.contentOffset.y <= tableView.contentInset.top {
            return
        }

        setShowBars(!_navigationBarIsHidden)
    }

    func setShowBars(_ show: Bool) {
        _navigationBarIsHidden = show
        UIView.animate(withDuration: 0.3) {
            self.topBar.transform = CGAffineTransform(translationX: 0, y: self._navigationBarIsHidden ? -self.topBar.frame.height : 0)
            self.bottomBar.transform = CGAffineTransform(translationX: 0, y: self._navigationBarIsHidden ? self.bottomBar.frame.height : 0)

            if self._navigationBarIsHidden {
                self.tableView.scrollIndicatorInsets = .zero
            } else {
                self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: self.topBarContainer.frame.height, left: 0, bottom: self.bottomBarContainer.frame.height, right: 0)
            }
        }
    }
}

extension ReaderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let page = viewModel.pages.collection[indexPath.row]
        return (tableView.frame.width * CGFloat(page.height) / CGFloat(page.width)).rounded(.up)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let velocity = scrollView.panGestureRecognizer.velocity(in: view).y

        if velocity < -300 {
            setShowBars(true)
        } else if velocity > 1000 {
            setShowBars(false)
        }

        if scrollView.contentOffset.y <= 44 {
            setShowBars(false)
        }
    }
}
