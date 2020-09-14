//
//  DetailViewController.swift
//  GitHubSearchAPIApp
//
//  Created by thiratani on 2020/09/12.
//  Copyright © 2020 none. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class DetailViewController: UIViewController, WKUIDelegate {
    
    private var url = ""
    private var webView: WKWebView?
    
    init(searchResult: SearchResult) {
        super.init(nibName: nil, bundle: nil)
        self.url = searchResult.html_url
        self.title = searchResult.login
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWKWebView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupWKWebView() {
        let webViewConfig = WKWebViewConfiguration()
        self.webView = WKWebView(frame: .zero, configuration: webViewConfig)
        self.webView?.uiDelegate = self
        
        if let webview = self.webView {
            webview.frame = CGRect(origin: .zero, size: self.view.bounds.size)
            view = webview
        }
        loadWebView()
    }
    
    func loadWebView() {
        if let url = URL(string: self.url) {
            let request = URLRequest(url: url)
            self.webView?.load(request)
        }
    }
}

extension DetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        if (navigationAction.request.url?.absoluteString) != nil {
            decisionHandler(.allow)
            return
        }

        decisionHandler(.cancel)
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // code
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // code
    }
    
    func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
        return false
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError: Error) {
        let error = (withError as Any) as! NSError
        if (error.code == -1009) {
            let alert = UIAlertController.singleBtnAlertWithTitle(title: "ERROR".localized, message: error.localizedDescription, completion: nil)
            self.present(alert, animated: true, completion: nil)
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError: Error) {
        let error = (withError as Any) as! NSError
        let alert = UIAlertController.singleBtnAlertWithTitle(title: "ERROR".localized, message: error.localizedDescription, completion: nil)
        self.present(alert, animated: true, completion: nil)
    }
}
