//
//  CircleCommentController.swift
//  Basic
//
//  Created by wangteng on 2023/3/13.
//

import Foundation

class CircleCommentController: PageViewController, UIScrollViewDelegate {

    let manager = CircleCommentViewModel()
    
    lazy var sharedManager: BasicSharedManager = {
        BasicSharedManager()
    }()
    
    var isUnderTabBar = true
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.register(cellType: CommentTableCell.self)
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
            self.manager.fetchComment(false)
        }
        view.hud.top = -20
        view.showHud(.custom(contentView: HudSpinner()))
        manager.fetchComment(false)
        
        if isUnderTabBar {
            tableView.tableFooterView = UIView()
        } else {
            tableView.tableFooterView = UIView(frame:
                    .init(origin: .zero,
                          size: .init(width: UIScreen.bind.width, height: UIScreen.bind.safeBottomInset)
                         ))
        }
        
        addLoginNotification()
    }
    
    override func userDidLogin() {
        manager.fetchComment(false)
    }
    
    override func userDidLogout() {
        manager.fetchComment(false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.pageDidSilde(scrollView)
    }
    
    func reload(sortId: String, labelId: String) {
        tableView.setContentOffset(.zero, animated: false)
        
        manager.comments.removeAll()
        self.tableView.reloadData()
        view.showHud(.custom(contentView: HudSpinner()))
        
        manager.sortId = sortId
        manager.labelId = labelId
        manager.fetchComment(false)
    }
}

extension CircleCommentController: CompletionDelegate {
    
    func onCompletion(_ fetch: CompletionEnum) {
        view.hideHud()
        tableView.stopRefreshing()
        switch fetch {
        case .onCompleted:
            self.view.emptyView.hide()
            if manager.comments.isEmpty {
                self.view.emptyView.wrapperView.backgroundColor = .white
                self.view.emptyView.show(style: .empty("暂无评论内容"))
            }
            self.tableView.reloadData()
        case .failure(let failure):
            self.view.emptyView.wrapperView.backgroundColor = .white
            self.view.emptyView.show(failure: failure) { [weak self] in
                guard let self = self else { return }
                self.view.showHud(.custom(contentView: HudSpinner()) )
                self.manager.fetchComment()
            }
        }
    }
}

extension CircleCommentController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
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
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let needFetch = indexPaths.contains { $0.row >= manager.comments.count-1}
        if needFetch{
            manager.fetchComment()
        }
        manager.prefetchRows(at: indexPaths)
    }
}

extension CircleCommentController {
    
    func shared(_ model: CommentModel) {
        view.showHud(.custom(contentView: HudSpinner()))
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
