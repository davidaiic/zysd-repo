//
//  BaseViewController.swift
//  Basic
//
//  Created by wangteng on 2023/3/2.
//

import UIKit
import Bind
import EachNavigationBar

open class BaseViewController: UIViewController, UIGestureRecognizerDelegate {

    var backBarButtonItemBackHandler: (() -> Void)?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
    }
    
    func addLoginNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(userDidLogin),
                                               name: .userDidLogin,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(userDidLogout),
                                               name: .userDidLogout,
                                               object: nil)
    }
    
    func removeLoginNotification() {
        NotificationCenter.default.removeObserver(self)
    }
   
    @objc func userDidLogin() {
        
    }
    
    @objc func userDidLogout() {
        
    }
    
    open func addNavigationLeft() {
        let buttonBlock = {
            return BaseButton()
                .bind(.image(UIImage(named: "navigation_back_white")))
                .bind(.contentEdgeInsets(.init(top: 0, left: 0, bottom: 0, right: 0)))
        }
        navigation.item.add(buttonBlock(), position: .left) { [weak self] _ in
            guard let self = self else { return }
            self.closePage()
        }
    }
    
    func closePage() {
        self.backBarButtonItemBackHandler?()
        self.navigationController?.popViewController(animated: true)
    }
    
    func openPopGestureRecognizer(){
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    func closePopGestureRecognizer(){
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        debugPrint("\(self) dealloc")
    }
}

