//
//  LoginViewController.swift
//  Nathan
//
//  Created by wangteng on 2020/10/19.
//  Copyright © 2020 wangteng. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController, StoryboardLoadable {

    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!

    @IBOutlet weak var codeBt: UIButton!
    @IBAction func loginButtonAction(_ sender: Any) {
        login()
    }
    
    var handler: (() -> Void)?
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var checkBt: UIButton!
    
    @IBAction func checkBt(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.checkLogin()
    }
    
    func login() {
        hideKeyboard()
        guard let mobile = mobileTF.text,
            mobile.count == 11 else {
            Toast.showMsg("手机号输入错误")
            self.mobileTF.becomeFirstResponder()
            return
        }
        guard let pw = passwordTF.text, !pw.isEmpty else {
            Toast.showMsg("请输入验证码")
            passwordTF.becomeFirstResponder()
            return
        }
        
        Hud.show(.custom(contentView: HudSpinner()))
        BasicApi("user/smsLogin")
            .addParameter(key: "phone", value: mobile)
            .addParameter(key: "code", value: pw)
            .perform { [weak self] result in
                Hud.hide()
                guard let self = self else { return }
                switch result {
                case .success(let res):
                    let user = res.model(User.self)
                    UserManager.shared.saveUser(user)
                    NotificationCenter.default.post(name: .userDidLogin, object: nil)
                    self.handler?()
                    UIWindow.bind.topViewController()?.dismiss(animated: true)
                   
                case .failure(let failure):
                    Toast.showMsg(failure.domain)
                }
            }
    }
 
    func hideKeyboard() {
        self.view.endEditing(true)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addClose()
        checkLogin()
        setupTextView()
      
        mobileTF.addTarget(self, action: #selector(textFieldValueChaned(_:)), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(textFieldValueChaned(_:)), for: .editingChanged)
        
        codeBt.bind.addTargetEvent { [weak self] _ in
            guard let self = self else { return }
            self.getCode()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        hideKeyboard()
    }
    
    func addClose() {
        let buttonBlock = {
            return BaseButton()
                .bind(.image(UIImage(named: "QuickLoginClose")))
                .bind(.contentEdgeInsets(.init(top: 0, left: 0, bottom: 0, right: 0)))
        }
        navigation.item.add(buttonBlock(), position: .left) { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
    }
    
    func setupTextView() {
        textView.linkTextAttributes = [:]
        textView.delegate = self
        let attributed = NSMutableAttributedString(string: "我已阅读并同意",
                                                  attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                   .foregroundColor: UIColor(0x333333)])
        
        let privacyConfiguration = AppWebPathConfiguration.shared.webPath(.privacyUser)
        let privacyUser = NSAttributedString(string: "《用户协议》",
                                             attributes: [
                                                .font: UIFont.systemFont(ofSize: 14),
                                                .foregroundColor: UIColor(0x0FC8AC),
                                                .link: privacyConfiguration.webURL]
        )
        
        attributed.append(privacyUser)
        
        let privacyProxyConfiguration = AppWebPathConfiguration.shared.webPath(.yszy)
        let privacyProxy = NSAttributedString(string: "《隐私政策》",
                                              attributes: [
                                                .font: UIFont.systemFont(ofSize: 14),
                                                .foregroundColor: UIColor(0x0FC8AC),
                                                .link: privacyProxyConfiguration.webURL]
        )
        attributed.append(privacyProxy)
        textView.attributedText = attributed
    }
    
    func getCode() {
        guard let mobile = mobileTF.text,
            mobile.count == 11 else {
            Toast.showMsg("手机号输入错误")
            self.mobileTF.becomeFirstResponder()
            return
        }
        
        Hud.show(.custom(contentView: HudSpinner()))
        BasicApi("user/sendSms")
            .addParameter(key: "phone", value: mobile)
            .perform { [weak self] result in
                Hud.hide()
                guard let self = self else { return }
                switch result {
                case .success:
                    self.passwordTF.becomeFirstResponder()
                    self.countDown()
                case .failure(let failure):
                    Toast.showMsg(failure.domain)
                }
            }
    }
    
    private func countDown() {
        Toast.showMsg("验证码已发送")
        self.codeBt.bind.countDown(time: 60, eventHandler: { (response) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if response <= 0 {
                    self.codeBt.setTitle("获取验证码", for: .normal)
                } else {
                    self.codeBt.setTitle(String(response)+"s后重新获取", for: .normal)
                }
            }
        }) { (response) -> Bool in
            return response < 1
        }
    }
    
    private func checkLogin() {
        if let mobile = mobileTF.text, mobile.count == 11,
           let pw = passwordTF.text, !pw.isEmpty,
           checkBt.isSelected {
            loginButton.isUserInteractionEnabled = true
            loginButton.isSelected = true
        } else {
            loginButton.isUserInteractionEnabled = false
            loginButton.isSelected = false
        }
    }
}

extension LoginViewController {
    
    @objc func textFieldValueChaned(_ textField: UITextField) {
        self.checkLogin()
    }
}

extension LoginViewController: UITextViewDelegate {
    
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        return linkHandler(textView, shouldInteractWith: URL, in: characterRange)
    }
    
    @available(iOS 10.0, *)
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return linkHandler(textView, shouldInteractWith: URL, in: characterRange)
    }
    
    private func linkHandler(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange) -> Bool {
        BaseWebViewController.init(webURL: url.absoluteString, navigationTitle: "上传图片").navigationPresent()
        return false
    }
}

extension UIViewController {
    
    func navigationPresent() {
        
        let navigation = UINavigationController(rootViewController: self)
        
        // config
        navigation.navigation.configuration.isEnabled = true
        navigation.navigation.configuration.isTranslucent = false
        navigation.navigation.configuration.barTintColor = UIColor(named: "barTintColor")
        navigation.navigation.configuration.tintColor = UIColor.white
        navigation.navigation.configuration.isShadowHidden = true
        navigation.navigation.configuration.statusBarStyle = .lightContent
        navigation.navigation.bar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 17, weight: .medium)
        ]
        navigation.modalPresentationStyle = .fullScreen
        UIWindow.bind.topViewController()?.present(navigation, animated: true)
    }
}
