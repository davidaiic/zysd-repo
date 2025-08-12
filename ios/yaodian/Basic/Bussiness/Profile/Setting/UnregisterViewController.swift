//
//  UnregisterViewController.swift
//  Basic
//
//  Created by wangteng on 2023/4/19.
//

import UIKit

class UnregisterViewController: BaseViewController {

    lazy var tipLabel: UILabel = {
        let tipLabel = UILabel()
        tipLabel.font = UIFont.systemFont(ofSize: 16,weight: .semibold)
        tipLabel.textColor = UIColor(0xFC511E)
        tipLabel.backgroundColor = UIColor(0xFC511E, alpha: 0.1)
        tipLabel.text = "您即将开始账号注销流程"
        tipLabel.layer.cornerRadius = 4
        tipLabel.textAlignment = .center
        tipLabel.layer.masksToBounds = true
        return tipLabel
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        nameLabel.textColor = UIColor(0x333333)
        nameLabel.text = "用户须知"
        return nameLabel
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = UIColor(0x333333)
        textView.isEditable = false
        textView.linkTextAttributes = [:]
        textView.textContainerInset = .zero
        textView.backgroundColor = .clear
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        textView.text = "绑本账户的个人资料和历史信息(包括但不限于用户名、头像、浏览记录等)都将无法找回。您历史已获得的权益、等视为您自行放弃，将无法继续使用。您理解并同意，注销后，我们无法帮助您重新恢复。注销本账户并不代表本账户注销前的账户行为和相关责任得到豁免或减轻。 成功注销后所有的账号信息将会被删除且无法找回，使用原登录信息将会自动创建一个新账号，请谨慎操作。如您已仔细阅读上述【注销须知】后，仍执意注销您的账户，请提交注销申请，我们将在7日内处理你的注销申请，期间若重新登录，该申请将会被撤销。"
        return textView
    }()
    
    lazy var wrapper: UIStackView = {
        let wrapper = UIStackView()
        wrapper.axis = .horizontal
        wrapper.spacing = 10
        wrapper.distribution = .fillEqually
        return wrapper
    }()
    
    private lazy var bt: UIButton = {
        let baseBt = UIButton()
        baseBt.setTitle("申请注销", for: .normal)
        baseBt.setTitleColor(UIColor(0x0FC8AC), for: .normal)
        baseBt.layer.borderColor = UIColor(0x0FC8AC).cgColor
        baseBt.layer.borderWidth = 1
        baseBt.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        baseBt.layer.cornerRadius = 22
        return baseBt
    }()
    
    private lazy var bt1: UIButton = {
        let baseBt = UIButton()
        baseBt.setTitle("再想想", for: .normal)
        baseBt.setTitleColor(.white, for: .normal)
        baseBt.backgroundColor = .barTintColor
        baseBt.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        baseBt.layer.cornerRadius = 22
        return baseBt
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigation.item.title = "注销账号"
        navigation.bar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 17, weight: .medium)
        ]
        
        addNavigationLeft()
        
        view.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { make in
            make.top.equalTo(UIScreen.bind.navigationBarHeight+10)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(40)
        }
        
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(tipLabel)
            make.top.equalTo(tipLabel.snp.bottom).offset(20)
        }
        
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.bottom.equalTo(-UIScreen.bind.safeBottomInset-80)
        }
        
        view.addSubview(wrapper)
        wrapper.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-UIScreen.bind.safeBottomInset-10)
            make.height.equalTo(44)
        }
        
        wrapper.addArrangedSubview(bt)
        wrapper.addArrangedSubview(bt1)
        
        bt.bind.onTap { _ in
            
            Hud.show(.custom(contentView: HudSpinner()))
            UserManager.shared.logout { [weak self] in
                Hud.hide()
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        bt1.bind.onTap { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
    }
}
