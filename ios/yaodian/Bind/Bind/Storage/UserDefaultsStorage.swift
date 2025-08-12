//
//  UserDefaultStorage.swift
//  MotorFansKit_Example
//
//  Created by wangteng on 2021/9/8.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

public class UserDefaultsStorage: NSObject {
    
    private var _lock: pthread_mutex_t = pthread_mutex_t()
   
    private lazy var userDefault: UserDefaults = {
        UserDefaults.standard
    }()
    
    override init() {
        super.init()
        pthread_mutex_init(&_lock, nil)
    }
      
    deinit {
        pthread_mutex_destroy(&_lock)
    }
    
    public func withCriticalScope<T>(block: () -> T) -> T {
        pthread_mutex_lock(&_lock)
        let value = block()
        pthread_mutex_unlock(&_lock)
        return value
    }
}

extension UserDefaultsStorage {
    
    public subscript(key: String) -> Any? {
        get {
            return object(forKey: key)
        }
        set {
            setObject(forKey: key, object: newValue as Any)
        }
    }
}

extension UserDefaultsStorage: Storageable {
    
    @objc public func object(forKey key: String) -> Any? {
        return self.withCriticalScope { [weak self] in
            guard let self = self else { return nil }
            return self.userDefault.value(forKey: key)
        }
    }
    
    @objc public func setObject(forKey key: String, object: Any) {
        self.withCriticalScope { [weak self] in
            guard let self = self else { return }
            self.userDefault.setValue(object, forKey: key)
        }
    }
    
    @objc public func remove(forKey key: String) {
        self.withCriticalScope { [weak self] in
            guard let self = self else { return }
            self.userDefault.removeObject(forKey: key)
        }
    }
    
    @objc public func removeAll() {
        
    }
    
    @objc public func containsObject(forKey key: String) -> Bool {
        self.withCriticalScope { [weak self] in
            guard let self = self else { return false}
            return self.userDefault.value(forKey: key) != nil
        }
    }
}
