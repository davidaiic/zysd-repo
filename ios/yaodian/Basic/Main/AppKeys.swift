//
//  AppKeys.swift
//  Basic
//
//  Created by wangteng on 2023/4/13.
//

import Foundation

struct AppKeys {
    static let universalLink = "https://shiyao.yaojk.com.cn/shiyao/"
    static let wechatAppId = "wx1230384104d17cac2"
    static let webTitle = "识药查真伪"
}

extension NSNotification.Name {
    static let share = NSNotification.Name("com.user.share")
}

extension UIColor {
    static let barTintColor = UIColor(named: "barTintColor") ?? UIColor(0x5ECCB2)
    static let background   = UIColor(named: "background")   ?? UIColor(0xF8F9FB)
}
