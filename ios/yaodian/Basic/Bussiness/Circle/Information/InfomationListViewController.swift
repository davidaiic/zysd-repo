//
//  InfomationListViewController.swift
//  Basic
//
//  Created by wangteng on 2023/4/26.
//

import UIKit
import Bind
import Kingfisher

class InfomationListViewController: BaseViewController, UIScrollViewDelegate {

    let manager = CircleInfomationViewModel()

    lazy var sharedManager: BasicSharedManager = {
        BasicSharedManager()
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.register(cellType: CircleInfomationCell.self)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNavigationLeft()
        
        view.backgroundColor = .white
        navigation.item.title = "更多资讯"
        navigation.bar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 17, weight: .medium)
        ]
        
        manager.fetchDelegate = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        tableView.setupHeaderRefresh { [weak self] in
            guard let self = self else { return }
            self.manager.fetch(false)
        }
        
        view.hud.top = -20
        view.showHud(.custom(contentView: HudSpinner()))
        manager.fetch(false)
        
        addLoginNotification()
    }
    
    convenience init(keyword: String) {
        self.init(nibName: nil, bundle: nil)
        self.manager.keyword = keyword
    }
    
    override func userDidLogin() {
        manager.fetch(false)
    }
    
    override func userDidLogout() {
        manager.fetch(false)
    }
}

extension InfomationListViewController: CompletionDelegate {
    
    func onCompletion(_ fetch: CompletionEnum) {
        view.hideHud()
        tableView.stopRefreshing()
        switch fetch {
        case .onCompleted:
            self.view.emptyView.hide()
            if manager.messages.isEmpty {
                self.view.emptyView.wrapperView.backgroundColor = .white
                self.view.emptyView.show(style: .empty("暂无资讯内容"))
            }
            self.tableView.reloadData()
        case .failure(let failure):
            self.view.emptyView.wrapperView.backgroundColor = .white
            self.view.emptyView.show(failure: failure) { [weak self] in
                guard let self = self else { return }
                self.view.showHud(.custom(contentView: HudSpinner()) )
                self.manager.fetch()
            }
        }
    }
}

extension InfomationListViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath,cellType: CircleInfomationCell.self)
        let model = manager.messages[indexPath.row]
        cell.model = model
        cell.sharedBt.bind.addTargetEvent { [weak self] _ in
            guard let self = self else { return }
            self.shared(model)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = manager.messages[indexPath.row]
        CommentDetailController(id: model.articleId, type: .info).bind.push()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        manager.messages[indexPath.row].height
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let needFetch = indexPaths.contains { $0.row >= manager.messages.count-1}
        if needFetch {
            manager.fetch()
        }
    }
}

extension InfomationListViewController {
    
    func shared(_ model: MessageModel) {
        view.showHud(.custom(contentView: HudSpinner()))
        BasicSharedApi.content(type: .info(model.articleId)) { [weak self] content in
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
