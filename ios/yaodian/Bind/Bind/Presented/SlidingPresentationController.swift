import UIKit

 public protocol SlidingPresentationDelegate: UIAdaptivePresentationControllerDelegate {
      func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool
}

@objcMembers
public class SlidingPresentationController: UIPresentationController {
    
    private var dimmingView: UIView?
    
    private var contentLayoutGuideView: UIView?
    
    private var keyboardFrameObserver: NSObjectProtocol?
    
    public let targetEdge: UIRectEdge
    
    public init(presentedViewController: UIViewController,
                presentingViewController: UIViewController?,
                targetEdge: UIRectEdge,
                isContainerAffectedByKeyboard: Bool) {
        
        self.targetEdge = targetEdge
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
       
        if isContainerAffectedByKeyboard {
            self.keyboardFrameObserver = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: .main) { [unowned self] n in
                guard
                    let containerView = self.containerView,
                    let presentedView = self.presentedView,
                    let contentLayoutView = self.contentLayoutGuideView,
                    let keyboardFrame = n.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                        return
                }
                let localFrame = containerView.convert(keyboardFrame, from: UIScreen.main.coordinateSpace)
                contentLayoutView.frame = CGRect(
                    origin: .zero,
                    size: CGSize(width: containerView.bounds.width, height: min(containerView.bounds.height, localFrame.minY))
                )
                let animationDuration = n.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
                let animationCurve: UIView.AnimationCurve = {
                    guard
                        let raw = n.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
                        let curve = UIView.AnimationCurve(rawValue: raw) else {
                            return .easeInOut
                    }
                    return curve
                }()
                
                func animation() {
                    UIView.beginAnimations("KeyboardTransition", context: nil)
                    UIView.setAnimationDuration(animationDuration)
                    UIView.setAnimationCurve(animationCurve)
                    presentedView.frame = self.frameOfPresentedViewInContainerView
                    presentedView.layoutIfNeeded()
                    UIView.commitAnimations()
                }
                
                if self.presentedViewController.isBeingPresented {
                    DispatchQueue.main.async {
                        animation()
                    }
                } else if self.presentedViewController.isBeingDismissed {
                    return
                } else {
                    animation()
                }
            }
        } else {
            self.keyboardFrameObserver = nil
        }
    }
    
    public override convenience init(presentedViewController: UIViewController,
                                     presenting presentingViewController: UIViewController?) {
        self.init(presentedViewController: presentedViewController,
                  presentingViewController: presentingViewController,
                  targetEdge: .bottom,
                  isContainerAffectedByKeyboard: false)
    }
    
    deinit {
        if let observer = self.keyboardFrameObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    public override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        guard
            let presentedView = self.presentedView, !self.presentedViewController.isBeingPresented else {
                return
        }
        presentedView.frame = self.frameOfPresentedViewInContainerView
    }
    
    public override func presentationTransitionWillBegin() {
        
        guard
            let containerView = self.containerView else {
                return
        }
        
        containerView.layoutMargins = UIEdgeInsets.zero
        
        let layoutGuideView = UIView(frame: containerView.bounds)
        layoutGuideView.layoutMargins = UIEdgeInsets.zero
        layoutGuideView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        layoutGuideView.isOpaque = true
        layoutGuideView.isHidden = true
        layoutGuideView.backgroundColor = .white
        containerView.addSubview(layoutGuideView)
        self.contentLayoutGuideView = layoutGuideView
        
        let dim = UIView(frame: containerView.bounds)
        dim.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        dim.isOpaque = false
        dim.accessibilityIdentifier = "SlidingPresentation.dim"
        dim.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        dim.alpha = 0.0
        
        containerView.addSubview(dim)
        self.dimmingView = dim
        
        dim.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissPresented)))
        
        self.presentingViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            dim.alpha = 1.0
        }, completion: { _ in
            dim.alpha = 1.0
        })
    }
    
    func dismissPresented() {
        if (self.delegate as? SlidingPresentationDelegate)?.presentationControllerShouldDismiss(self) ?? true {
            self.presentedViewController.dismiss(animated: true)
        }
    }
    
    public override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            self.dimmingView?.removeFromSuperview()
        }
    }
    
    public override func dismissalTransitionWillBegin() {
        guard
            let coordinator = self.presentingViewController.transitionCoordinator else {
                return
        }
        let dim = self.dimmingView
        coordinator.animate(alongsideTransition: { _ in
            dim?.alpha = 0.0
        }, completion: { _ in
            dim?.alpha = 0.0
        })
    }
    
    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            self.dimmingView?.removeFromSuperview()
            self.contentLayoutGuideView?.removeFromSuperview()
        }
    }
    
    public override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        guard
            let containerView = self.containerView,
            let presentedView = self.presentedView, container === self.presentedViewController else {
                return
        }
        if presentedView.superview != nil {
            containerView.layoutIfNeeded()
            UIView.animate(withDuration: 0.25) {
                presentedView.frame = self.frameOfPresentedViewInContainerView
                containerView.setNeedsLayout()
                containerView.layoutIfNeeded()
            }
        } else {
            containerView.setNeedsLayout()
        }
    }
    
    public override var frameOfPresentedViewInContainerView: CGRect {
        
        guard
            let contentLayoutGuideView = self.contentLayoutGuideView else {
                return CGRect.zero
        }
        
        let contentSize = self.presentedViewController.preferredContentSize
        var rect = CGRect(origin: CGPoint.zero, size: contentSize)
        let bounds = contentLayoutGuideView.bounds
        
        switch self.targetEdge {
        case UIRectEdge.top: 
            rect.size.height = Swift.max(0, Swift.min(contentSize.height, bounds.height))
            rect.size.width = bounds.width
        case UIRectEdge.bottom:
            rect.size.height = Swift.max(0, Swift.min(contentSize.height, bounds.height))
            rect.size.width = bounds.width
            rect.origin.y = bounds.height - rect.height
        case UIRectEdge.left:
            rect.size.width = Swift.max(0, Swift.min(contentSize.width, bounds.width))
            rect.size.height = bounds.height
        case UIRectEdge.right:
            rect.size.width = Swift.max(0, Swift.min(contentSize.width, bounds.width))
            rect.size.height = bounds.height
            rect.origin.x = bounds.width - rect.width
        default:
            fatalError("Should be one of edges.")
        }
        
        return rect
    }
    
}
