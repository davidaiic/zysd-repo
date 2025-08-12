//
//  BasicPopCustomItem.swift
//  MotorFansKit
//
//  Created by wangteng on 2023/2/24.
//

import Foundation


@objcMembers
/// 自定义容器
public class BasicPopWrapperItem: NSObject {
    
    /// 当前高度，通过`configureHeight(:_)` 方法进行赋值 由`BasicPopConfiguration`负责调用
    public var height: CGFloat = 0
    
    /// 自定义view
    public var wrapper: UIView?
}

extension BasicPopWrapperItem: BasicPopItemble {
    
    public func configureHeight(_ configuration: BasicPopConfiguration) {
        guard let wrapper = wrapper else {
            return
        }
        height = wrapper.bounds.height
    }
}
