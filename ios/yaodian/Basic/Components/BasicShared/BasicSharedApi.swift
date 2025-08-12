//
//  BasicSharedApi.swift
//  Basic
//
//  Created by wangteng on 2023/4/13.
//

import Foundation

class BasicSharedApi {
    
    enum ShareType {
        case comment(String)
        case info(String)
        case campare(String)
        
        var type: Int {
            switch self {
            case .comment:
                return 1
            case .info:
                return 2
            case .campare:
                return 3
            }
        }
    }
    
    static func content(type: ShareType, completion: @escaping (BasicSharedContentModel?) -> Void) {
        
        var thirdId = ""
        switch type {
        case .comment(let identify):
            thirdId = identify
        case .info(let identify):
            thirdId = identify
        case .campare(let identify):
            thirdId = identify
        }
        
        BasicApi("plugin/appShare")
            .addParameter(key: "type", value: type.type)
            .addParameter(key: "thirdId", value: thirdId)
            .perform { res in
            switch res {
            case .success(let response):
                let content = response.model(BasicSharedContentModel.self)
                completion(content)
            case .failure(let failure):
                completion(nil)
                Toast.showMsg(failure.domain)
            }
        }
    }
}
