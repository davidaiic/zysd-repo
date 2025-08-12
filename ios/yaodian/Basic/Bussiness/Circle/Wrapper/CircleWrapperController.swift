//
//  HoopViewController.swift
//  Basic
//
//  Created by wangteng on 2023/3/13.
//

import UIKit
import KakaJSON

class CircleWrapperController: BaseViewController {
    
    let manager = EntryManager()
    
    var pageWrapperController = PageWrapperController()
    
    var selectIndex = 0 {
        didSet {
            pageWrapperController.selectIndex = selectIndex
        }
    }
    
    private lazy var bt: UIButton = {
        let baseBt = UIButton()
        baseBt.setImage("release_bt".bind.image, for: .normal)
        return baseBt
    }()
    
    lazy var headerView: CircleWrapperHeader = {
        let headerView = CircleWrapperHeader()
        headerView.delegate = self
        headerView.upwardDelegate = self
        headerView.textField.placeholder = "输入关键词，快速找圈找内容"
        return headerView
    }()
    
    lazy var filterView: CircleFilterView = {
        let filterView = CircleFilterView()
        return filterView
    }()
    
    private let filterViewModel = CircleFilterViewModel()
    
    lazy var filterBt: BaseButton = {
        return BaseButton()
            .bind(.title("筛选"))
            .bind(.image("navigation_down".bind.image))
            .bind(.color(.white))
            .bind(.spacing(3))
            .bind(.font(.systemFont(ofSize: 14, weight: .regular)))
            .bind(.axis(.horizontal))
            .bind(.contentEdgeInsets(.init(top: 10, left: 8, bottom: 10, right: 5)))
    }()

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         if self.filterView.isShown {
             self.filterView.hide(false)
         }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addUpwardSearchView()
        makePageController()
        addNavigationRight()
        addPublishBt()
        
        queryFilterData()
    }
    
    private func queryFilterData() {
        filterViewModel.fetchDelegate = self
        filterViewModel.preQueryData()
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
    
    open func addNavigationRight() {
        navigation.item.add(filterBt, position: .right) { [weak self] _ in
            guard let self = self else { return }
            
            if self.filterViewModel.model.groups.isEmpty {
                self.view.showHud(.custom(contentView: HudSpinner()))
                self.filterViewModel.queryData()
                return
            }
                
            self.filterView.filterModel = self.filterViewModel.model.copy()
            self.filterView.toggle()
        }
        self.filterView.toggleHandler = { [weak self] in
            guard let self = self else { return }
            self.filterBt.rotateImage()
        }
        self.filterView.detemineBtHandler = {  [weak self] in
            guard let self = self else { return }
            self.filterViewModel.model = self.filterView.filterModel.copy()
            self.reloadMessage()
        }
    }
}

extension CircleWrapperController: PageWrapperControllerDelegate {
    
    func heightForRow() -> CGFloat {
        view.bounds.height
    }
    
    private func reloadMessage() {
        
        if let commentController = self.pageWrapperController.controllers[0] as? CircleCommentController {
            commentController.reload(sortId: self.filterViewModel.sortIds(),
                                     labelId: self.filterViewModel.filterIds())
        }
        
        if let messageController = self.pageWrapperController.controllers[1] as? CircleInfomationController {
            messageController.reload(sortId: self.filterViewModel.sortIds(),
                                     labelId: self.filterViewModel.filterIds())
        }
    }
    
    func makePageController() {
        let controllers = ["评论", "资讯"].map { title -> PageViewController in
            if title == "评论" {
                let viewController = CircleCommentController()
                viewController.title = title
                return viewController
            }
            let viewController = CircleInfomationController()
            viewController.title = title
            return viewController
        }
        
        let pageController = PageWrapperController(controllers: controllers,
                                                   main: self,
                                                   selectIndex: self.selectIndex)
        pageController.delegate = self
        pageController.fixedSegement = true
        pageController.canLoad = true
        addChild(pageController)
        pageController.view.removeFromSuperview()
        pageController.view.backgroundColor = UIColor("#F2F3F3")
        self.view.addSubview(pageController.view)
        pageController.view.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        self.pageWrapperController = pageController
    }
}

extension CircleWrapperController: HoopHeaderViewDelegate {
    
    func didClickedUpward(at index: Int) {
        CircleSearchController(placeholder: "").bind.push()
    }
}

extension CircleWrapperController: SearchHeaderViewDelegate {
    
    func addUpwardSearchView() {
        self.navigation.item.titleView = headerView
        headerView.upwardSingleMarqueeView.bind.onTap { [weak self] _ in
            guard let self = self else { return }
            if self.filterView.isShown {
                self.filterView.hide()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    CircleSearchController(placeholder: "").bind.push()
                }
            } else {
                CircleSearchController(placeholder: "").bind.push()
            }
        }
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

extension CircleWrapperController: CompletionDelegate {
    
    func onCompletion(_ fetch: CompletionEnum) {
        view.hideHud()
        switch fetch {
        case .onCompleted:
            filterView.filterModel = filterViewModel.model
            filterView.toggle()
        case .failure:
           break
        }
    }
}
