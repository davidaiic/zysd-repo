//
//  LoginManager.swift
//  Basic
//
//  Created by wangteng on 2023/3/14.
//

import Foundation

class LoginManager: NSObject {

    static let shared = LoginManager()
    
    var handler: (() -> Void)?
    
    func showLogin() {
        Hud.show(.custom(contentView: HudSpinner()))
        QuickLoginManager.shared.getPhoneNumber { authorizeLogin in
            Hud.hide(afterDelay: 1)
            if authorizeLogin {
                QuickLoginManager.shared.login()
            } else {
                self.mobileLogin()
            }
        }
    }
    
    func mobileLogin() {
        let login = LoginViewController.initFromSb()
        login.handler = { [weak self] in
            guard let self = self else { return }
            self.triggerHandler()
        }
        let navigation = UINavigationController.init(rootViewController: login)
        navigation.navigation.configuration.isEnabled = true
        navigation.navigation.configuration.isShadowHidden = true
        navigation.navigation.configuration.statusBarStyle = .darkContent
        navigation.modalPresentationStyle = .fullScreen
        UIWindow.bind.topViewController()?.present(navigation, animated: true, completion: {
            
        })
    }
    
    func triggerHandler() {
        guard let handler = handler else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            handler()
            self.handler = nil
        }
    }
    
    func quickLogin(_ token: String) {
        BasicApi("user/oneLogin")
            .addParameter(key: "accessToken", value: token)
            .perform { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let res):
                    UserManager.shared.saveUser(res.model(User.self))
                    NotificationCenter.default.post(name: .userDidLogin, object: nil)
                    UIWindow.bind.topViewController()?.dismiss(animated: true)
                    self.triggerHandler()
                case .failure(let eror):
                    Toast.showMsg(eror.domain)
                }
        }
    }
    
    func loginHandler(_ handler: @escaping () -> Void) {
        guard UserManager.shared.hasLogin else {
            self.handler = handler
            LoginManager.shared.showLogin()
            return
        }
        handler()
    }
}
