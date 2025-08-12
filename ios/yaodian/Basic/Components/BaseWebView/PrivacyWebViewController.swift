//
//  PrivacyWebViewController.swift
//  Basic
//
//  Created by wangteng on 2023/4/26.
//

import UIKit

class PrivacyWebViewController: BaseWebViewController {

    var privacyType: PrivacyPop.PrivacyType = .yszc
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    convenience init(privacyType: PrivacyPop.PrivacyType) {
        self.init(nibName: nil, bundle: nil)
        self.privacyType = privacyType
        self.navigationTitle = privacyType.title
    }
    
    override func loadWebData() {
        loadPrivacy()
    }
    
    private func loadPrivacy() {
        guard
            let path = Bundle.main.path(forResource: privacyType.webPath, ofType: "geojson"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any]
        else {
            return
        }
       
        let response = json.kj.model(BasicResponse.self)
        let loadHTMLString = response.data["content"] as! String
        let baseURL = URL(fileURLWithPath: Bundle.main.bundlePath)
        webView.loadHTMLString(loadHTMLString, baseURL: baseURL)
    }
}
