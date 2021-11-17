//
//  BondExtensions.swift
//  ReManga
//
//  Created by Даниил Виноградов on 05.11.2021.
//

import Foundation
import ReactiveKit
import Bond

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
