//
//  ProfileHeaderView.swift
//  Basic
//
//  Created by wangteng on 2023/3/19.
//

import Foundation

class ProfileHeaderView: UIView {
    
    private lazy var avatar: UIImageView = {
        let avatar = UIImageView()
        avatar.image = "profile_avatar".bind.image
        avatar.contentMode = .scaleAspectFill
        return avatar
    }()
    
    private lazy var avatarWrapper: UIImageView = {
        let avatar = UIImageView()
        avatar.layer.cornerRadius = 27
        avatar.layer.masksToBounds = true
        avatar.backgroundColor = .white
        avatar.layer.borderWidth = 3
        avatar.layer.borderColor = UIColor(0x8BDCCE).cgColor
        return avatar
    }()
    
    private lazy var arrow: UIImageView = {
        let avatar = UIImageView()
        avatar.image = "profile_arrrow_white".bind.image
        return avatar
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        
        backgroundColor = .barTintColor
        
        addSubview(avatarWrapper)
        avatarWrapper.snp.makeConstraints { make in
            make.left.equalTo(21)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(54)
        }
        
        avatarWrapper.addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        
        addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarWrapper.snp.right).offset(15)
            make.centerY.equalTo(avatarWrapper)
        }
        
        addSubview(arrow)
        arrow.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        
        self.bind.onTap { _ in
            if UserManager.shared.hasLogin {
                PersonalInformationController.initFromSb().bind.push()
            } else {
                LoginManager.shared.showLogin()
            }
        }
    }
    
    func update() {
        if UserManager.shared.hasLogin, let user = UserManager.shared.user {
            avatarWrapper.kf.setImage(with: user.avatar.bind.url, placeholder: "place_holder".bind.image)
            userNameLabel.text = user.username
            avatar.image = nil
            arrow.isHidden = false
        } else {
            avatarWrapper.image = nil
            avatar.image = "profile_avatar".bind.image
            userNameLabel.text = "欢迎登录"
            arrow.isHidden = true
        }
    }
}
