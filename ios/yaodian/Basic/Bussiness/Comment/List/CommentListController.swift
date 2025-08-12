//
//  CommentListController.swift
//  Basic
//
//  Created by wangteng on 2023/3/17.
//

import Foundation

class CommentListController: BaseViewController {
    
    let manager = CommentListViewModel()
    
    lazy var sharedManager: BasicSharedManager = {
        BasicSharedManager()
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.tableFooterView = UIView(frame: .init(origin: .zero, size: .init(width: UIScreen.bind.width, height: 0.1)))
        tableView.backgroundColor = .background
        tableView.separatorStyle = .none
        tableView.register(cellType: EntryBannerTableCell.self)
        tableView.register(cellType: EntrySearchCell.self)
        tableView.register(cellType: EntryTotTableCell.self)
        tableView.register(cellType: CommentTableCell.self)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationLeft()
        manager.fetchDelegate = self
        self.navigation.item.title = "全部评论"
        navigation.bar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 17, weight: .medium)
        ]
        
        self.view.showHud(.custom(contentView: HudSpinner()) )
        tableView.alpha = 0
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        tableView.setupHeaderRefresh { [weak self] in
            guard let self = self else { return }
            self.manager.fetchComment(false)
        }
        
        manager.fetchComment(false)
    }
}

extension CommentListController: CompletionDelegate {
    
    func onCompletion(_ fetch: CompletionEnum) {
        tableView.stopRefreshing()
        view.hideHud()
        tableView.bind.animation(.fadeIn(duration: 0.25))
        switch fetch {
        case .onCompleted:
            self.view.emptyView.hide()
            self.tableView.reloadData()
        case .failure(let error):
            self.view.emptyView.show(failure: error) { [weak self] in
                guard let self = self else { return }
                self.view.showHud(.custom(contentView: HudSpinner()) )
                self.manager.fetchComment()
            }
        }
    }
}

extension CommentListController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath,cellType: CommentTableCell.self)
        let model = manager.comments[indexPath.row]
        cell.model = model
        cell.sharedBt.bind.addTargetEvent { [weak self] _ in
            guard let self = self else { return }
            self.shared(model)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return manager.comments[indexPath.row].height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = manager.comments[indexPath.row]
        CommentDetailController(id: model.commentId).bind.push()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let needFetch = indexPaths.contains { $0.row >= manager.comments.count-1}
        if needFetch {
            manager.fetchComment()
        }
        manager.prefetchRows(at: indexPaths)
    }
}

extension CommentListController {
    
    func shared(_ model: CommentModel) {
        self.view.showHud(.custom(contentView: HudSpinner()))
        BasicSharedApi.content(type: .comment(model.commentId)) { [weak self] content in
            self?.view.hideHud()
            guard let self = self, let content = content else { return }
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
