//
//  ReMangaAuthViewController.swift
//  ReManga
//
//  Created by Даниил Виноградов on 20.04.2023.
//

import UIKit
import WebKit
import MvvmFoundation
import AuthenticationServices

class ReMangaAuthViewController<VM: OAuthViewModel>: BaseViewController<VM> {
    @IBOutlet var webView: WKWebView!
    private lazy var delegates = Delegates(parent: self)

    lazy var session = ASWebAuthenticationSession(url: URL(string: viewModel.authUrl)!, callbackURLScheme: "https") { url, error in
        print(url)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        session.presentationContextProvider = delegates
//        session.start()

        webView.navigationDelegate = delegates
        webView.load(.init(url: URL(string: viewModel.authUrl)!))
    }
}

extension ReMangaAuthViewController {
    class Delegates: DelegateObject<ReMangaAuthViewController>, WKNavigationDelegate, ASWebAuthenticationPresentationContextProviding {
        @MainActor
        func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
            guard parent.viewModel.performWebViewNavigation(from: navigationResponse.response)
            else { return decisionHandler(.allow) }

            decisionHandler(.cancel)
        }

        func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
            parent.parent!.view.window!
        }
    }
}
