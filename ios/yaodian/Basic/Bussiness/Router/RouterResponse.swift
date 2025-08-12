//
//  RouterResponse.swift
//  Basic
//
//  Created by wangteng on 2023/5/7.
//

import Foundation

class RouterResponse {
    
    enum RouterType {
        /// 默认
        case unspecified
        /// webview
        case web(webTitle: String)
        ///  资讯详情
        case articleInfo(id: String)
        /// 药品详情
        case goods(id: String)
    }
    
    var url: String = ""
    
    var type: RouterType = .unspecified
    
    var needLogin = false
    
    var response: [String: String] = [:]
    
    var components: URLComponents? {
        URLComponents(string: url)
    }
    
    init(url: String) {
        self.url = url
        self.setup()
    }
    
    func setup() {
        
        guard url.hasPrefix("http"),
              let components = self.components else {
            return
        }
        
        if let queryItems = components.queryItems {
            for queryItem in queryItems {
                response[queryItem.name] = queryItem.value
            }
        }
        
        if let type = components.path.components(separatedBy: "/").last {
            switch type {
            /// 资讯详情
            case "articleInfo":
                let value = response["id"] ?? ""
                self.type = .articleInfo(id: value)
            /// 药品详情
            case "goods":
                let value = response["id"] ?? ""
                self.type = .goods(id: value)
                self.needLogin = true
            default: break
            }
        }
        
        /// web
        if !url.hasPrefix(AppKeys.universalLink) {
            type = .web(webTitle: webTitle)
        }
    }
}

extension RouterResponse {
    
    var webTitle: String {
        if let title = response["title"] {
            return title
        }
        return "识药查真伪"
    }
    
}
