//
//  CommodityOrderListController.swift
//  Basic
//
//  Created by wangteng on 2023/4/12.
//

import Foundation

class CommodityOrderListController: PageViewController, UIScrollViewDelegate {

    let manager = CircleInfomationViewModel()
    
    var pageModel = CommodityOrderManager.PageModel(type: .all)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.rowHeight = 126
        tableView.register(cellType: CircleInfomationCell.self)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        manager.fetchDelegate = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        tableView.setupHeaderRefresh { [weak self] in
            guard let self = self else { return }
            self.manager.fetch(false)
        }
        self.view.showHud(.custom(contentView: HudSpinner()))
        manager.fetch(false)
        
        addLoginNotification()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.pageDidSilde(scrollView)
    }
    
    override func userDidLogin() {
        self.view.showHud(.custom(contentView: HudSpinner()))
        manager.fetch(false)
    }
}

extension CommodityOrderListController: CompletionDelegate {
    
    func onCompletion(_ fetch: CompletionEnum) {
        view.hideHud()
        tableView.stopRefreshing()
        switch fetch {
        case .onCompleted:
            self.view.emptyView.hide()
            self.tableView.reloadData()
        case .failure(let failure):
            self.view.emptyView.wrapperView.backgroundColor = .white
            self.view.emptyView.show(failure: failure) { [weak self] in
                guard let self = self else { return }
                Hud.show(.custom(contentView: HudSpinner()) )
                self.manager.fetch()
            }
        }
    }
}

extension CommodityOrderListController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath,cellType: CircleInfomationCell.self)
        let model = manager.messages[indexPath.row]
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = manager.messages[indexPath.row]
        CommentDetailController(id: model.articleId, type: .info).bind.push()
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let needFetch = indexPaths.contains { $0.row >= manager.messages.count-1}
        if needFetch {
            manager.fetch()
        }
    }
}

