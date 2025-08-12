//
//  ScannerAut.swift
//  Basic
//
//  Created by wangteng on 2023/3/5.
//

import Foundation
import Bind

struct ScanAuthorzation {
    
    static func popPhoto() {
        let title = "请在iPhone的\"设置 > 隐私 > 相机\"选项中，允许\(UIApplication.shared.bind.appBundleName)访问你的相册"
        BasicPopManager().bind(.title(title)).action(titles: ["取消", "前往"]) { action in
            action.handler = { selectedIndex -> Bool in
                if selectedIndex == 0 {
                    return true
                } else {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    return false
                }
            }
        }.pop()
    }
    
    static func popCamera() {
        let title = "请在iPhone的\"设置 > 隐私 > 相机\"选项中，允许\(UIApplication.shared.bind.appBundleName)访问你的相机"
        BasicPopManager().bind(.title(title)).action(titles: ["取消", "前往"]) { action in
            action.handler = { selectedIndex -> Bool in
                if selectedIndex == 0 {
                    return true
                } else {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    return false
                }
            }
        }.pop()
    }
}
