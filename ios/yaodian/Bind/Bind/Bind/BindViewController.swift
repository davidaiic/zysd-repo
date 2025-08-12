//
//  ViewController.swift
//  Drug
//
//  Created by wangteng on 2023/2/10.
//

import UIKit

extension UIViewController: Bindble { }

public extension Bind where T: UIViewController {
    
    func topViewController() -> UIViewController? {
        var result: UIViewController?
        if let rootViewController = UIWindow.currentWindow?.rootViewController {
            result = nextTopViewController(object: rootViewController)
            while result?.presentedViewController != nil {
                result = result?.presentedViewController
            }
        }
        return result
    }
    
    private func nextTopViewController(object: AnyObject!) -> UIViewController? {
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
    
    func push() {
        self.base.hidesBottomBarWhenPushed = true
        topViewController()?.navigationController?.pushViewController(self.base, animated: true)
    }
    
    func pop() {
        topViewController()?.navigationController?.popViewController(animated: true)
    }
    
    func present() {
        self.base.modalPresentationStyle = .fullScreen
        topViewController()?.present(self.base, animated: true)
    }
    
    /// 关闭指定的页面
    /// - Parameters:
    ///   - cls: 关闭页面的类型
    ///   - animated: 是否支持动画、默认`true`
    ///   - completion: 关闭完成回掉
    func unRouter(cls: UIViewController.Type,
                  animated: Bool = true,
                  completion: ((UIViewController?) -> Void)? = nil) {
        let manager = ViewControllerRouterManager(current: self.base, target: cls).build()
        manager.close(animated: animated) { viewController in
            guard let handler = completion else {
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                handler(viewController)
            }
        }
    }
    
    /// 关闭指定的页面然后跳转到指定页面 只支持`push`
    /// - Parameters:
    ///   - target: 跳转到的页面
    ///   - closeCls: 关闭页面的类型
    ///   - animated: 否支持动画、默认`true`
    func router(target: UIViewController,
                closeCls: UIViewController.Type,
                animated: Bool = true) {
        
        let manager = ViewControllerRouterManager(current: self.base, target: closeCls).build()
        if manager.hasSameNavigationController,
           let returned = manager.targetBeforeInNavigation(),
           let navigationController = returned.navigationController {
            navigationController.pushViewController(target, animated: animated)
            manager.ignores = [type(of: target)]
            manager.close(animated: animated)
        } else {
            manager.close(animated: animated) { viewController in
                guard let navigationController = viewController?.navigationController else {
                    return
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    navigationController.pushViewController(target, animated: animated)
                }
            }
        }
    }
}

class ViewControllerRouterManager {
    
    private weak var current: UIViewController?
    private var target: UIViewController.Type?
    private var nodes: [UIViewController] = []
    var ignores: [UIViewController.Type] = []
    
    init(current: UIViewController, target: UIViewController.Type, ignores: [UIViewController.Type] = []) {
        self.current = current
        self.target = target
        self.ignores = ignores
    }
  
    var hasSameNavigationController: Bool {
        
        guard let target = target, let current = current else {
            return false
        }
        
        guard let navigationController = current.navigationController,
              let rootViewController = navigationController.viewControllers.first else {
            return false
        }
        
        /// 关闭 `rootViewController`
        if rootViewController.isKind(of: target) {
            return false
        }
        return navigationController.viewControllers.contains { $0.isKind(of: target) }
    }
    
    func targetBeforeInNavigation() -> UIViewController? {
        
        guard let target = target, let current = current else {
            return nil
        }
        
        guard let navigationController = current.navigationController else {
            return nil
        }
        
        guard let targetIndex = navigationController.viewControllers.firstIndex(where: { $0.isKind(of: target)}) else {
            return nil
        }
        
        guard targetIndex > 0 else {
            return nil
        }
        
        guard navigationController.viewControllers.indices ~= targetIndex-1 else {
            return nil
        }
        
        return navigationController.viewControllers[targetIndex-1]
    }
    
