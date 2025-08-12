
import UIKit

public class Toast: NSObject {
    
    @objc(show:)
    public class func showMsg(_ msg: String) {
        Toast.show(msg)
    }
    
    /// BusinessUIControl: 显示Toast 在Window上
    ///
    /// - Parameters:
    ///   - msg: 显示文字.
    ///   - duration: 显示时间.
    ///   - position: 显示位置.
    ///   - title: 显示Title.
    ///   - inView: 在哪个View上面展示，如果为Nil，默认在Window上面展示.
    ///   - completion: 完成回调.
    public static func show(_ msg: String?,
                            duration: TimeInterval = 1.5,
                            position: ToastPosition = .center,
                            style: ToastStyle = ToastStyle(),
                            title: String? = nil,
                            image: UIImage? = nil,
                            inView: UIView? = nil,
                            completion: ((Bool) -> Void)? = nil)
    {
        DispatchQueue.main.async {
            guard let message = msg, message != "" else { return }
            let inView = inView ?? UIWindow.currentWindow
            inView?.makeToast(message,
                        duration: duration,
                        position: position,
                        title: title,
                        image: image,
                        style: style,
                        completion: completion)
        }
    }
}

// MARK: - Properties
public extension UIWindow {
    
    /// FDFoundation: Find current window ,returns the current window.
    static var currentWindow: UIWindow? {
        let enumerator = UIApplication.shared.windows.reversed()
        for window in enumerator {
            let windowOnMainScreen = (window.screen == UIScreen.main)
            let windowIsVisible = (!window.isHidden && window.alpha > 0)
            if windowOnMainScreen && windowIsVisible && window.isKeyWindow {
                return window
            }
        }
        return UIApplication.shared.delegate?.window ?? nil
    }
}













