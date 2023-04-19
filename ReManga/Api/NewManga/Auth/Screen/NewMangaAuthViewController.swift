//
//  NewMangaAuthViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 18.04.2023.
//

import UIKit
import WebKit
import MvvmFoundation

class NewMangaAuthViewController<VM: NewMangaAuthViewModel>: BaseViewController<VM> {
    @IBOutlet private var webView: WKWebView!
    private lazy var delegates = Delegates(parent: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = delegates
        webView.load(.init(url: URL(string: viewModel.authUrl)!))
    }
}

extension NewMangaAuthViewController {
    class Delegates: DelegateObject<NewMangaAuthViewController>, WKNavigationDelegate {
        func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
            if let url = navigationResponse.response.url?.absoluteString,
               url.starts(with: "https://newmanga.org/")
            {
                WKWebsiteDataStore.default().httpCookieStore.getAllCookies { [self] cookies in
                    for cookie in cookies {
                        if cookie.name == "user_session" {
                            Task { await parent.viewModel.setApiToken(cookie.value) }
                            decisionHandler(.cancel)
                            parent.dismiss(animated: true)
                            return
                        }
                    }
                    decisionHandler(.allow)
                }
            } else {
                decisionHandler(.allow)
            }
        }
    }
}
