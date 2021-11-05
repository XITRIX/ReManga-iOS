//
//  NibLoadableView.swift
//  ReManga
//
//  Created by Даниил Виноградов on 04.11.2021.
//

import UIKit

class NibLoadableView: UIView, NibLoadable {
    init() {
        super.init(frame: .zero)
        defaultInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        defaultInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        defaultInit()
    }

    func defaultInit() {
        loadNib()
    }
}

