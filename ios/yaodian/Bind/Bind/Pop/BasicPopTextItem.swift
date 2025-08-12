//
//  BasicPopTextItem.swift
//  MotorFansKit
//
//  Created by wangteng on 2023/2/24.
//

import Foundation

@objcMembers
public class BasicPopTextItem: NSObject {
    
    /// 当前高度，通过`configureHeight(:_)` 方法进行赋值 由`BasicPopConfiguration`负责调用
    public var height: CGFloat = 0
    
    /// 文本属性字符串
    public var attributedText = NSMutableAttributedString(string: "")
    
    /// 文本对其方式 `NSTextAlignment` 默认 `.left`
    public var textAlignment: NSTextAlignment = .left
    
    /// 文本是否可以滑动
    /// `true` 实际文本高度 大于 `textLimitHeight`
    /// `false` 实际文本高度 小于等于 `textLimitHeight`
    ///  通过 `configureHeight(:_)` 中自动赋值
    public var scrollEnabled = false
    
    /// 文本限制高度 默认200
    public var textLimitHeight: CGFloat = 200
    
    /// 文本中链接点击回掉 第一个参数为link 第二个为link对应的文本
    public var linkHandler: ((String, String) -> Bool)?
}

extension BasicPopTextItem: BasicPopItemble {
    
    /// 配置高度由`BasicPopConfiguration`负责调用
    public func configureHeight(_ configuration: BasicPopConfiguration) {
        guard !attributedText.string.isEmpty else {
            return
        }
        let width = configuration.contentMaxWidth-configuration.padding.left-configuration.padding.right
        let height = attributedText.boundingRect(with: .init(width: width,
                                                             height: CGFloat.greatestFiniteMagnitude),
                                                 options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                 context: nil).height + 2
        scrollEnabled = height > textLimitHeight
        self.height = min(height, textLimitHeight)
    }
}
