//
//  KeJson.swift
//  Drug
//
//  Created by wangteng on 2023/2/9.
//

import Foundation

extension Dictionary: BindCompatible {
    public typealias T = Value
}

public extension BindGeneric where Base == [String: T] {
    
    func toJsonString() -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []),
              let string = String(data: data, encoding: .utf8) else {
            return nil
        }
        return string
    }
}


