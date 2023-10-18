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
    var url_string:String?
    
    var obs = [NSKeyValueObservation]()
    lazy var webView:WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.allowsInlineMediaPlayback = true
        webConfiguration.defaultWebpagePreferences.allowsContentJavaScript = true
        webConfiguration.allowsAirPlayForMediaPlayback = true
        webConfiguration.allowsPictureInPictureMediaPlayback = true
        
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.allowsBackForwardNavigationGestures = true
        webView.allowsLinkPreview = true
        
        
        
        obs.append(webView.observe(\.canGoBack, options: [.new], changeHandler: { [weak self] (_,change) in
            guard let self = self else { return }
            self.backButton.isEnabled = change.newValue ?? false
        }))
        
        obs.append(webView.observe(\.canGoForward, options: [.new], changeHandler: { [weak self] (_,change) in
            guard let self = self else { return }
            self.forwardButton.isEnabled = change.newValue ?? false
        }))
        return webView
    }()
    let backButton = UIButton()
    let forwardButton = UIButton()
    var IsLoading = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        layout()
        view.backgroundColor = userData.getMainColor()
        if let url_str = url_string,
           let url = URL(string: url_str) {
            let urlRequest = URLRequest(url: url)
            loading(isLoading: &IsLoading)
            webView.load(urlRequest)
        }
        else {
            let alertAction = UIAlertAction(title: "確認", style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.leftButtonAction()
            }
            showAlert(alertText: "錯誤", alertMessage: "URL轉換失敗\nURL:\(url_string ?? "")", alertAction: alertAction)
        }
    }
    
    override func viewWillTerminate() {
        super.viewWillTerminate()
        obs.removeAll()
    }
    
    func setUp() {
        let mainColor = userData.getMainColor()
        let secondColor = userData.getSecondColor()
        //view.backgroundColor = mainColor
        setUpNavigation(title: "ITune",backButtonVisit: true)
        webView.navigationDelegate = self
        
        backButton.isEnabled = false
        backButton.setTitle("上一頁", for: .normal)
        backButton.setTitleColor(mainColor, for: .normal)
        backButton.backgroundColor = secondColor
        backButton.layer.cornerRadius = 10
        backButton.addTarget(self, action: #selector(backAct), for: .touchUpInside)
        
        forwardButton.isEnabled = false
        forwardButton.setTitle("下一頁", for: .normal)
        forwardButton.setTitleColor(mainColor, for: .normal)
        forwardButton.backgroundColor = secondColor
        forwardButton.layer.cornerRadius = 10
        forwardButton.addTarget(self, action: #selector(nextAct), for: .touchUpInside)
    }
    
    func layout() {
        let margins = view.layoutMarginsGuide
        view.addSubviews(backButton ,forwardButton , webView)
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30 * Theme.factor),
            backButton.widthAnchor.constraint(equalToConstant: 150 * Theme.factor),
            backButton.topAnchor.constraint(equalTo: margins.topAnchor,constant: 10 * Theme.factor),
            backButton.heightAnchor.constraint(equalToConstant: 30),
        
            forwardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -30 * Theme.factor),
            forwardButton.widthAnchor.constraint(equalTo: backButton.widthAnchor),
            forwardButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            forwardButton.heightAnchor.constraint(equalTo: backButton.heightAnchor),
            
            webView.topAnchor.constraint(equalTo: backButton.bottomAnchor,constant: 10 * Theme.factor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
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
        if error.asAFError?.responseCode == NSURLErrorCancelled { return }
        let action = UIAlertAction(title: "確認", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.leftButtonAction() // 返回上一頁
        }
        
        showAlert(alertText: "錯誤", alertMessage: "載入頁面失敗", alertAction: (webView.canGoBack) ? nil : action)
        removeLoading(isLoading: &self.IsLoading)
        
        print(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("start load")
        loading(isLoading: &IsLoading)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("load finish")
        removeLoading(isLoading: &IsLoading)
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        // 針對 js window.open 開啟新分頁方式處理
        if ( navigationAction.targetFrame == nil || navigationAction.targetFrame?.isMainFrame == nil ) {
            webView.load(navigationAction.request) // 原先的載入
        }
        return nil // 不開新的webView
    }
    
    // 決定網頁是否允許跳轉
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
    
    // 收到網頁 Response 決定是否跳轉
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if navigationResponse.canShowMIMEType {
            decisionHandler(.allow)
            forwardButton.isEnabled = webView.canGoForward
            backButton.isEnabled = webView.canGoBack
        } else {
            decisionHandler(.download)
        }
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        // 一律信任網站 ( 可能要有憑證做檢查 )
        let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        DispatchQueue.global(qos: .background).async {
            completionHandler(.useCredential, cred)
        }
    }
}
