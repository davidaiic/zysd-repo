//
//  ProfileViewController.swift
//  Basic
//
//  Created by wangteng on 2023/3/15.
//

import Foundation

enum ItemType: String, CaseIterable {
    case histoy = "查询历史"
    case feedback = "意见反馈"
    case callUs = "联系我们"
    case sharedCode = "分享码"
    case setting = "设置"
    
    var image: UIImage? {
        switch self {
        case .histoy: return "profile_history".bind.image
        case .feedback: return "profile_feedback".bind.image
        case .callUs: return "profile_callUs".bind.image
        case .sharedCode: return "profile_qrcode".bind.image
        case .setting: return "profile_setting".bind.image
        }
    }
}

class ProfileViewController: BaseViewController {
    
    private lazy var headerView: ProfileHeaderView = {
        return ProfileHeaderView(frame: .init(origin: .zero, size: .init(width: UIScreen.bind.width, height: 100)))
    }()
    
    let profiles: [ItemType] = ItemType.allCases
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.rowHeight = 60
        tableView.register(cellType: ProfileItemView.self)
        return tableView
    }()
    
    lazy var tableBackgroundView: UIView = {
        let tableBackgroundView = UIView(frame: .init(origin: .zero,
                                                      size: .init(width: UIScreen.bind.width, height: 100)))
        tableBackgroundView.backgroundColor = .barTintColor
        return tableBackgroundView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigation.item.title = "我的"
        navigation.bar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 17, weight: .medium)
        ]
        setupTableView()
    }
    
    private func setupTableView() {
        
        let backgroundViewWrapper = UIView()
        backgroundViewWrapper.backgroundColor = .white
        backgroundViewWrapper.addSubview(tableBackgroundView)
        tableView.backgroundView = backgroundViewWrapper
        
        tableView.tableHeaderView = headerView
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.reloadData()
        
        fetchUserData()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(fetchUserData),
                                               name: .userDidLogin,
                                               object: nil)
    }
    
    @objc func fetchUserData() {
        UserManager.shared.updateUserInfo { [weak self] in
            guard let self = self else { return }
            self.headerView.update()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headerView.update()
        fetchUserData()
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableBackgroundView.bind.frame(.height(abs(scrollView.contentOffset.y)))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        profiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemView = tableView.dequeueReusableCell(for: indexPath, cellType: ProfileItemView.self)
        itemView.model = profiles[indexPath.row]
        return itemView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch profiles[indexPath.row] {
        case .callUs:
            AppWebPathConfiguration.shared.openWeb(.callUs)
        case .sharedCode:
            LoginManager.shared.loginHandler {
                ShareCodeWrapper().bind.push()
            }
        case .histoy:
            LoginManager.shared.loginHandler {
                AppWebPathConfiguration.shared.openWeb(.searchHistory)
            }
        case .feedback:
            AppWebPathConfiguration.shared.openWeb(.feedback)
        case .setting:
            SettingViewController().bind.push()
        }
    }
}
