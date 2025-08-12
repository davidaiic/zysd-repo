//
//  WebBridgeHandlerResponse.swift
//  Basic
//
//  Created by wangteng on 2023/4/13.
//

import Foundation
import KakaJSON

class WebBridgeHandlerResponse {
    
    static let empty: [String: String] = ["data": ""]
    
    var response = [String: Any]()
    
    convenience init(value: Any) {
        self.init()
        addValue(value)
    }
    
    func addValue(_ value: Any) {
        response["data"] = value
    }
}

class WebBridgeResponse: Convertible {
    
    required init() {}
    
    enum Action: String, ConvertibleEnum {
        case unknow
        case scan
        case goLogin
        case photo
        case getUserInfo
        case share
        case saveImage
        case browserImage
        case back
        case goodsDetail
    }
 
    var value: [String: Any] = [:]
    
    var action: Action = .unknow
}
