//
//  Helper.swift
//  Basic
//
//  Created by wangteng on 2023/3/25.
//

import Foundation

struct Helper {
    
    static func calulateHeight(count: Int, itemHeight: CGFloat, spacing: CGFloat) -> CGFloat {
        guard count > 0 else {
            return 0
        }
        var height: CGFloat = 0
        let row = count.bind.rowFor(colum: 2)
        height += CGFloat(row)*itemHeight
        height += CGFloat(row-1)*spacing
        return height
    }
    
}
