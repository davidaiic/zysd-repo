//
//  EdgeInteractiveTransitionProtocol.swift
//  Pods
//
//  Created by wangteng on 2022/3/7.
//

import UIKit

public protocol SlidingPresentationTransitionProtocol: NSObjectProtocol {
    
    var scrollableView: UIScrollView? { get }
    
    var presentationTransitionScrollBlocked: Bool { get set }
    
    func presentationTransitionCanSliding() -> Bool
    
    func presentationTransitionDidScroll(_ scrollView: UIScrollView)
    
    func presentationTransitionDismiss()
}

extension SlidingPresentationTransitionProtocol {
    
    public func presentationTransitionCanSliding() -> Bool {
        return true
    }
    
    public func presentationTransitionDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            presentationTransitionScrollBlocked = false
        } else {
            presentationTransitionScrollBlocked = true
        }
        guard presentationTransitionScrollBlocked else {
            return
        }
        if scrollView.contentOffset.y != 0 {
            scrollView.contentOffset.y = 0
        }
    }
}
