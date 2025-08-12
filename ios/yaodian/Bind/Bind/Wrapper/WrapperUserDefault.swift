//
//  WrapperUserDefault.swift
//  PropertyWrapper
//
//  Created by Teng Wang 王腾 on 2020/6/17.
//  Copyright © 2020 Teng Wang 王腾. All rights reserved.
//

import Foundation

@propertyWrapper
public struct UserDefaultsWrapper<T> {
    
    public let key: String
    
    public var storage: UserDefaults = .standard
    
    public var wrappedValue: T? {
        get {
            storage.value(forKey: key) as? T
        }
        set {
            if newValue == nil {
                storage.removeObject(forKey: key)
            } else {
                storage.setValue(newValue, forKey: key)
            }
        }
    }
    
    public init(key: String) {
        self.key = key
    }
}

