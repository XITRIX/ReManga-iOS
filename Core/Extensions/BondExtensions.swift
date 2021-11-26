//
//  BondExtensions.swift
//  ReManga
//
//  Created by Даниил Виноградов on 05.11.2021.
//

import Foundation
import ReactiveKit
import Kingfisher
import Bond
import UIKit

extension UIButton {
    func bind(_ action: @escaping () -> ()) -> Disposable {
        self.reactive.tap.observeNext(with: action)
    }
}

extension MutableChangesetContainerProtocol where Changeset: OrderedCollectionChangesetProtocol, Changeset.Collection: RangeReplaceableCollection {
    /// Append `newElement` at the end of the collection.
    public func append(_ newElements: [Collection.Element]) {
        newElements.forEach { append($0) }
    }
}

//extension UIImageView: BindableProtocol {
//    public func bind(signal: Signal<String?, Never>) -> Disposable {
//        return reactive.text.bind(signal: signal)
//    }
//}

extension ReactiveExtensions where Base: UIImageView {
    public var imageUrl: Bond<URL?> {
        return bond {
            $0.kf.setImage(with: $1)
        }
    }
}

extension UIControl {
    func bindTap(_ function: @escaping ()->()) -> Disposable {
        reactive.controlEvents(.touchUpInside).observeNext(with: function)
    }
}

extension UIBarButtonItem {
    func bindTap(_ function: @escaping ()->()) -> Disposable {
        reactive.tap.observeNext(with: function)
    }
}

