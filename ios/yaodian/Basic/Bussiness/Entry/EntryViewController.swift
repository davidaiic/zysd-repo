//
//  EntryViewController.swift
//  Basic
//
//  Created by wangteng on 2023/3/5.
//

import UIKit

class EntryViewController: BaseViewController {
    
    let manager = EntryManager()
    
    lazy var sharedManager: BasicSharedManager = {
        BasicSharedManager()
    }()
    
    private lazy var bt: UIButton = {
        let baseBt = UIButton()
        baseBt.setImage("release_bt".bind.image, for: .normal)
        return baseBt
    }()
    
    lazy var headerView: EntryHeaderView = {
        let headerView = EntryHeaderView()
        headerView.delegate = self
        headerView.upwardDelegate = self
        headerView.textField.placeholder = "输入关键词，快速找圈找内容"
        return headerView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.tableFooterView = UIView(frame: .init(origin: .zero, size: .init(width: UIScreen.bind.width, height: 0.1)))
        tableView.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9764705882, blue: 0.9843137255, alpha: 1)
        tableView.separatorStyle = .none
        tableView.register(cellType: EntryBannerTableCell.self)
        tableView.register(cellType: EntrySearchCell.self)
        tableView.register(cellType: EntryTotTableCell.self)
        tableView.register(cellType: CommentTableCell.self)
        tableView.register(headerFooterViewType: EntrySectionHeader.self)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addUpwardSearchView()
        
        manager.fetchDelegate = self
        
        tableView.alpha = 0
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
     
        tableView.setupHeaderRefresh { [weak self] in
            guard let self = self else { return }
            self.fetch()
        }
        
        addPublishBt()
        
        if let entryTab = UIWindow.currentWindow?.rootViewController as? EntryTabController {
            view.hud.top = entryTab.tabBar.bounds.height*0.5
        }
        view.showHud(.custom(contentView: HudSpinner()))
        fetch()
        
        addLoginNotification()
    }
    
    override func userDidLogout() {
        self.fetch()
    }
    
    override func userDidLogin() {
        self.fetch()
    }
    
    private func fetch() {
        manager.fetchIndex()
        manager.fetchComment(false)
    }
 
    private func addPublishBt() {
        view.addSubview(bt)
        bt.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.bottom.equalTo(-80)
        }
        
        bt.bind.addTargetEvent { _ in
            LoginManager.shared.loginHandler {
                ReleaseViewController().bind.push()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if PrivacyPop.shared.canShow() {
            PrivacyPop.shared.show()
        }
    }
}

extension EntryViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return manager.hasBanner ? 1 : 0
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return manager.comments.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let bannerCel = tableView.dequeueReusableCell(for: indexPath,cellType: EntryBannerTableCell.self)
            bannerCel.entryModel = manager.entryModel
            return bannerCel
        case 1:
            let searchCell = tableView.dequeueReusableCell(for: indexPath,cellType: EntrySearchCell.self)
            searchCell.entryModel = manager.entryModel
            return searchCell
        case 2:
            let cell = tableView.dequeueReusableCell(for: indexPath,cellType: EntryTotTableCell.self)
            cell.model = manager.entryModel.hotCommodity
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(for: indexPath,cellType: CommentTableCell.self)
            let model = manager.comments[indexPath.row]
            cell.model = model
            cell.sharedBt.bind.addTargetEvent { [weak self] _ in
                guard let self = self else { return }
                self.shared(model)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return EntryBannerTableCell.bHeight
        case 1:
            return 349
        case 2:
            return manager.entryModel.hotCommodity.height
        case 3:
            return manager.comments[indexPath.row].height
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            let model = manager.comments[indexPath.row]
            CommentDetailController(id: model.commentId).bind.push()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0: return 0
        case 1: return 0
        case 2: return 0
        case 3: return 40
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0, 1, 2: return UIView(frame: .zero)
        case 3:
            let header = tableView.dequeueReusableHeaderFooterView(EntrySectionHeader.self)
            header?.setupTop(5)
            return header
        default: return UIView(frame: .zero)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        manager.prefetchRows(at: indexPaths)
    }
}

extension EntryViewController: CompletionDelegate {
    
    func onCompletion(_ fetch: CompletionEnum) {
        tableView.stopRefreshing()
        view.hideHud()
        tableView.bind.animation(.fadeIn(duration: 0.25))
        switch fetch {
        case .onCompleted:
            self.view.emptyView.hide()
            let searchTexts = self.manager.entryModel.searchTexts
            if !searchTexts.isEmpty {
                headerView.titles = searchTexts
                headerView.textField.placeholder = nil
            }
            self.tableView.reloadData()
        case .failure(let failure):
            self.view.emptyView.show(failure: failure) { [weak self] in
                guard let self = self else { return }
                self.view.showHud(.custom(contentView: HudSpinner()))
                self.manager.fetchIndex()
                self.manager.fetchComment(false)
            }
        }
    }
}

extension EntryViewController: EntryHeaderViewDelegate {
    
    func didClickedUpward(at index: Int) {
        var placeholder = ""
        let searchTexts = self.manager.entryModel.searchTexts
        if searchTexts.indices ~= index {
            placeholder = searchTexts[index]
        }
        SearchViewController(placeholder: placeholder).bind.push()
    }
}

extension EntryViewController: SearchHeaderViewDelegate {
    
    func addUpwardSearchView() {
        self.navigation.item.titleView = headerView
    }
    
    func didTapScan() {
        scanning(mode: .scan)
    }
    
    func didTapPhoto() {
        scanning(mode: .capture)
    }
    
    func didTapSearch() {
        SearchViewController(placeholder: "").bind.push()
    }
    
    func scanning(mode: ScanningView.Mode) {
        
        LoginManager.shared.loginHandler { [weak self] in
            guard let self = self else { return }
            let scanningController = ScanningController(type: .bar)
            scanningController.mode = mode
            scanningController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(scanningController, animated: true)
        }
    }
}

extension EntryViewController {
    
    func shared(_ model: CommentModel) {
        self.view.showHud(.custom(contentView: HudSpinner()))
        BasicSharedApi.content(type: .comment(model.commentId)) { [weak self] content in
            guard let self = self else { return }
            self.view.hideHud()
            guard let content = content else { return }
            let shareModel = BasicSharedModel(platformTypes: [.miniProgram])
            self.sharedManager.model = shareModel
            self.sharedManager.show { [weak self] _  in
                guard let self = self else { return true }
                self.sharedManager.content = content
                return true
            }
        }
    }
}
