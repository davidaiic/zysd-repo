//
//  BindApplication.swift
//  Bind
//
//  Created by wangteng on 2023/3/4.
//

import UIKit
    
extension UIApplication: Bindble { }

extension Bind where T == UIApplication {
    
    public var documentsURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }
    
    public var documentsPath: String {
        NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
    }

    public var cachesURL: URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last!
    }
    
    public var cachesPath: String {
        NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""
    }

    public var libraryURL: URL {
        FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last!
    }

    public var libraryPath: String {
        NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first ?? ""
    }
    
    public var appBundleName: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
    }
    
    public var appBundleID: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String ?? ""
    }

    public var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
    
    public var appBuildVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
    }
    
    public func tel(_ phone: String) {
        if let url = URL.init(string: "tel://"+phone) {
            UIApplication.shared.open(url, options: [:]) { (_) in
            }
        }
    }
    
}