    deinit {
        debugPrint(self)
    }
}

// MARK: - build
extension ViewControllerRouterManager {
    
    @discardableResult
    func build() -> ViewControllerRouterManager {
        guard let current = current else {
            return self
        }
        find(current)
        return self
    }
    
    /// 从 current 反向找到 target
    private func find(_ node: UIViewController) {
        guard let target = target else { return }
        switch node {
        case let navigationController as UINavigationController:
            for viewController in navigationController.viewControllers.reversed() {
                nodes.insert(viewController, at: 0)
                if viewController.isKind(of: target) {
                    return
                }
            }
            if let first = navigationController.viewControllers.first,
                let presentingViewController = first.presentingViewController {
                find(presentingViewController)
            } else {
                return
            }
        case _ as UITabBarController:
            return
        case let viewController:
            if viewController.isKind(of: target) {
                nodes.insert(viewController, at: 0)
                return
            }
            if let navigationController = viewController.navigationController {
                find(navigationController)
            } else if let presentingViewController = viewController.presentingViewController {
                find(presentingViewController)
            } else {
                nodes.insert(viewController, at: 0)
            }
        }
    }
}
    
// MARK: - close
extension ViewControllerRouterManager {
    
    private func _pop() -> UIViewController? {
        guard let target = target,
                let navigationController = nodes.first?.navigationController else {
            return nil
        }
        if let index = navigationController.viewControllers.firstIndex(
            where: { $0.isKind(of: target)}) {
            var targets = Array(navigationController.viewControllers.prefix(max(1, index)))
            for idx in index ..< navigationController.viewControllers.count {
                let viewController = navigationController.viewControllers[idx]
                if ignores.contains(where: { viewController.isKind(of: $0) }) {
                    targets.append(viewController)
                }
            }
            navigationController.viewControllers = targets
        }
        return navigationController.viewControllers.last
    }
    
    func close(animated: Bool, completion: ((UIViewController?) -> Void)? = nil) {
      
        guard let begin = nodes.first,
                let target = target,
                nodes.contains(where: { $0.isKind(of: target)})else {
            completion?(nil)
            return
        }
       
        var completionViewController: UIViewController?
        if begin.presentingViewController != nil {
            /// 模态含有导航并且是根 控制器
            if let navigation = begin.navigationController {
                
                /// root直接 dismiss
                if navigation.viewControllers.first == begin {
                    begin.dismiss(animated: animated)
                    completionViewController = returnedViewController(begin.presentingViewController)
                } else {
                    
                    /// 第二个 presentedViewController
                    let presentedViewController = presentedViewControllerFromBegin()
                    presentedViewController?.dismiss(animated: animated)
                    
                    completionViewController = _pop()
                }
            } else {
                begin.dismiss(animated: animated)
                completionViewController = returnedViewController(begin.presentingViewController)
            }
        } else {
            
            /// 第一个 presentedViewController
            let presentedViewController = beginPresentedViewController()
            presentedViewController?.dismiss(animated: animated)
            
            completionViewController = _pop()
        }
        
        completion?(completionViewController)
    }
    
    private func beginPresentedViewController() -> UIViewController? {
        return nodes.first(where: { $0.presentingViewController != nil })
    }
    
    private func presentedViewControllerFromBegin() -> UIViewController? {
        guard let first = nodes.first,
                let presentingViewController = first.presentingViewController
        else {
            return nil
        }
        return nodes.first(where: { $0.presentingViewController != presentingViewController })
    }
    
    private func returnedViewController(_ base: UIViewController?) -> UIViewController? {
       
        if let navigation = base as? UINavigationController {
            return navigation.viewControllers.last
        } else if let tabbar = base as? UITabBarController {
            guard let viewControllers = tabbar.viewControllers,
                  viewControllers.indices ~= tabbar.selectedIndex else {
                return nil
            }
            let selected = viewControllers[tabbar.selectedIndex]
            return returnedViewController(selected)
        } else {
            return base
        }
    }
}
