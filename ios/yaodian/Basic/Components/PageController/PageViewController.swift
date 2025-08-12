//
//  PageChildViewController.swift
//  nathan
//
//  Created by wangteng on 2021/9/27.
//

import UIKit

public class PageViewController: BaseViewController {
    
    var canSilde = false
    
    var canLoad = false
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func pageDidSilde(_ scrollView: UIScrollView) {
        
        guard !canLoad else {
            return
        }
        
        let sildeView = scrollView
        if !self.canSilde {
            sildeView.contentOffset = .zero
        }
        if scrollView.contentOffset.y <= 0 {
            self.canSilde = false
            sildeView.contentOffset = .zero
            NotificationCenter.default.post(name: .pageWrapperTop, object: nil)
        }
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
