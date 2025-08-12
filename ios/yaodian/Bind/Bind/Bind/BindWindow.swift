//
//  BindWindow.swift
//  Bind
//
//  Created by wangteng on 2023/3/14.
//

import Foundation

extension UIWindow: Bindble { }

public extension Bind where T: UIWindow {
    
    static func topViewController() -> UIViewController? {
        var result: UIViewController?
        if let rootViewController = UIWindow.currentWindow?.rootViewController {
            result = nextTopViewController(object: rootViewController)
            while result?.presentedViewController != nil {
                result = result?.presentedViewController
            }
        }
        return result
    }
    
    private static func nextTopViewController(object: AnyObject!) -> UIViewController? {
        if let navigationController = object as? UINavigationController {
            return nextTopViewController(object: navigationController.viewControllers.last)
        }
        if let tabBarController = object as? UITabBarController,
            let ctrs = tabBarController.viewControllers,
            tabBarController.selectedIndex < ctrs.count {
            return nextTopViewController(object: ctrs[tabBarController.selectedIndex])
        }
        return object as? UIViewController
    }
}
