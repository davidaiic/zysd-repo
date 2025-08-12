//
//  BasicPopItemble.swift
//  MotorFansKit
//
//  Created by wangteng on 2023/2/24.
//

import Foundation

public protocol BasicPopItemble {
    
    var height: CGFloat { get set }
    
    func configureHeight(_ configuration: BasicPopConfiguration)
}
