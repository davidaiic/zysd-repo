//
//  QuickLogin.swift
//  Basic
//
//  Created by wangteng on 2023/3/14.
//

import UIKit
import TYRZUISDK

class QuickLoginManager: NSObject, UAFSDKLoginDelegate {

    static let shared = QuickLoginManager()
    
    override init() {
        super.init()
        register()
    }
    
    func register() {
        UAFSDKLogin.share.registerAppId("300011971743", appKey: "0D4A5AC08D89FD575A1A6AD9B0E96B7E")
        UAFSDKLogin.share.delegate = self
        
        self.getPhoneNumber { _ in
            
        }
    }
    
    func getPhoneNumber(completion: @escaping (Bool)->Void) {
        UAFSDKLogin.share.getPhoneNumberCompletion { res in
            guard let resultCode = res["resultCode"] as? String else {
                completion(false)
                return
            }
            if resultCode == "103000" {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func authorizeLogin(completion :@escaping (Bool)->Void) {
        UAFSDKLogin.share.mobileAuthCompletion { res in
            DispatchQueue.main.async {
                guard let resultCode = res["resultCode"] as? String else {
                    completion(false)
                    return
                }
                if resultCode == "103000" {
                    completion(true)
                } else {
                    if let desc = res["desc"] as? String {
                        Toast.showMsg(desc)
                    }
                    completion(false)
                }
            }
        }
    }
    
    func login() {
        
        let model = UAFCustomModel()
        model.currentVC = UIWindow.bind.topViewController()
        model.authLoadingViewBlock = { loadingView in
            Hud.show(.custom(contentView: HudSpinner()))
        }
        let loginImage = "QuickLoginBtn".bind.image!
        model.logBtnImgs = [loginImage, loginImage, loginImage]
        model.logBtnText = NSMutableAttributedString(string: "本机号码一键登录")
            .bind.font(UIFont.systemFont(ofSize: 16, weight: .medium))
            .foregroundColor(.white).base
        
        model.numberOffsetY = 290
        model.logBtnHeight = 44
        model.logBtnOffsetY = 350
        model.numberTextAttributes = [.font: UIFont.systemFont(ofSize: 20),
            .foregroundColor: UIColor(0x333333)]
        
        model.uncheckedImg = "QuickLoginUnSelected".bind.image
        model.checkedImg = "QuickLoginSelected".bind.image
        model.appPrivacyDemo = NSAttributedString(string: "我已阅读并同意&&默认&&和《用户协议》《隐私政策》",
                                                  attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                   .foregroundColor: UIColor(0x333333)])
        
        
        let privacyConfiguration = AppWebPathConfiguration.shared.webPath(.privacyUser)
        let privacyUser = NSAttributedString(string: "《用户协议》",
                                             attributes: [
                                                .link: privacyConfiguration.webURL]
        )
        
        let privacyProxyConfiguration = AppWebPathConfiguration.shared.webPath(.yszy)
        let privacyProxy = NSAttributedString(string: "《隐私政策》",
                                              attributes: [
                                                .link: privacyProxyConfiguration.webURL]
        )
        
        model.appPrivacy = [privacyUser,privacyProxy]
        model.privacySymbol = true
        model.privacyColor = UIColor(0x0FC8AC)
        model.privacyOffsetY = 430
        model.privacyUncheckAnimation = true
        model.checkboxWH = 18
        model.modalPresentationStyle = .fullScreen
        model.webNavColor = UIColor(named: "barTintColor")
        
        model.authViewBlock = { (customView, numberFrame, loginBtnFrame, checkBoxFrame, privacyFrame) in
            guard let view = customView else { return }
            let closeButton = BaseButton().bind(.image(UIImage(named: "QuickLoginClose")))
            view.addSubview(closeButton)
            closeButton.snp.makeConstraints { make in
                make.left.equalTo(15)
                make.top.equalTo(UIScreen.bind.statusBarHeight)
                make.width.height.equalTo(44)
            }
            closeButton.bind.onTap { _ in
                UIWindow.bind.topViewController()?.dismiss(animated: true)
            }
            
            let logo = UIImageView(image: "QuickLoginLogo".bind.image)
            view.addSubview(logo)
            logo.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(160)
                make.width.height.equalTo(100)
            }
            
            let otherBt = BaseButton()
                .bind(.title("其他登录方式"))
                .bind(.color(UIColor(0x666666)))
                .bind(.font(UIFont.systemFont(ofSize: 14)))
            
            view.addSubview(otherBt)
            otherBt.snp.makeConstraints { make in
                make.bottom.equalTo(-84)
                make.centerX.equalToSuperview()
            }
            otherBt.bind.onTap { _ in
                UIWindow.bind.topViewController()?.dismiss(animated: true, completion: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        LoginManager.shared.mobileLogin()
                    }
                })
            }
        }
        UAFSDKLogin.share.getAuthorizationWith(model) { res in
            if let dict = res as? NSDictionary,
               let resultCode = dict["resultCode"] as? String {
                if resultCode == "103000" {
                    if let token = dict["token"] as? String {
                        LoginManager.shared.quickLogin(token)
                    }
                }
            }
            Hud.hide()
        }
    }
  
}
