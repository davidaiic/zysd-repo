//
//  EdgeInteractiveTransition.swift
//  Pods
//
//  Created by wangteng on 2022/3/7.
//

import UIKit

public class SlidingPresentationTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    public weak var delegate: SlidingPresentationTransitionProtocol?
    
    private let targetEdge: UIRectEdge
    private var panGestureRecognizer: UIPanGestureRecognizer?
    private var transitionContext: UIViewControllerContextTransitioning?
    private var initialPresentedViewCenter: CGPoint!
    private var shouldHandleGesture: Bool {
        guard let delegate = delegate else {
            return true
        }
        if delegate.presentationTransitionScrollBlocked {
            return true
        } else {
            
            guard
                let transitionContext = transitionContext,
                let presentedView = transitionContext.view(forKey: .to)
            else {
                return true
            }
            if presentedView.center != initialPresentedViewCenter {
                return true
            } else {
                return false
            }
        }
    }
    
    public init(targetEdge: UIRectEdge, delegate: SlidingPresentationTransitionProtocol? = nil) {
        self.targetEdge = targetEdge
        self.delegate = delegate
        super.init()
    }
 
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        self.transitionContext = transitionContext
        
        let container = transitionContext.containerView
        
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        
        let fromView: UIView = transitionContext.view(forKey: .from) ?? fromVC.view
        let toView: UIView = transitionContext.view(forKey: .to) ?? toVC.view
        
        let isPresenting = (toVC.presentingViewController == fromVC)
        
        let fromFrame = transitionContext.initialFrame(for: fromVC)
        let toFrame = transitionContext.finalFrame(for: toVC)
        
        if isPresenting {
            container.addSubview(toView)
            switch targetEdge {
            case .top:
                toView.frame = CGRect(origin: CGPoint(x: toFrame.origin.x, y: -toFrame.size.height), size: toFrame.size)
            case .bottom:
                toView.frame = CGRect(origin: CGPoint(x: toFrame.origin.x, y: container.bounds.height), size: toFrame.size)
            case .left:
                toView.frame = CGRect(origin: CGPoint(x: -toFrame.size.width, y: toFrame.origin.y), size: toFrame.size)
            case .right:
                toView.frame = CGRect(origin: CGPoint(x: container.bounds.width, y: toFrame.origin.y), size: toFrame.size)
            default:
                fatalError("Should be one of edges.")
            }
            
            if let delegate = delegate, delegate.presentationTransitionCanSliding() {
                let panGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(slidingInteractiveTransition(gesture:)))
                panGestureRecognizer.delegate = self
                self.panGestureRecognizer = panGestureRecognizer
                toView.addGestureRecognizer(panGestureRecognizer)
            }
            
        } else {
            container.bringSubviewToFront(fromView)
        }
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            if isPresenting {
                toView.frame = toFrame
            } else {
                switch self.targetEdge {
                case .top:
                    fromView.frame = CGRect(origin: CGPoint(x: fromFrame.origin.x, y: -fromFrame.size.height), size: fromFrame.size)
                case .bottom:
                    fromView.frame = CGRect(origin: CGPoint(x: fromFrame.origin.x, y: container.bounds.height), size: fromFrame.size)
                case .left:
                    fromView.frame = CGRect(origin: CGPoint(x: -fromFrame.size.width, y: fromFrame.origin.y), size: fromFrame.size)
                case .right:
                    fromView.frame = CGRect(origin: CGPoint(x: container.bounds.width, y: fromFrame.origin.y), size: fromFrame.size)
                default:
                    fatalError("Should be one of edges.")
                }
            }
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

extension SlidingPresentationTransition: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    /* 控制只能上下手势
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else { return true }
        let velocity = panGestureRecognizer.velocity(in: panGestureRecognizer.view)
        return abs(velocity.y) > abs(velocity.x)
    }*/
}

extension SlidingPresentationTransition {
    
   @objc func slidingInteractiveTransition(gesture: UIPanGestureRecognizer) {
       guard
           let panGestureRecognizer = panGestureRecognizer,
           let transitionContext = transitionContext,
           let presentedViewController = transitionContext.viewController(forKey: .to),
           let presentedView = transitionContext.view(forKey: .to)
       else {
           return
       }
       
       let translation = gesture.translation(in: presentedView)
       
       switch panGestureRecognizer.state {
       case .began:
           initialPresentedViewCenter = presentedView.center
       case .changed:
           guard shouldHandleGesture else {
               gesture.setTranslation(.zero, in: presentedView)
               return
           }
           
           if let delegate = delegate, let scrollView = delegate.scrollableView {
               scrollView.contentOffset = .zero
           }
           
           switch targetEdge {
           case .bottom:
               let newCenterY = max(initialPresentedViewCenter.y + translation.y, initialPresentedViewCenter.y)
               presentedView.center = CGPoint(x: initialPresentedViewCenter.x,
                                              y: newCenterY)
             
           case .top:
               let newCenterY = min(initialPresentedViewCenter.y + translation.y, initialPresentedViewCenter.y)
               presentedView.center = CGPoint(x: initialPresentedViewCenter.x,
                                              y: newCenterY)
           case .left:
               guard translation.x < 0 else { return }
               let newCenterX = initialPresentedViewCenter.x + translation.x
               presentedView.center = CGPoint(x: newCenterX,
                                              y: initialPresentedViewCenter.y)
              
           case .right:
               guard translation.x > 0 else { return }
               let newCenterX = initialPresentedViewCenter.x + translation.x
               presentedView.center = CGPoint(x: newCenterX,
                                              y: initialPresentedViewCenter.y)
           default:
               break
           }
       case .ended:
           let finalFrame = transitionContext.finalFrame(for: presentedViewController)
           let dismissalHeight = finalFrame.size.height/5.0
           let dismissalWidth = finalFrame.size.width/5.0
           
           switch targetEdge {
           case .bottom:
               if finalFrame.size.height-(UIScreen.main.bounds.height-presentedView.frame.origin.y) > dismissalHeight {
                   delegate?.presentationTransitionDismiss()
               } else {
                   animate(presentedView, finalFrame: finalFrame)
               }
           case .top:
               if -presentedView.frame.origin.y > dismissalHeight {
                   delegate?.presentationTransitionDismiss()
               } else {
                   animate(presentedView, finalFrame: finalFrame)
               }
           case .left:
               if -presentedView.frame.origin.x > dismissalWidth {
                   delegate?.presentationTransitionDismiss()
               } else {
                   animate(presentedView, finalFrame: finalFrame)
               }
           case .right:
               if finalFrame.size.width-presentedView.frame.origin.x < dismissalWidth {
                   delegate?.presentationTransitionDismiss()
               } else {
                   animate(presentedView, finalFrame: finalFrame)
               }
           default:
               animate(presentedView, finalFrame: finalFrame)
           }
       default:
           break
       }
   }
   
   func animate(_ presentedView: UIView, finalFrame: CGRect) {
       UIView.animate(withDuration: self.transitionDuration(using: nil), animations: {
           presentedView.frame = finalFrame
       })
   }

}
