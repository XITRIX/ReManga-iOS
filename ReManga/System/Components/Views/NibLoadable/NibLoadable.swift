//
//  NibLoadable.swift
//  ReManga
//
//  Created by Даниил Виноградов on 04.11.2021.
//

import UIKit

protocol NibLoadable: UIView {
    func loadNib()
}

extension NibLoadable {
    func loadNib() {
        let viewType = type(of: self)
        let viewName = String(describing: viewType)
        let bundle = Bundle(for: viewType)
        let nib = UINib(nibName: viewName, bundle: bundle)
        if let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            addSubview(nibView)
            nibView.frame = bounds
            nibView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
    }
}
