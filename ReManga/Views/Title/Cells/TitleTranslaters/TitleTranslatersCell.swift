//
//  TitleTranslatersCell.swift
//  ReManga
//
//  Created by Даниил Виноградов on 05.11.2021.
//

import UIKit

class TitleTranslatersCell: BaseTableViewCell {
    @IBOutlet var translatorsStack: UIStackView!

    func configure(with models: [ReTitlePublisher]) {
        translatorsStack.subviews.forEach { $0.removeFromSuperview() }

        models.forEach { model in
            let view = TitleTranslatorView()
            view.configure(with: model)
            translatorsStack.addArrangedSubview(view)
        }
    }
}
