//
//  ITuneDetail.swift
//  BootCamp
//
//  Created by esb23904 on 2023/10/12.
//

import Foundation
import UIKit
import WebKit

class ITuneDetailViewController:UIViewController {
    var url_str:String?
    var webView = WKWebView()
    let backBtn = UIButton()
    let forwardBtn = UIButton()
    var isLoading = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        layout()
        if let url_str = url_str,
           let url = URL(string: url_str) {
            let urlRequest = URLRequest(url: url)
            loading(isLoading: &isLoading)
            webView.load(urlRequest)
        }
    }
    
    func setUp() {
        let backColor = Theme.themeStlye.getBackColor()
        let textColor = Theme.themeStlye.getTextColor()
        view.layer.contents = backColor
        setUpNav(title: "ITune",backButtonVisit: true)
        webView.navigationDelegate = self
        
        backBtn.isEnabled = false
        backBtn.setTitle("上一頁", for: .normal)
        backBtn.setTitleColor(textColor, for: .normal)
        backBtn.backgroundColor = backColor
        backBtn.layer.cornerRadius = 10
        backBtn.addTarget(self, action: #selector(backAct), for: .touchUpInside)
        
        forwardBtn.isEnabled = false
        forwardBtn.setTitle("下一頁", for: .normal)
        forwardBtn.setTitleColor(textColor, for: .normal)
        forwardBtn.backgroundColor = backColor
        forwardBtn.layer.cornerRadius = 10
        forwardBtn.addTarget(self, action: #selector(nextAct), for: .touchUpInside)
    }
    
    func layout() {
        let margins = view.layoutMarginsGuide
        view.addSubviews(backBtn ,forwardBtn , webView)
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            backBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30 * Theme.factor),
            backBtn.widthAnchor.constraint(equalToConstant: 150 * Theme.factor),
            backBtn.topAnchor.constraint(equalTo: margins.topAnchor,constant: 10 * Theme.factor),
            backBtn.heightAnchor.constraint(equalToConstant: 30),
        
            forwardBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -30 * Theme.factor),
            forwardBtn.widthAnchor.constraint(equalTo: backBtn.widthAnchor),
            forwardBtn.centerYAnchor.constraint(equalTo: backBtn.centerYAnchor),
            forwardBtn.heightAnchor.constraint(equalTo: backBtn.heightAnchor),
            
            webView.topAnchor.constraint(equalTo: backBtn.bottomAnchor,constant: 10 * Theme.factor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ITuneDetailViewController {
    @objc func backAct() {
        self.webView.goBack()
        
    }
    
    @objc func nextAct() {
        self.webView.goForward()
    }
}

extension ITuneDetailViewController:WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("start load")
        loading(isLoading: &isLoading)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("load finish")
        removeLoading(isLoading: &isLoading)
        forwardBtn.isEnabled = webView.canGoForward
        backBtn.isEnabled = webView.canGoBack
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        // 針對 js window.open 開啟新分頁方式處理
        if ( navigationAction.targetFrame == nil || navigationAction.targetFrame?.isMainFrame == nil ) {
            webView.load(navigationAction.request) // 原先的載入
        }
        return nil // 不開新的webView
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        if navigationAction.shouldPerformDownload {
            decisionHandler(.download, preferences)
        }
        else if ( navigationAction.targetFrame == nil || navigationAction.targetFrame?.isMainFrame == nil) {
            decisionHandler(.cancel, preferences)
            webView.load(navigationAction.request)
        }
        else {
            decisionHandler(.allow, preferences)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if navigationResponse.canShowMIMEType {
            decisionHandler(.allow)
        } else {
            decisionHandler(.download)
        }
    }
}
