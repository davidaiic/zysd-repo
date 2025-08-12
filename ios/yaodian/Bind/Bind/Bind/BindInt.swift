//
//  BindInt.swift
//  Bind
//
//  Created by wangteng on 2023/3/15.
//

import Foundation

extension Int: Bindble { }

extension Bind where T == Int {
    
    /// Random integer between two integer values.
    ///
    /// - Parameters:
    ///   - min: minimum number to start random from.
    ///   - max: maximum number random number end before.
    /// - Returns: random double between two double values.
    public static func random(between min: Int, and max: Int) -> Int {
        return Int.random(in: min...max)
    }
    
    /// Get row by colum
    ///
    ///     let row = 2.mf.rowFor(colum: 3)
    ///     print(row) // 1
    ///
    /// - Parameter colum: number of line
    public func rowFor(colum: Int) -> Int {
        if self.base == 0 || colum == 0 {
            return 0
        }
        if self.base < colum {
            return 1
        } else if self.base%colum == 0 {
            return self.base/colum
        } else {
            return self.base/colum + 1
        }
    }
}
