//
//  EmptyStyle.swift
//  Drug
//
//  Created by wangteng on 2023/2/28.
//

import Foundation

public class EmptyViewStyle {
    
    /// 图片 默认 nil
    public var image: UIImage?

    /// 大标题 默认空
    public var title: String = ""

    /// 描述信息 默认空
    public var detail: String = ""

    /// 按钮文字 默认空
    public var buttonTitle = ""
    
    public var centerYoffset: CGFloat = 0
    
    init(image: UIImage? = nil, title: String = "", detail: String = "", buttonTitle: String = "") {
        self.image = image
        self.title = title
        self.detail = detail
        self.buttonTitle = buttonTitle
    }
    
    static func netError() -> EmptyViewStyle {
        EmptyViewStyle.init(image: UIImage(named: "netError"), title: "抱歉，网络异常哦～", buttonTitle: "重新加载")
    }
    
    static func loadFailed() -> EmptyViewStyle {
        EmptyViewStyle.init(image: UIImage(named: "loadFailed"), title: "加载失败，请重试", buttonTitle: "刷新")
    }
    
    static func empty(_ title: String = "暂无内容") -> EmptyViewStyle {
        EmptyViewStyle.init(image: UIImage(named: "scan_search_empty"), title: title, buttonTitle: "")
    }

}
