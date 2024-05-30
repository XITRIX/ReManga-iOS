//
//  UIViewController+Extensions.swift
//  ReManga
//
//  Created by Даниил Виноградов on 12.04.2023.
//

import UIKit
import Combine

extension UIViewController {
    func smoothlyDeselectRows(in tableView: UITableView?) {
        // Get the initially selected index paths, if any
        let selectedIndexPaths = tableView?.indexPathsForSelectedRows ?? []

        // Grab the transition coordinator responsible for the current transition
        if let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: { context in
                selectedIndexPaths.forEach {
                    tableView?.deselectRow(at: $0, animated: context.isAnimated)
                }
            }) { context in
                if context.isCancelled {
                    selectedIndexPaths.forEach {
                        tableView?.selectRow(at: $0, animated: false, scrollPosition: .none)
                    }
                }
            }
        }
        else { // If this isn't a transition coordinator, just deselect the rows without animating
            selectedIndexPaths.forEach {
                tableView?.deselectRow(at: $0, animated: false)
            }
        }
    }

    func smoothlyDeselectItems(in collectionView: UICollectionView?) {
        // Get the initially selected index paths, if any
        let selectedIndexPaths = collectionView?.indexPathsForSelectedItems ?? []

        // Grab the transition coordinator responsible for the current transition
        if let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: { context in
                selectedIndexPaths.forEach {
                    collectionView?.deselectItem(at: $0, animated: context.isAnimated)
                }
            }) { context in
                if context.isCancelled {
                    selectedIndexPaths.forEach {
                        collectionView?.selectItem(at: $0, animated: false, scrollPosition: [])
                    }
                }
            }
        }
        else { // If this isn't a transition coordinator, just deselect the rows without animating
            selectedIndexPaths.forEach {
                collectionView?.deselectItem(at: $0, animated: false)
            }
        }
    }
}

// MARK: Bottom Sheet
public extension UIViewController {
    func applyBottomSheetDetents(with scrollView: UIScrollView? = nil, extra: @escaping @autoclosure () -> CGFloat = 0) -> AnyCancellable? {
#if !os(visionOS)
        guard let sheet = sheetPresentationController else { return nil }
        sheet.prefersGrabberVisible = true

        /// If UIScrollView is not presented,
        /// or iOS 16 is not available, than set default detents
        guard let scrollView,
              #available(iOS 16.0, *)
        else {
            sheet.detents = [.medium(), .large()]
            return nil
        }

        sheet.detents = [.custom(resolver: { [unowned self] context in
            let height = scrollView.contentSize.height + view.layoutMargins.top + extra()
            return min(height, context.maximumDetentValue)
        })]

        return scrollView.publisher(for: \.contentSize).sink(receiveValue: { _ in
            sheet.animateChanges {
                sheet.invalidateDetents()
            }
        })
#else
        return nil
#endif
    }

}
