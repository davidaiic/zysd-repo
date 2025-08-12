
import UIKit

/// Hud object controls showing and hiding of the HUD, as well as its contents and touch response behavior.
public class HudManager: NSObject {
    
    fileprivate struct Constants {
        static let sharedHUD = HudManager()
    }
    
    internal var viewToPresentOn: UIView?
    
    fileprivate let container = HudContainerView()
    fileprivate var hideTimer: Timer?
    
    public var top: CGFloat = 0
    
    internal typealias TimerAction = (Bool) -> Void
    fileprivate var timerActions = [String: TimerAction]()
    
    /// Grace period is the time (in seconds) that the invoked method may be run without
    /// showing the HUD. If the task finishes before the grace time runs out, the HUD will
    /// not be shown at all.
    /// This may be used to prevent HUD display for very short tasks.
    /// Defaults to 0 (no grace time).
    @available(*, deprecated, message: "Will be removed with Swift4 support, use gracePeriod instead")
    internal var graceTime: TimeInterval {
        get {
            return gracePeriod
        }
        set(newPeriod) {
            gracePeriod = newPeriod
        }
    }
    
    /// Grace period is the time (in seconds) that the invoked method may be run without
    /// showing the HUD. If the task finishes before the grace time runs out, the HUD will
    /// not be shown at all.
    /// This may be used to prevent HUD display for very short tasks.
    /// Defaults to 0 (no grace time).
    internal var gracePeriod: TimeInterval = 0
    fileprivate var graceTimer: Timer?
    
    // MARK: Public
    
    internal class var sharedHUD: HudManager {
        return Constants.sharedHUD
    }
    
    internal override init () {
        super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(HudManager.willEnterForeground(_:)),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        userInteractionOnUnderlyingViewsEnabled = false
        container.frameView.autoresizingMask = [ .flexibleLeftMargin,
                                                 .flexibleRightMargin,
                                                 .flexibleTopMargin,
                                                 .flexibleBottomMargin ]
        
        self.container.isAccessibilityElement = true
        self.container.accessibilityIdentifier = "HudManager"
    }
    
    internal convenience init(viewToPresentOn view: UIView) {
        self.init()
        viewToPresentOn = view
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    internal var dimsBackground = false
    internal var userInteractionOnUnderlyingViewsEnabled: Bool {
        get {
            return !container.isUserInteractionEnabled
        }
        set {
            container.isUserInteractionEnabled = !newValue
        }
    }
    
    internal var isVisible: Bool {
        return !container.isHidden
    }
    
    internal var contentView: UIView {
        get {
            return container.frameView.content
        }
        set {
            container.frameView.content = newValue
        }
    }
    
    internal func show(onView view: UIView? = nil) {
        
        let scene = UIApplication.shared.connectedScenes.first
        guard let windowScene = scene as? UIWindowScene else { return }
        guard let window = windowScene.windows.first else { return }
        
        let view: UIView = view ?? viewToPresentOn ?? window
        if  !view.subviews.contains(container) {
            view.addSubview(container)
            container.frame.origin = CGPoint.zero
            container.frame.size = view.frame.size
            container.autoresizingMask = [ .flexibleHeight, .flexibleWidth ]
            container.isHidden = true
        }
        
        container.frameCenteryOffset = top
        view.bringSubviewToFront(container)
        if dimsBackground {
            container.showBackground(animated: true)
        }
        
        // If the grace time is set, postpone the HUD display
        if gracePeriod > 0.0 {
            let timer = Timer(timeInterval: gracePeriod, target: self, selector: #selector(HudManager.handleGraceTimer(_:)), userInfo: nil, repeats: false)
            RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
            graceTimer = timer
        } else {
            showContent()
        }
    }
    
    func showContent() {
        graceTimer?.invalidate()
        container.showFrameView()
        startAnimatingContentView()
    }
    
    internal func hide(animated anim: Bool = true, completion: TimerAction? = nil) {
        graceTimer?.invalidate()
        
        container.hideFrameView(animated: anim, completion: completion)
        stopAnimatingContentView()
    }
    
    internal func hide(_ animated: Bool, completion: TimerAction? = nil) {
        hide(animated: animated, completion: completion)
    }
    
    internal func hide(afterDelay delay: TimeInterval, completion: TimerAction? = nil) {
        let key = UUID().uuidString
        let userInfo = ["timerActionKey": key]
        if let completion = completion {
            timerActions[key] = completion
        }
        
        hideTimer?.invalidate()
        hideTimer = Timer.scheduledTimer(timeInterval: delay,
                                         target: self,
                                         selector: #selector(HudManager.performDelayedHide(_:)),
                                         userInfo: userInfo,
                                         repeats: false)
    }
    
    // MARK: Internal
    @objc internal func willEnterForeground(_ notification: Notification?) {
        self.startAnimatingContentView()
    }
    
    internal func startAnimatingContentView() {
        if let animatingContentView = contentView as? HudAnimating, isVisible {
            animatingContentView.startAnimation()
        }
    }
    
    internal func stopAnimatingContentView() {
        if let animatingContentView = contentView as? HudAnimating {
            animatingContentView.stopAnimation?()
        }
    }
    
    // MARK: Timer callbacks
    
    @objc internal func performDelayedHide(_ timer: Timer? = nil) {
        let userInfo = timer?.userInfo as? [String:AnyObject]
        let key = userInfo?["timerActionKey"] as? String
        var completion: TimerAction?
        
        if let key = key, let action = timerActions[key] {
            completion = action
            timerActions[key] = nil
        }
        
        hide(animated: true, completion: completion)
    }
    
    @objc internal func handleGraceTimer(_ timer: Timer? = nil) {
        // Show the HUD only if the task is still running
        if (graceTimer?.isValid)! {
            showContent()
        }
    }
}
