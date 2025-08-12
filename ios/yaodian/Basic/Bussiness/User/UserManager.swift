//
//  UserManager.swift
//  Drug
//
//  Created by wangteng on 2023/2/10.
//

import Foundation
import Bind

extension NSNotification.Name {
    static let userDidLogin = NSNotification.Name("com.user.login")
    static let userDidLogout = NSNotification.Name("com.user.logout")
}

class UserManager {
    
    static let shared = UserManager()
    
    init() {
        user = cacheUser?.kj.model(User.self)
    }
    
    @UserDefaultsWrapper(key: "cacheUserKey")
    private var cacheUser: String?
    
    var user: User?
    
    var hasLogin: Bool {
        user != nil
    }
    
    func saveUser(_ user: User) {
        cacheUser = user.kj.JSONString()
        self.user = user
    }
    
    func clearUser() {
        user = nil
        cacheUser = nil
        BaseWebViewController.clearWebsiteData()
    }
    
    func updateData(_ user: User) {
        guard let us = self.user else {
            return
        }
        us.username = user.username
        us.avatar = user.avatar
        us.mobile = user.mobile
        self.saveUser(us)
    }
}

extension UserManager {
    
    func updateUserInfo(completion: @escaping ()->Void) {
        guard UserManager.shared.hasLogin else {
            completion()
            return
        }
        BasicApi("user/center")
            .ignoreShowLogin(true)
            .perform { result in
                switch result {
                case .success(let res):
                    let user = res.model(User.self, key: "info")
                    UserManager.shared.updateData(user)
                    completion()
                case .failure:
                    completion()
                }
        }
    }
    
    func logout(completion: @escaping ()->Void) {
        guard UserManager.shared.hasLogin else {
            completion()
            return
        }
        BasicApi("user/logout")
            .ignoreShowLogin(true)
            .perform { _ in
                UserManager.shared.clearUser()
                NotificationCenter.default.post(name: .userDidLogout, object: nil)
                completion()
            }
    }
}
