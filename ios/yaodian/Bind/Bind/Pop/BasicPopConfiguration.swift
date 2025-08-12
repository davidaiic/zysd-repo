//
//  BasicAlertContentViewConfiguration.swift
//  MotorFans
//
//  Created by wangteng on 2023/1/4.
//  Copyright © 2023 MotorFans, JDD. All rights reserved.
//

import Foundation

@objcMembers
public class BasicPopConfiguration: NSObject {
    
    @objc public enum ClosePosition: Int {
        case unspecified
        case topRight
        case bottomCenter
    }
  
    /// 关闭按钮图片
    public var closeImage: UIImage?
    
    /// 关闭按钮位置 默认不显示关闭按钮
    public var closePosition: ClosePosition = .unspecified {
        didSet {
            switch closePosition {
            case .unspecified:
                closeImage = nil
            case .topRight:
                closeImage = Assets.imageBy(name: "basic_pop_close", inDirectory: "Popup")
            case .bottomCenter:
                closeImage = Assets.imageBy(name: "basic_bottom_closed", inDirectory: "Popup")
            }
        }
    }
    
    /// 存储实现`BasicPopItemble`协议的对象,
    /// eg:`BasicPopImageItem`, `BasicPopTextItem`, `BasicPopActionItem`, `BasicPopWrapperItem`
    public var popItems: [BasicPopItemble] = []
    
    /// 每个Item之间的高度间距 默认 15
    public var spacing: CGFloat = 15
    
    /// 关闭Handler
    public var closeHandler: (() -> Void)?
    
    /// 容器内间距
    public var padding: UIEdgeInsets = .init(top: 20, left: 20, bottom: 20, right: 20)
    
    /// 容器最大宽度 默认260
    public var contentMaxWidth: CGFloat = 260
    
    /// 点击遮照是否消失
    public var didMaskClose: Bool = false
}

public extension BasicPopConfiguration {
    
    /// 容器高度
    var height: CGFloat {
        
        var height: CGFloat = padding.top+padding.bottom
        
        /// 过滤掉高度为0的Item
        popItems = popItems.filter({ item -> Bool in
            item.configureHeight(self)
            return item.height > 0
        })
       
        /// 获取Items和间距的总高度
        height += popItems.map {
            $0.height+spacing
        }.reduce(0, +)
        
        /// 减去循环中多出来的高度间距
        height -= spacing
        
        return height
    }
}

public extension BasicPopConfiguration {
    
    func item<T: BasicPopItemble>(atIndex index: Int, type: T.Type) -> T {
        return popItems[index] as! T
    }
}
