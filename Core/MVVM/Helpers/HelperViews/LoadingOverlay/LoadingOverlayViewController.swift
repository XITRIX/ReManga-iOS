//
//  LoadingOverlayViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 07.11.2021.
//

import UIKit

class LoadingOverlayViewController: UIViewController {
    var backgroundColor: UIColor?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let color = backgroundColor {
            view.backgroundColor = color
        }
    }
}
