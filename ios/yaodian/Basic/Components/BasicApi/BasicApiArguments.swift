//
//  BasicApiArguments.swift
//  Drug
//
//  Created by wangteng on 2023/2/9.
//

import Foundation
import Alamofire

public class BasicApiArguments {
    
    public var arguments = [String: AnyObject]()
    
    lazy var globalArguments: [String: Any] = {
        var arguments = [String: Any]()
        arguments["time"] = Date().timeIntervalSince1970
        arguments["language"] = "zh-cn"
        arguments["os"] = "iOS"
        return arguments
    }()
    
    var httpHeaders: HTTPHeaders {
        var httpHeaders = HTTPHeaders()
        if let user = UserManager.shared.user {
            httpHeaders.add(name: "uid", value: user.uid)
            httpHeaders.add(name: "token", value: user.token)
        }
        return httpHeaders
    }
   
    public init() {
        appendGlobalArguments()
    }
    
    func appendGlobalArguments() {
        for (key, value) in globalArguments {
            arguments[key] = value as AnyObject
        }
    }
    
    /// Application's Version.  e.g. "1.2.0"
    var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
 
    @discardableResult
    public func addParameter(_ key: String, value: Any) -> BasicApiArguments {
        arguments[key] = value as AnyObject
        return self
    }
}

/// subscript
extension BasicApiArguments {
    
    public subscript(key: String) -> AnyObject? {
        get {
            return self.arguments[key]
        }
        set {
            self.arguments[key] = newValue as AnyObject?
        }
    }
}
