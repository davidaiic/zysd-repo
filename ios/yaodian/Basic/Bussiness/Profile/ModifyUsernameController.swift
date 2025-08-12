//
//  ModifyUsernameController.swift
//  Basic
//
//  Created by wangteng on 2023/3/29.
//

import Foundation

class ModifyUsernameController: BaseViewController {
    
    lazy var lblLabel: UILabel = {
        let label = UILabel()
        label.text = "请设置2-24个字符"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(0x666666)
        return label
    }()
    
    private lazy var textF: BindTextView = {
        let textF = BindTextView()
        textF.backgroundColor = .background
        textF.font = UIFont.systemFont(ofSize: 14)
        textF.textContainerInset = .init(top: 10, left: 5, bottom: 10, right: 50)
        textF.maxLength = 24
        textF.returnKeyType = .done
        return textF
    }()
    
    private lazy var cancelBt: BaseButton = {
        let baseBt = BaseButton()
            .bind(.title("取消"))
            .bind(.color(UIColor(0x0FC8AC)))
            .bind(.font(.systemFont(ofSize: 16)))
        return baseBt
    }()
    
    private lazy var saveBt: BaseButton = {
        let baseBt = BaseButton()
            .bind(.title("保存"))
            .bind(.color(.white))
            .bind(.font(.systemFont(ofSize: 16)))
            .bind(.backgroundColor(.barTintColor))
        return baseBt
    }()
    
    
    lazy var numberLabel: UILabel = {
        let numberLabel = UILabel()
        numberLabel.font = UIFont.systemFont(ofSize: 12)
        numberLabel.textColor = UIColor(0x999999)
        return numberLabel
    }()
    
    lazy var wrapper: UIStackView = {
        let wrapper = UIStackView()
        wrapper.axis = .horizontal
        wrapper.spacing = 10
        wrapper.distribution = .fillEqually
        return wrapper
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationLeft()
        
        view.backgroundColor = .white
        
        navigation.item.title = "编辑名字"
        navigation.bar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 17, weight: .medium)
        ]
        
        view.addSubview(lblLabel)
        lblLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(15+UIScreen.bind.navigationBarHeight)
        }
        
        textF.growingDelegate = self
        textF.layer.cornerRadius = 4
        textF.delegate = self
        textF.layer.borderWidth = 1
        textF.layer.borderColor = UIColor(0xE0E0E0).cgColor
        view.addSubview(textF)
        textF.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(lblLabel.snp.bottom).offset(10)
            make.right.equalTo(-15)
        }
        
        if let user = UserManager.shared.user {
            textF.text = user.username
            textDidChange(self.textF)
        }
        
        view.addSubview(wrapper)
        wrapper.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(40)
            make.top.equalTo(textF.snp.bottom).offset(20)
        }
        
        view.addSubview(numberLabel)
        numberLabel.snp.makeConstraints { make in
            make.centerY.equalTo(textF)
            make.right.equalTo(textF).offset(-10)
        }
        
        wrapper.addArrangedSubview(cancelBt)
        cancelBt.layer.cornerRadius = 20
        cancelBt.layer.masksToBounds = true
        cancelBt.layer.borderWidth = 1
        cancelBt.layer.borderColor = UIColor(0x0FC8AC).cgColor
        cancelBt.bind.addTargetEvent { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
        
        wrapper.addArrangedSubview(saveBt)
        saveBt.layer.cornerRadius = 20
        saveBt.bind.addTargetEvent { [weak self] _ in
            guard let self = self else { return }
            self.modifyName()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textF.becomeFirstResponder()
    }
    
    private func modifyName() {
        
        guard let text = self.textF.text,
              text.count >= 2,
              text.count <= 24 else {
            Toast.showMsg("请设置2-24个字符")
            return
        }
        
        Hud.show(.custom(contentView: HudSpinner()) )
        BasicApi("user/updateInfo")
            .addParameter(key: "nickname", value: self.textF.text ?? "")
            .perform { [weak self] res in
                Hud.hide()
                guard let self = self else { return }
                switch res {
                case .success:
                    UserManager.shared.user?.username = self.textF.text
                    Toast.show("修改成功") { [weak self] _ in
                        guard let self = self else { return }
                        self.navigationController?.popViewController(animated: true)
                    }
                case .failure(let failure):
                    Toast.showMsg(failure.domain)
                }
        }
    }
}

extension ModifyUsernameController: BindTextViewDelegate, UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            modifyName()
            return false
        }
        return true
    }
    
    func textViewDidChangeHeight(_ textView: BindTextView, height: CGFloat) {
        
    }
    
    func textBeyondMaxCount(_ textView: BindTextView) {
        
    }
    
    func textViewLineChange(_ textView: BindTextView, lineNumbers: Int) {
        
    }
    
    func textDidChange(_ textView: BindTextView) {
        numberLabel.text = "\(textView.text.count)/24"
    }
}
