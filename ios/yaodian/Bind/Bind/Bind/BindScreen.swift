//
//  KeScreen.swift
//  Drug
//
//  Created by wangteng on 2023/2/9.
//

import Foundation

extension UIScreen: Bindble { }

public extension Bind where T == UIScreen {
    
    static var width: CGFloat {
        UIScreen.main.bounds.width
    }
    
    static var height: CGFloat {
        UIScreen.main.bounds.height
    }
    
    static var size: CGSize {
        UIScreen.main.bounds.size
    }
    
    static var safeBottomInset: CGFloat {
        let scene = UIApplication.shared.connectedScenes.first
        guard let windowScene = scene as? UIWindowScene else { return 34 }
        guard let window = windowScene.windows.first else { return 34 }
        return window.safeAreaInsets.bottom
    }
    
    /// 状态栏高度+导航栏高度
    ///
    /// - Returns: 状态栏+导航栏 总高度
    static var navigationBarHeight: CGFloat {
        return UIScreen.bind.statusBarHeight + 44
    }

    /// 状态栏高度
    ///
    /// - Returns: 状态栏高度
    static var statusBarHeight: CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            statusBarHeight = UIApplication.shared.windows.last?.windowScene?.statusBarManager?.statusBarFrame.size.height ?? 20
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.size.height;
        }
        return statusBarHeight
    }

}
