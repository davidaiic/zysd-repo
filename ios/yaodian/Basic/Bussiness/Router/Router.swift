//
//  Router.swift
//  Basic
//
//  Created by wangteng on 2023/5/7.
//

import UIKit

class Router {
    
    static let shared = Router()
    
    func route(_ url: String) {
        
        let response = RouterResponse(url: url)
        
        loginHandler(needLogin: response.needLogin) {
            switch response.type {
            /// web
            case .web(let webTitle):
                BaseWebViewController(webURL: url, navigationTitle: webTitle).bind.push()
            ///  资讯详情
            case .articleInfo(let id):
                CommentDetailController(id: id, type: .info).bind.push()
            /// 药品详情
            case .goods(let id):
                ScanningSafeController(goodsId: id).bind.push()
            case .unspecified:
                break
            }
        }
    }
    
    func loginHandler(needLogin: Bool, handler: @escaping () -> Void) {
        if needLogin {
            LoginManager.shared.loginHandler(handler)
        } else {
            handler()
        }
    }
}
