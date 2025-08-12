
import UIKit

/// Hud 风格
///
/// - vomProgress: vom 里那种两个蓝色球球
/// - custom: contentView 需要遵循 HudAnimating
/// - withDetail: vom 包含两个蓝色球 及 文字提示
public enum HudStyle {
    case indicator
    case vomProgress
    case custom(contentView: UIView)
    case withDetail(message: String, messageColor: UIColor?, blur: Bool)
}

/**
 Hud 控制，支持自定义扩展 contentView
 
 使用示例：
 
 ```
 // 显示灰色背景蒙层
 Hud.dimsBackground = true
 
 // 允许用户交互穿透 hud
 Hud.allowsInteraction = true
 
 // 获取 hud 是否可见
 if Hud.isVisible {}
 
 // 在 view 上显示 vomProgress 风格的 hud
 // view 为 nil 则显示在 KeyWindow 上
 Hud.show(.vomProgress, onView: view)
 
 // 移除 hud 且不使用动画效果
 Hud.hide(animated: false) { (finished) in
 //do something
 }
 
 // 一秒后移除 hud
 Hud.hide(afterDelay: 1) { (finished) in
 //do something
 }
 
 // 在 view 上显示 vomProgress 风格的 hud，然后马上移除
 // view 为 nil 则显示在 KeyWindow 上
 Hud.flash(.vomProgress, onView: view)
 
 // 在 view 上显示 vomProgress 风格的 hud，一秒后移除
 // view 为 nil 则显示在 KeyWindow 上
 Hud.flash(.vomProgress, onView: view, delay: 1) { (finished) in
 //do something
 }
 ```
 */
public final class Hud: NSObject {
    
    // MARK: Properties
    
    /// 是否显示灰色背景蒙层，true 显示，false(default) 不显示
    public static var dimsBackground: Bool {
        get { return HudManager.sharedHUD.dimsBackground }
        set { HudManager.sharedHUD.dimsBackground = newValue }
    }
    
    /// 是否允许用户交互穿透，true 允许，false(default) 不允许
    public static var allowsInteraction: Bool {
        get { return HudManager.sharedHUD.userInteractionOnUnderlyingViewsEnabled  }
        set { HudManager.sharedHUD.userInteractionOnUnderlyingViewsEnabled = newValue }
    }
    
    /// (只读) 返回 Hud 是否可见
    public static var isVisible: Bool { return HudManager.sharedHUD.isVisible }
    
    // MARK: Public methods
    
    /// 显示 Hud
    ///
    /// - Parameters:
    ///   - style: Hud 风格
    ///   - view: 显示在该 view 上
    public static func show(_ style: HudStyle, onView view: UIView? = nil) {
        DispatchQueue.main.async {
            HudManager.sharedHUD.contentView = contentView(with: style)
            HudManager.sharedHUD.show(onView: view)
        }
    }
    
    /// 移除 Hud
    ///
    /// - Parameters:
    ///   - animated: 是否渐渐消失，默认值 true
    ///   - completion: 回调参数为 true 则移除成功
    public static func hide(animated: Bool = false, completion: ((Bool) -> Void)? = nil) {
        DispatchQueue.main.async {
            HudManager.sharedHUD.hide(animated: animated, completion: completion)
        }
    }
    
    
    /// 延迟移除 Hud
    ///
    /// - Parameters:
    ///   - delay: 在 delay 之后开始移除
    ///   - completion: 回调参数为 true 则移除成功
    public static func hide(afterDelay delay: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        DispatchQueue.main.async {
            HudManager.sharedHUD.hide(afterDelay: delay, completion: completion)
        }
    }
    
    
    /// 显示后接着移除
    ///
    /// - Parameters:
    ///   - style: Hud 风格
    ///   - view: 显示在该 view 上
    public static func flash(_ style: HudStyle, onView view: UIView? = nil) {
        DispatchQueue.main.async {
            Hud.show(style, onView: view)
            Hud.hide(completion: nil)
        }
    }
    
    /// 显示后接着延迟移除
    ///
    /// - Parameters:
    ///   - style: Hud 风格
    ///   - view: 显示在该 view 上
    ///   - delay: 在 delay 之后开始移除
    ///   - completion: 回调参数为 true 则移除成功
    public static func flash(_ style: HudStyle, onView view: UIView? = nil, delay: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        DispatchQueue.main.async {
            Hud.show(style, onView: view)
            Hud.hide(afterDelay: delay, completion: completion)
        }
    }
    
    // MARK: Private methods
    
    /// 根据 style 获取相应的 contentView
    ///
    /// - Parameter style: Hud 风格
    /// - Returns: UIView
    private static func contentView(with style: HudStyle) -> UIView {
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
