//
//  LoadingOverlayViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 07.11.2021.
//

import UIKit

class LoadingOverlayViewController: UIViewController {
    private var backgroundColor: UIColor?

    init(backgroundColor: UIColor?) {
        self.backgroundColor = backgroundColor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let color = backgroundColor {
            view.backgroundColor = color
        }
    }
}
