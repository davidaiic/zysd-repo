//
//  BasicPopActiontItem.swift
//  MotorFansKit
//
//  Created by wangteng on 2023/2/24.
//

import Foundation

@objcMembers
public class BasicPopActionItem: NSObject {
    
    @objc public enum BasicPopActionDirection: Int {
        case vertical
        case horizontal
    }
    
    /// 当前高度，通过`configureHeight(:_)` 方法进行赋值 由`BasicPopConfiguration`负责调用
    public var height: CGFloat = 0
    
    /// 按钮标题
    public var titles: [String] = []
    
    /// 按钮排列方向 默认 `horizontal`
    public var direction: BasicPopActionDirection = .horizontal
    
    /// 按钮个性化回掉
    public var configureHandler: ((UIButton) -> Void)?
   
    /// 按钮点击回掉
    public var handler: ((Int) -> Bool)?
    
    /// 只有一个按钮时左右尺寸
    public var spacingLeftRight: CGFloat = 40
    
    /// 单个按钮高度
    public var actionHeight: CGFloat = 40
}

extension BasicPopActionItem: BasicPopItemble {
    
    public func configureHeight(_ configuration: BasicPopConfiguration) {
        guard !titles.isEmpty else {
            return
        }
        switch direction {
        case .horizontal:
            height = actionHeight
        case .vertical:
            height = CGFloat(titles.count)*(actionHeight+configuration.spacing)
            height -= configuration.spacing
        }
    }
}
