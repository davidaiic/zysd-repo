//
//  CommentDetailController.swift
//  Basic
//
//  Created by wangteng on 2023/3/15.
//

import Foundation
import Lantern

class CommentDetailController: BaseViewController {
    
    let viewModel = CommentDetailViewModel()
    
    private lazy var bottomView: CommentDetailBottomView = {
        return CommentDetailBottomView()
    }()
    
    lazy var topView: CommentDetailTopView = {
        return CommentDetailTopView()
    }()
    
    lazy var sharedManager: BasicSharedManager = {
        BasicSharedManager()
    }()
    
    let sendTextManager = SendTextManager()
    
    let sendManager = SendManager()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.register(cellType: CommentDetailTableCell.self)
        tableView.register(cellType: CommentDetailInfoCell.self)
        tableView.register(cellType: CommentDetailInfoBoxCell.self)
        return tableView
    }()
    
    convenience init(id: String, type: CommentDetailDetailType = .comment) {
        self.init(nibName: nil, bundle: nil)
        viewModel.identify = id
        viewModel.type = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationLeft()
        
        view.backgroundColor = .white
        self.navigation.item.title = viewModel.type.pageTitle
        navigation.bar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 17, weight: .medium)
        ]
        
        setupViews()
        view.showHud(.custom(contentView: HudSpinner()) )
        viewModel.fetchDelegate = self
        viewModel.fetch(false)
        addLoginNotification()
    }
    
    override func userDidLogin() {
        view.showHud(.custom(contentView: HudSpinner()))
        viewModel.fetch(false)
    }
    
    override func userDidLogout() {
        view.showHud(.custom(contentView: HudSpinner()))
        viewModel.fetch(false)
    }
    
    private func setupViews() {
        
        topView.leftwardMarqueeViewData = viewModel.type.marqueeViewData
        sendTextManager.sendTextView.maxImages = viewModel.type.sendMaxImages
        
        topView.alpha = 0
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(UIScreen.bind.navigationBarHeight)
            make.height.equalTo(28)
        }
        
        bottomView.leftView.bind.onTap { [weak self] _ in
            guard let self = self else { return }
            LoginManager.shared.loginHandler { [weak self] in
                guard let self = self else { return }
                self.sendTextManager.show()
            }
        }
        
        bottomView.likeBt.bind.addTargetEvent { [weak self] bt in
            guard let self = self else { return }
            bt.isUserInteractionEnabled = false
            self.viewModel.likeOp { [weak self] in
                bt.isUserInteractionEnabled = true
                guard let self = self else { return }
                self.bottomView.detailModel = self.viewModel.detailModel
            }
        }
        
        bottomView.sharedBt.bind.addTargetEvent { [weak self] _ in
            guard let self = self else { return }
            self.shared()
        }
        setupSendText()
        
        bottomView.alpha = 0
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(UIScreen.bind.safeBottomInset+50)
        }
        
        bottomView.bind.shadow(
            color: UIColor(0x000000),
            radius: 3,
            offset: CGSize(width: 0, height: 0),
            opacity: 0.1
        )
        
        tableView.alpha = 0
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.equalTo(0)
            make.bottom.equalTo(bottomView.snp.top)
        }
        view.bringSubviewToFront(bottomView)
    }
    
    private func setupSendText() {
        
        self.sendTextManager.sendTextView.doneBtnClickedHandler = { [weak self] (text, images) in
            guard let self = self else { return }
            if text.isEmpty {
                Toast.showMsg("请输入内容")
                return
            }
            Hud.show(.custom(contentView: HudSpinner()))
            self.sendManager.send(type: self.viewModel.type, id: self.viewModel.identify, text: text, images: images) { [weak self] msg in
                Hud.hide()
                guard let self = self else { return }
                if msg.isEmpty {
                    self.sendTextManager.resetting()
                    Toast.showMsg("发送成功")
                    self.viewModel.fetch(false)
                } else {
                    Toast.showMsg(msg)
                }
            }
        }
    }
}

extension CommentDetailController: CompletionDelegate {
    
