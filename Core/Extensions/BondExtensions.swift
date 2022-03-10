//
//  BondExtensions.swift
//  ReManga
//
//  Created by Даниил Виноградов on 05.11.2021.
//

import Bond
import Foundation
import Kingfisher
import ReactiveKit
import UIKit

extension UIButton {
    func bind(_ action: @escaping () -> ()) -> Disposable {
        self.reactive.tap.observeNext(with: action)
    }
}

public extension MutableChangesetContainerProtocol where Changeset: OrderedCollectionChangesetProtocol, Changeset.Collection: RangeReplaceableCollection {
    /// Insert elements `newElements` at index `i`.
    func append(_ newElements: [Collection.Element]) {
        descriptiveUpdate { collection -> [Operation] in
            let index = collection.endIndex
            collection.insert(contentsOf: newElements, at: index)
            let indices = (0 ..< newElements.count).map { collection.index(index, offsetBy: $0) }
            return indices.map { Operation.insert(collection[$0], at: $0) }
        }
    }
}

// extension UIImageView: BindableProtocol {
//    public func bind(signal: Signal<String?, Never>) -> Disposable {
//        return reactive.text.bind(signal: signal)
//    }
// }

public extension ReactiveExtensions where Base: UIImageView {
    var imageUrl: Bond<URL?> {
        return bond {
            $0.kf.setImage(with: $1)
        }
    }
}

extension UIControl {
    func bindTap(_ function: @escaping () -> ()) -> Disposable {
        reactive.controlEvents(.touchUpInside).observeNext(with: function)
    }
}

extension UIBarButtonItem {
    func bindTap(_ function: @escaping () -> ()) -> Disposable {
        reactive.tap.observeNext(with: function)
    }
}
