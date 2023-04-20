//
//  ReMangaAuthViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 20.04.2023.
//

import UIKit
import WebKit
import MvvmFoundation

class ReMangaAuthViewController<VM: ReMangaAuthViewModel>: BaseViewController<VM> {
    @IBOutlet var webView: WKWebView!
    private lazy var delegates = Delegates(parent: self)

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = delegates
        webView.load(.init(url: URL(string: viewModel.authUrl)!))
    }
}

extension ReMangaAuthViewController {
    class Delegates: DelegateObject<ReMangaAuthViewController>, WKNavigationDelegate {
        func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
            if let url = navigationResponse.response.url?.absoluteString,
               url.starts(with: "https://remanga.org/social?code=")
            {
                guard let code = navigationResponse.response.url?.queryParameters?["code"]
                else { return decisionHandler(.allow) }

                Task {
                    decisionHandler(.cancel)
                    await parent.viewModel.fetchToken(code: code)
                }
            } else {
                decisionHandler(.allow)
            }
        }
    }
}

private extension URL {
    var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}
