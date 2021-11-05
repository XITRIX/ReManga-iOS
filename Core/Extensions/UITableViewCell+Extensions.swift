//
//  UITableViewCell+Extensions.swift
//  DemoMVVM
//
//  Created by Даниил Виноградов on 03.11.2021.
//

import UIKit

extension UITableViewCell {
    static var nib: UINib { UINib(nibName: name, bundle: nil) }
    static var name: String { String(describing: Self.self) }
}

extension UICollectionViewCell {
    static var nib: UINib { UINib(nibName: name, bundle: nil) }
    static var name: String { String(describing: Self.self) }
}

extension UITableView {
    func register<Cell: UITableViewCell>(cell: Cell.Type) {
        register(Cell.nib, forCellReuseIdentifier: Cell.name)
    }

    func dequeue<Cell: UITableViewCell>(for indexPath: IndexPath) -> Cell {
        if let cell = dequeueReusableCell(withIdentifier: Cell.name, for: indexPath) as? Cell {
            return cell
        }
        fatalError("\(Cell.self) is not registered")
    }
}

extension UICollectionView {
    func register<Cell: UICollectionViewCell>(cell: Cell.Type) {
        register(Cell.nib, forCellWithReuseIdentifier: Cell.name)
    }

    func dequeue<Cell: UICollectionViewCell>(for indexPath: IndexPath) -> Cell {
        if let cell = dequeueReusableCell(withReuseIdentifier: Cell.name, for: indexPath) as? Cell {
            return cell
        }
        fatalError("\(Cell.self) is not registered")
    }
}
