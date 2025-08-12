//
//  MemeryStorage.swift
//  MotorFansKit_Example
//
//  Created by wangteng on 2021/9/8.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

public class MemeryStorage: NSObject, NSCacheDelegate {
    
    private var _lock: pthread_mutex_t = pthread_mutex_t()
    
    @objc public var totalCostLimit: Int = 0 {
        didSet {
            cache.totalCostLimit = totalCostLimit
        }
    }
    
    @objc public var countLimit: Int = 0 {
        didSet {
            cache.countLimit = countLimit
        }
    }
    
    /// 超出范围、进入后台、收到内存警告时 被剔除的Obj
    @objc public var willEvictObjectBlock: ((Any) -> Void)?
    
    @objc public lazy var cache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()
        cache.delegate = self
        return cache
    }()
    
    override init() {
        super.init()
        pthread_mutex_init(&_lock, nil)
    }
      
    deinit {
        pthread_mutex_destroy(&_lock)
    }
    
    public func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        willEvictObjectBlock?(obj)
    }
    
    public func withCriticalScope<T>(block: () -> T) -> T {
        pthread_mutex_lock(&_lock)
        let value = block()
        pthread_mutex_unlock(&_lock)
        return value
    }
   
}

extension MemeryStorage {
    
    public subscript(key: String) -> Any? {
        get {
            return object(forKey: key)
        }
        set {
            setObject(forKey: key, object: newValue as Any)
        }
    }
}

extension MemeryStorage: Storageable {
    
    @objc public func object(forKey key: String) -> Any? {
        return self.withCriticalScope { [weak self] in
            guard let self = self else { return nil }
            return self.cache.object(forKey: key as NSString)
        }
    }
    
    @objc public func setObject(forKey key: String, object: Any) {
        self.withCriticalScope { [weak self] in
            guard let self = self else { return }
            self.cache.setObject(object as AnyObject, forKey: key as NSString, cost: 1)
        }
    }
    
    @objc public func remove(forKey key: String) {
        self.withCriticalScope { [weak self] in
            guard let self = self else { return }
            self.cache.removeObject(forKey: key as NSString)
        }
    }
    
    @objc public func removeAll() {
        self.withCriticalScope { [weak self] in
            guard let self = self else { return }
            self.cache.removeAllObjects()
        }
    }
    
    @objc public func containsObject(forKey key: String) -> Bool {
        return self.withCriticalScope { [weak self] in
            guard let self = self else { return false }
            return self.cache.object(forKey: key as NSString) != nil
        }
    }
}
