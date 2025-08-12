//
//  MFSheetBaseViewController.swift
//  MotorFansKit
//
//  Created by wangteng on 2021/7/14.
//

import UIKit

open class SlidingPresentedViewController: UIViewController {

    public var presentationTransitionScrollBlocked = true
    
    open var scrollableView: UIScrollView? { nil }
    
    open var cancelButtonTappedBlock: (() -> Void)?
    
    open var targetEdge: UIRectEdge = .bottom
  
    var slidingPresentationTransition: SlidingPresentationTransition?
    
    /// 是否包含键盘
    open var isContainerAffectedByKeyboard: Bool { false }
    
    /// 是否支持滑动手势
    open var transitionCanSliding: Bool { true }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        initTransitioning()
    }
    
    required public init() {
        super.init(nibName: nil, bundle: nil)
        initTransitioning()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc open func initTransitioning() {
        self.modalPresentationCapturesStatusBarAppearance = true
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
   
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc open func cancelButtonTapped() {
        cancelButtonTappedBlock?()
        slidingPresentationTransition = nil
        dismiss(animated: true, completion: nil)
    }
}

extension SlidingPresentedViewController: UIViewControllerTransitioningDelegate {
    
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.slidingPresentationTransition = SlidingPresentationTransition.init(targetEdge: targetEdge, delegate: self)
        return self.slidingPresentationTransition
    }
    
    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlidingPresentationTransition.init(targetEdge: targetEdge, delegate: self)
    }
    
    open func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let controller = SlidingPresentationController(presentedViewController: presented,
                                                             presentingViewController: presenting,
                                                             targetEdge: targetEdge,
                                                             isContainerAffectedByKeyboard: isContainerAffectedByKeyboard)
        controller.delegate = self
        return controller
    }
}

extension SlidingPresentedViewController: SlidingPresentationDelegate {
    
    public func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        defer {
            self.cancelButtonTapped()
        }
        return false
    }
}

extension SlidingPresentedViewController: SlidingPresentationTransitionProtocol {
    
    public func presentationTransitionDismiss() {
        self.cancelButtonTapped()
    }
    
    public func presentationTransitionCanSliding() -> Bool {
        return transitionCanSliding
    }
}
