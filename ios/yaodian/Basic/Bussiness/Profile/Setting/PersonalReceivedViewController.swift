//
//  PersonalReceived.swift
//  Basic
//
//  Created by wangteng on 2023/3/25.
//

import Foundation

enum PersonalReceivedType: String, CaseIterable {
    
    case time = "收集时间段"
    case user_info = "用户基本信息"
    case use_info = "用户使用过程信息"
    case device = "设备属性信息"
}

class PersonalReceivedViewController: BaseViewController {
    
    @UserDefaultsWrapper(key: "personal.received.time")
    private var receivedTime: String?
    
    let profiles: [PersonalReceivedType] = PersonalReceivedType.allCases
    
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
        tableView.register(cellType: PersonalReceivedItemView.self)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addNavigationLeft()
        navigation.item.title = "个人信息收集清单"
        navigation.bar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 17, weight: .medium)
        ]
        
        if self.receivedTime == nil {
            self.receivedTime = "一天"
        }
        
        setupTableView()
        setupLogout()
    }
    
    private func setupLogout() {
        if UserManager.shared.hasLogin {
            view.addSubview(button)
            button.snp.makeConstraints { make in
                make.bottom.equalTo(-UIScreen.bind.safeBottomInset-10)
                make.left.equalTo(45)
                make.right.equalTo(-45)
                make.height.equalTo(44)
            }
            button.bind.addTargetEvent { [weak self] _ in
                guard let self = self else { return }
                self.logout()
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

extension PersonalReceivedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        profiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemView = tableView.dequeueReusableCell(for: indexPath, cellType: PersonalReceivedItemView.self)
        let type = profiles[indexPath.row]
        itemView.model = type
        if type == .time {
            itemView.rightLabel.text = self.receivedTime
            itemView.rightLabel.isHidden = false
        } else {
            itemView.rightLabel.isHidden = true
        }
        return itemView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        switch profiles[indexPath.row] {
        case .time:
            let titles = ["一天", "一周", "一个月"]
            SheetPop().pop(titles:titles) { [weak self] selectedIndex in
                guard let self = self else { return }
                self.receivedTime = titles[selectedIndex]
                self.tableView.reloadData()
            }
        case .user_info:
            BaseWebViewController(privacyType: .basicUserInfo).bind.push()
        case .use_info:
            BaseWebViewController(privacyType: .userUseInfo).bind.push()
        case .device:
            BaseWebViewController(privacyType: .deviceInfo).bind.push()
        }
    }
}

class PersonalReceivedItemView: UITableViewCell, Reusable {
    
    var model: PersonalReceivedType = .time {
        didSet {
            lblLabel.text = model.rawValue
            if model == .time {
                arrow.image = "profile_down".bind.image
            } else {
                arrow.image = "profile_arrow".bind.image
            }
        }
    }
    
    private lazy var wrapper: UIView = {
        let wrapper = UIView()
        wrapper.backgroundColor = .white
        return wrapper
    }()

     lazy var arrow: UIImageView = {
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
    
    lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(0x999999)
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
       
        wrapper.addSubview(lblLabel)
        lblLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        wrapper.addSubview(arrow)
        arrow.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        
        wrapper.addSubview(rightLabel)
        rightLabel.snp.makeConstraints { make in
            make.right.equalTo(arrow.snp.left).offset(-15)
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
