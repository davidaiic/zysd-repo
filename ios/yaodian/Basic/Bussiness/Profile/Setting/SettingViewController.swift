//
//  SettingViewController.swift
//  Basic
//
//  Created by wangteng on 2023/3/19.
//

import Foundation

enum SettingType: String, CaseIterable {
    
    case user_agreement = "用户协议"
    case privacy_agreement = "隐私协议"
    case call = "关于掌上药店"
    case third = "第三方信息共享清单"
    case personal = "个人信息收集清单"
    case unregister = "注销账号"
    
    var image: UIImage? {
        switch self {
        case .user_agreement: return "setting_1".bind.image
        case .privacy_agreement: return "setting_2".bind.image
        case .call: return "setting_3".bind.image
        case .third: return "setting_4".bind.image
        case .personal: return "setting_5".bind.image
        case .unregister: return "zhuxiao".bind.image
        }
    }
}

class SettingViewController: BaseViewController {
    
    var profiles: [SettingType] = SettingType.allCases
    
    private lazy var button: UIButton = {
        return UIButton.makeCommon("退出登录")
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.rowHeight = 50
        tableView.register(cellType: SettingItemView.self)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNavigationLeft()
        
        view.backgroundColor = .white
        navigation.item.title = "设置中心"
        navigation.bar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 17, weight: .medium)
        ]
        
        if !UserManager.shared.hasLogin {
            profiles.removeAll(where: {$0 == .unregister})
        }
        
        setupTableView()
        view.addSubview(button)
        button.bind.addTargetEvent { [weak self] _ in
            guard let self = self else { return }
            self.logout()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !UserManager.shared.hasLogin {
            profiles.removeAll(where: {$0 == .unregister})
        }
        tableView.reloadData()
        
        if UserManager.shared.hasLogin {
            button.snp.remakeConstraints { make in
                make.bottom.equalTo(-UIScreen.bind.safeBottomInset-10)
                make.left.equalTo(45)
                make.right.equalTo(-45)
                make.height.equalTo(44)
            }
        } else {
            button.snp.remakeConstraints { make in
                make.bottom.equalTo(-UIScreen.bind.safeBottomInset-10)
                make.left.equalTo(45)
                make.right.equalTo(-45)
                make.height.equalTo(0)
            }
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.reloadData()
    }
    
    private func logout(){
        let title = "是否确定退出登录"
        BasicPopManager()
            .bind(.title("提示"))
            .bind(.title(title))
            .action(titles: ["退出","取消"]) { action in
                action.handler = { [weak self] selectedIndex -> Bool in
                    guard let self = self else { return true }
                    if selectedIndex == 0 {
                        
                        Hud.show(.custom(contentView: HudSpinner()))
                        UserManager.shared.logout { [weak self] in
                            Hud.hide()
                            guard let self = self else { return }
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                        return true
                    } else {
                        return true
                    }
                }
                action.configureHandler = { btn in
                    if btn.tag == 1 {
                        btn.backgroundColor = UIColor(0xF2F3F5)
                        btn.setTitleColor(UIColor(0x666666), for: .normal)
                    }
                }
                action.direction = .vertical
        }.pop()
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        profiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemView = tableView.dequeueReusableCell(for: indexPath, cellType: SettingItemView.self)
        itemView.model = profiles[indexPath.row]
        return itemView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = profiles[indexPath.row]
        switch type {
        case .personal:
            PersonalReceivedViewController().bind.push()
        case .user_agreement:
            AppWebPathConfiguration.shared.openWeb(.privacyUser)
        case .privacy_agreement:
            BaseWebViewController(privacyType: .privacy).bind.push()
        case .call:
            let aboutConfiguration = AppWebPathConfiguration.shared.webPath(.about)
            BaseWebViewController.init(webURL: aboutConfiguration.webURL, navigationTitle: aboutConfiguration.navigationTitle).bind.push()
        case .third:
            BaseWebViewController(privacyType: .thirdShareInventory).bind.push()
        case .unregister:
            UnregisterViewController().bind.push()
        }
    }
}

class SettingItemView: UITableViewCell, Reusable {
    
    var model: SettingType = .call {
        didSet {
            icon.image = model.image
            lblLabel.text = model.rawValue
        }
    }
    
    private lazy var wrapper: UIView = {
        let wrapper = UIView()
        wrapper.backgroundColor = .white
        return wrapper
    }()
    
    private lazy var icon: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private lazy var arrow: UIImageView = {
        let view = UIImageView()
        view.image = "profile_arrow".bind.image
        return view
    }()
    
    lazy var lblLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(0x333333)
        return label
    }()
    
    lazy var divide: UIView = {
        let divide = UIView()
        divide.backgroundColor = UIColor(0xF2F3F5)
        return divide
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        selectionStyle = .none
        backgroundColor = .white
        contentView.backgroundColor = .white
        contentView.addSubview(wrapper)
        wrapper.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.right.equalTo(0)
        }
        
        contentView.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.width.height.equalTo(18)
            make.centerY.equalToSuperview()
        }
        
        wrapper.addSubview(lblLabel)
        lblLabel.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }
        
        wrapper.addSubview(arrow)
        arrow.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(divide)
        divide.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(0)
            make.height.equalTo(1)
        }
    }
}
