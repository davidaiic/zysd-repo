//
//  Storage.swift
//  MotorFansKit_Example
//
//  Created by wangteng on 2021/9/8.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation

@objc public protocol Storageable: NSObjectProtocol {
    
    // 获取缓存
    @objc func object(forKey key: String) -> Any?
    // 设置缓存
    @objc func setObject(forKey key: String, object: Any)
    // 移除单个缓存
    @objc func remove(forKey key: String)
    // 移除所有缓存
    @objc func removeAll()
    // 是否包含缓存
    @objc func containsObject(forKey key: String) -> Bool
}
