//
//  HudView.swift
//  Bind
//
//  Created by wangteng on 2023/4/16.
//

import Foundation

public extension UIView {
    
    private struct HudManagerKey {
        static var hud = "hud.manager.key"
    }
    
    public var hud: HudManager {
        get {
            if let hud = objc_getAssociatedObject(self, &HudManagerKey.hud) as? HudManager {
                return hud
            } else {
                let hud = HudManager()
                objc_setAssociatedObject(self, &HudManagerKey.hud, hud, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return hud
            }
        }
    }
    
    /// 显示 Hud
    ///
    /// - Parameters:
    ///   - style: Hud 风格
    ///   - view: 显示在该 view 上
    public func showHud(_ style: HudStyle) {
        hud.contentView = contentView(with: style)
        hud.show(onView: self)
    }
    
    /// 移除 Hud
    ///
    /// - Parameters:
    ///   - animated: 是否渐渐消失，默认值 true
    ///   - completion: 回调参数为 true 则移除成功
    public func hideHud(animated: Bool = false, completion: ((Bool) -> Void)? = nil) {
        hud.hide(animated, completion: completion)
    }
    
    /// 根据 style 获取相应的 contentView
    ///
    /// - Parameter style: Hud 风格
    /// - Returns: UIView
    private func contentView(with style: HudStyle) -> UIView {
        switch style {
        case .indicator:
            return HudIndicator()
        case .vomProgress:
            return HudVomProgressView()
        case .custom(let contentView):
            return contentView
        case .withDetail(let message, let messageColor, let blur):
            return HudVomProgressView(message: message, messageColor: messageColor, blur: blur)
        }
    }
}
