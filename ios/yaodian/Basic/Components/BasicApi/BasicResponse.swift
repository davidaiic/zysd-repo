//
//  BasicResponse.swift
//  Drug
//
//  Created by wangteng on 2023/2/9.
//

import Foundation
import KakaJSON

public class BasicResponse: Convertible {
    
    required public init() { }
    
    enum BasicErrorCode: Int, CaseIterable, ConvertibleEnum {
        case notaccess = 406
        case success = 200
        case tokenInvalidate = 401
        case htmlFail = 800
    }
    
    var code: BasicErrorCode = .notaccess
    
    var data: [String: Any] = [:]
    
    var message = ""
    
    var error: NSError {
        NSError.init(domain: message, code: self.code.rawValue)
    }
}

extension NSError {
    
    var needLogin: Bool {
        code == BasicResponse.BasicErrorCode.tokenInvalidate.rawValue
    }
}

extension BasicResponse {
    
    func model<M: Convertible>(_ type: M.Type) -> M {
        return data.kj.model(type) as M
    }
    
    func model<M: Convertible>(_ type: M.Type, key: String) -> M {
        if let dict = data[key] as? [String: Any] {
            return dict.kj.model(type) as M
        }
        return type.init()
    }
  
    func modelArray<M: Convertible>(_ type: M.Type, key: String) -> [M] {
        guard let arrayJson = data[key] as? [Any] else {
            return []
        }
        return arrayJson.kj.modelArray(type)
    }
}
