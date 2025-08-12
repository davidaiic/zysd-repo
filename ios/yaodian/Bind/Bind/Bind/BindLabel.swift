//
//  BindLabel.swift
//  Bind
//
//  Created by wangteng on 2023/3/8.
//

import UIKit

open class BindInsLabel: UILabel {
    
    open var insicWidth: CGFloat = 0
    open var insicHeight: CGFloat = 0
   
    open var insicMaxWidth: CGFloat = CGFloat.greatestFiniteMagnitude
    open var insicMaxHeight: CGFloat = CGFloat.greatestFiniteMagnitude
    
    open override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let visibaleSize = CGSize(
            width: size.width+insicWidth,
            height: size.height == 0 ? 0 : size.height+insicHeight
        )
        return CGSize(
            width: min(visibaleSize.width, insicMaxWidth),
            height: min(visibaleSize.height, insicMaxHeight)
        )
    }
}

public extension Bind where T == BindInsLabel {
    
    @discardableResult
    func insicWidth(_ width: CGFloat) -> Self {
        self.base.insicWidth = width
        return self
    }
    
    @discardableResult
    func insicHeight(_ height: CGFloat) -> Self {
        self.base.insicHeight = height
        return self
    }
    
    @discardableResult
    func insicMaxHeight(_ height: CGFloat) -> Self {
        self.base.insicMaxWidth = height
        return self
    }
    
    @discardableResult
    func insicMaxWidth(_ width: CGFloat) -> Self {
        self.base.insicMaxHeight = width
        return self
    }
}
