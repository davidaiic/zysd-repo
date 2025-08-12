//
//  ILBaseWebViewController.swift
//  yunbaolive
//
//  Created by wangteng on 2020/8/7.
//  Copyright © 2020 cat. All rights reserved.
//

import UIKit
import WebKit
import dsBridge
import Bind

extension BaseWebViewController {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let _ = gestureRecognizer as? UIScreenEdgePanGestureRecognizer, webView.canGoBack {
            return true
        }
        return false
    }
}

public class BaseWebViewController: PageViewController {
    
    lazy var sharedManager: BasicSharedManager = {
        BasicSharedManager()
    }()
    
    var bridgeHandler: ((NSDictionary)->Void)?
    
    let webDataManager = WebPrivacyViewModel()
    
    public lazy var webView: DWKWebView = {
        let top = hasWrapper ? 0 : UIScreen.bind.navigationBarHeight
        let webHight = UIScreen.bind.height-UIScreen.bind.navigationBarHeight
        let webFrame = CGRect(x: 0, y: top,
                              width: UIScreen.bind.width, height: webHight)
        let configuration = WKWebViewConfiguration()
        let webView = DWKWebView(frame: webFrame, configuration: configuration)
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()
    
    public var hasWrapper = false
    
    public var webURL: String = ""
    public var navigationTitle = ""
    public var webViewGoBack = false
    
    public convenience init(webURL: String, navigationTitle: String) {
        self.init(nibName: nil, bundle: nil)
        self.webURL = webURL
        self.navigationTitle = navigationTitle
    }
    
    public convenience init(privacyType: WebPrivacyViewModel.WebPrivacyType) {
        self.init(nibName: nil, bundle: nil)
        self.webDataManager.webPrivacyType = privacyType
    }
 
    public override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
    }
    
    private func prepare() {
        view.backgroundColor = .white
        addNavigationBarLeft()
        prepareWebView()
        loadWebData()
        updateNavigationTitle()
    }
    
    private func updateNavigationTitle() {
        
        self.navigation.item.title = navigationTitle
        
        if self.webDataManager.webPrivacyType != .unspecified {
            self.navigation.item.title = self.webDataManager.webPrivacyType.navigationTitle
        }
      
        self.navigation.bar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 17, weight: .medium)
        ]
    }
    
    func backPage(webCanGoBack: Bool = true) {
        if webCanGoBack, self.webView.canGoBack {
            self.webViewGoBack = true
            self.webView.goBack()
            return
        }
        self.webViewGoBack = false
        self.backBarButtonItemBackHandler?()
        if let navigationController = self.navigationController,
           navigationController.viewControllers.count == 1 {
            self.dismiss(animated: true) {}
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func addNavigationBarLeft() {
        
        var imageNamed = "navigation_back_white"
        if let navigationController = self.navigationController,
           navigationController.viewControllers.count == 1 {
            imageNamed = "navigation_close_white"
        }
        let buttonBlock = {
            return [BaseButton()
                .bind(.image(UIImage(named: imageNamed)))
                .bind(.contentEdgeInsets(.init(top: 0, left: 0, bottom: 0, right: 0))),
                    BaseButton()
                .bind(.title("返回"))
                .bind(.color(.white))
                .bind(.font(.systemFont(ofSize: 16)))]
        }
        navigation.item.add(buttonBlock(), position: .left) { [weak self] btn in
            guard let self = self else { return }
            if btn.titleLabel.text == "返回" {
                self.backPage(webCanGoBack: true)
            } else {
                self.backPage(webCanGoBack: false)
            }
        }
    }
    
    private func prepareWebView(){
        self.view.addSubview(webView)
        webView.navigationDelegate = self
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.addJavascriptObject(self, namespace: "")
        addWebViewObserver()
        closePopGestureRecognizer()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        webView.removeJavascriptObject("")
        removeWebViewObserver()
        openPopGestureRecognizer()
    }
    
    func loadWebData() {
        if webDataManager.webPrivacyType != .unspecified {
            webDataManager.fetchDelegate = self
            webDataManager.fetchWebData()
        } else {
            loadWebFromURL()
        }
    }
}

extension BaseWebViewController {
    
    private func loadWebFromURL() {
        guard let request = makeRequest() else {
            self.view.emptyView.show(style: .empty())
            return
        }
        
        webView.load(request)
    }
    
    private func makeRequest() -> URLRequest? {
        guard let requestURL = makeURL() else {
            return nil
        }
        let request = URLRequest(url: requestURL,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 30)
        return request
    }
    
    private func makeURL() -> URL? {
        let webURL = self.webURL
        guard !webURL.isEmpty,
              let encodeWebURL = URL(string: webURL) else {
            return nil
        }
        return encodeWebURL
    }
}

extension BaseWebViewController: CompletionDelegate {
    
    func onCompletion(_ fetch: CompletionEnum) {
        view.hideHud()
        switch fetch {
        case .onCompleted:
            self.view.emptyView.hide()
            let webPrivacyModel = self.webDataManager.webPrivacyModel
            self.webView.loadHTMLString(webPrivacyModel.content, baseURL: nil)
            self.navigation.item.title = webPrivacyModel.title
            self.navigation.bar.titleTextAttributes = [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 17, weight: .medium)
            ]
        case .failure(let failure):
            self.view.emptyView.show(failure: failure) { [weak self] in
                guard let self = self else { return }
                self.view.showHud(.custom(contentView: HudSpinner()) )
                self.webDataManager.fetchWebData()
            }
        }
    }
}

extension BaseWebViewController {
    private func loadSampleWebView() {
        let baseURL = URL.init(fileURLWithPath: Bundle.main.bundlePath)
        let htmlPath = Bundle.main.path(forResource: "js-call-native", ofType: "html")
        let htmlContent = try? NSString.init(contentsOfFile: htmlPath!, encoding: 4)
        webView.loadHTMLString(htmlContent! as String, baseURL: baseURL)
    }
}

extension BaseWebViewController {
    
    class func clearWebsiteData() {
        let websiteDataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        let modifiedSince = Date(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: modifiedSince) {
            
        }
    }
}

extension BaseWebViewController {
    
    /*
    func shareWebView() {
        
        let shareModel = BasicSharedModel(platformTypes: [.wechatSession, .wechatTimeLine])
        sharedManager.model = shareModel
        
        sharedManager.show { [weak self] _  in
//            guard let self = self else { return true }
            
            /// 分享内容
//            let content = model.value.kj.model(BasicSharedContentModel.self)
//            self.sharedManager.content = content
            
            return true
        } completion: { _ in
            
        }
    }*/
}
