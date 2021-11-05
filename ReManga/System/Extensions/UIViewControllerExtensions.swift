//
//  UIViewControllerExtensions.swift
//  ReManga
//
//  Created by Даниил Виноградов on 05.11.2021.
//

import UIKit

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
}
