//
//  ErrorOverlayViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 10.11.2021.
//

import UIKit

class ErrorOverlayViewController: UIViewController {
    @IBOutlet var errorTitle: UILabel!
    @IBOutlet var errorMessage: UILabel!
    @IBOutlet var errorLogo: UIImageView!
    @IBOutlet var reloadButton: UIButton!

    var error: MvvmError?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let error = error {
            errorTitle.text = error.title
            errorMessage.text = error.message
            if let retryCallback = error.retryCallback {
                reloadButton.reactive.tap.observeNext(with: retryCallback).dispose(in: bag)
            }
        }
    }
}