    func onCompletion(_ fetch: CompletionEnum) {
        view.hideHud()
        tableView.bind.animation(.fadeIn(duration: 0.25))
        topView.bind.animation(.fadeIn(duration: 0.25))
        bottomView.bind.animation(.fadeIn(duration: 0.25))
        switch fetch {
        case .onCompleted:
            self.view.emptyView.hide()
            self.bottomView.detailModel = self.viewModel.detailModel
            self.tableView.reloadData()
        case .failure(let failure):
            self.view.emptyView.show(failure: failure) { [weak self] in
                guard let self = self else { return }
                self.view.showHud(.custom(contentView: HudSpinner()))
                self.viewModel.fetch(false)
            }
        }
    }
}

extension CommentDetailController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let needFetch = indexPaths.contains { $0.section == 1 && $0.row >= viewModel.detailModel.commentList.count-1}
        if needFetch{
            viewModel.fetch()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.detailModel.commentCnt == 0 {
            return 1
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            
            if viewModel.detailModel.info.pictures.isEmpty {
                return 1
            }
            return 2
            
        default:
            return viewModel.detailModel.commentList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let infoCell = tableView.dequeueReusableCell(for: indexPath,cellType: CommentDetailInfoCell.self)
                infoCell.info = viewModel.detailModel.info
                return infoCell
            }
            let imageCell = tableView.dequeueReusableCell(for: indexPath,cellType: CommentDetailInfoBoxCell.self)
            imageCell.info = viewModel.detailModel.info
            return imageCell
        default:
            let cell = tableView.dequeueReusableCell(for: indexPath,cellType: CommentDetailTableCell.self)
            cell.type = viewModel.type
            cell.model = viewModel.detailModel.commentList[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                return UITableView.automaticDimension
            }
            return viewModel.detailModel.info.boxLayout.boxHeight + 10
        default:
            return viewModel.detailModel.commentList[indexPath.row].height
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row > 0 {
            openLantern(with: indexPath.row-1)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0: return 0
        case 1: return 35
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            if !viewModel.detailModel.commentList.isEmpty {
                return 8
            }
            return 0
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            let header = UIView.init(frame: .init(x: 0, y: 0, width: UIScreen.bind.width, height: 35))
            header.backgroundColor = .white
            let number = UILabel(frame: .init(x: 15, y: 10, width: UIScreen.bind.width-30, height: 23))
            number.text = "评论(\(viewModel.detailModel.commentCnt))"
            number.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            number.textColor = UIColor(0x333333)
            header.addSubview(number)
            return header
        default: return UIView(frame: .zero)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 0:
            if !viewModel.detailModel.commentList.isEmpty {
                let divide = UIView.init(frame: .init(x: 0, y: 0, width: UIScreen.bind.width, height: 8))
                divide.backgroundColor = .background
                return divide
            }
            return UIView(frame: .zero)
        default: return UIView(frame: .zero)
        }
    }
}

extension CommentDetailController {
    
    func openLantern(with index: Int) {
        let lantern = Lantern()
        lantern.numberOfItems = {[weak self] in
            guard let self = self else { return 0 }
            return self.viewModel.detailModel.info.pictures.count
        }
        lantern.cellClassAtIndex = { _ in
            LoadingImageCell.self
        }
        lantern.reloadCellAtIndex = { [weak self] context in
            guard let self = self else { return }
            guard let lanternCell = context.cell as? LoadingImageCell else {
                return
            }
            lanternCell.index = context.index
            let imageURL = self.viewModel.detailModel.info.pictures[context.index]
            lanternCell.reloadData(placeholder: nil, urlString: imageURL)
        }
        lantern.transitionAnimator = LanternZoomAnimator(previousView: { _ -> UIView? in
            return nil
        })
        lantern.pageIndicator = LanternDefaultPageIndicator()
        lantern.pageIndex = index
        lantern.show()
    }
}

extension CommentDetailController {
 
    func shared() {
        view.showHud(.custom(contentView: HudSpinner()))
        
        var type: BasicSharedApi.ShareType = .comment(viewModel.identify)
        if viewModel.type == .comment {
            type = .comment(viewModel.identify)
        } else {
            type = .info(viewModel.identify)
        }
        
        BasicSharedApi.content(type: type) { [weak self] content in
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
