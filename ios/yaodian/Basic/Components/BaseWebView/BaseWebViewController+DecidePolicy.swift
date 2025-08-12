//
//  ILWebViewController+DecidePolicy.swift
//  yunbaolive
//
//  Created by wangteng on 2020/8/15.
//  Copyright © 2020 cat. All rights reserved.
//

import UIKit
import WebKit

extension BaseWebViewController: WKNavigationDelegate {
    
    
    func addWebViewObserver() {
        webView.addObserver(self, forKeyPath: "estimatedProgress",
                            options: NSKeyValueObservingOptions.new,
                            context: nil)
        webView.addObserver(self, forKeyPath: "title",
                            options: NSKeyValueObservingOptions.new,
                            context: nil)
    }
    
    func removeWebViewObserver() {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.removeObserver(self, forKeyPath: "title")
    }
    
    public override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case "title":
            if let _ = object {
                if let webTitle = self.webView.title, !webTitle.isEmpty  {
                    self.navigation.item.title = self.webView.title
                }
                self.navigation.bar.titleTextAttributes = [
                    .foregroundColor: UIColor.white,
                    .font: UIFont.systemFont(ofSize: 17, weight: .medium)
                ]
            } else {
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            }
        case "estimatedProgress":
            break
        default:
            break
        }
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let navigationURL = navigationAction.request.url?.absoluteString,
           navigationAction.targetFrame == nil {
            decisionHandler(.allow)
            let webView = BaseWebViewController(webURL: navigationURL, navigationTitle: self.navigationTitle)
            webView.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(webView, animated: true)
            return
        }
        
        guard let isMainFrame = navigationAction.targetFrame?.isMainFrame, isMainFrame else {
            decisionHandler(.allow)
            return
        }
        guard navigationAction.sourceFrame.isMainFrame else {
            decisionHandler(.allow)
            return
        }
        guard var navigationURL = navigationAction.request.url?.absoluteString,
            navigationURL != webURL else {
                decisionHandler(.allow)
                return
        }
        
        /// 拨打电话
        if navigationURL.hasPrefix("tel:") {
            navigationURL = (navigationURL as NSString).replacingOccurrences(of: "tel:", with: "")
            UIApplication.shared.bind.tel(navigationURL)
        }
        
        decisionHandler(.allow)
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.view.emptyView.hide()
        self.webView.hideHud()
    }
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.webView.hud.top = -UIScreen.bind.navigationBarHeight*0.5
        self.webView.showHud(.custom(contentView: HudSpinner()))
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.webView.hideHud()
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
       
        self.view.hideHud()
        self.webView.hideHud()
        
//        if !webViewGoBack {
//            self.view.emptyView.show(failure: error as NSError) { [weak self] in
//                guard let self = self else { return }
//                self.loadWebData()
//            }
//        }
    }
}

