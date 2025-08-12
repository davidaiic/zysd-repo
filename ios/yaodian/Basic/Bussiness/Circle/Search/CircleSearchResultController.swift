//
//  CircleSearchResultController.swift
//  Basic
//
//  Created by wangteng on 2023/4/22.
//

import Foundation

class CircleSearchResultController: BaseViewController {
    
    var pageWrapperController = PageWrapperController()
    
    var selectIndex = 0 {
        didSet {
            pageWrapperController.selectIndex = selectIndex
        }
    }
    
    var keyword = ""
    
    private lazy var bt: UIButton = {
        let baseBt = UIButton()
        baseBt.setImage("release_bt".bind.image, for: .normal)
        return baseBt
    }()
    
    lazy var headerView: CircleSearchHeader = {
        let headerView = CircleSearchHeader()
        headerView.delegate = self
        headerView.textField.delegate = self
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
        
        addNavigationLeft()
        addUpwardSearchView()
        makePageController()
        addNavigationRight()
        addPublishBt()
        queryFilterData()
    }
    
    override func closePage() {
        if self.filterView.isShown {
            self.filterView.hide()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.bind.pop()
            }
        } else {
            self.bind.pop()
        }
    }
    
    init(keyWords: String) {
        super.init(nibName: nil, bundle: nil)
        self.headerView.textField.text = keyWords
        self.keyword = keyWords
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            
            if self.filterView.isShown {
                self.headerView.textField.isUserInteractionEnabled = false
                self.headerView.searchBtn.isUserInteractionEnabled = false
            } else {
                self.headerView.textField.isUserInteractionEnabled = true
                self.headerView.searchBtn.isUserInteractionEnabled = true
            }
        }
        
        self.filterView.detemineBtHandler = {  [weak self] in
            guard let self = self else { return }
            self.filterViewModel.model = self.filterView.filterModel.copy()
            self.reloadMessage()
        }
    }
}

extension CircleSearchResultController: PageWrapperControllerDelegate {
    
    func heightForRow() -> CGFloat {
        view.bounds.height
    }
    
    private func reloadMessage() {
        
        CircleSearchHistoryStorage.shard.add(self.keyword)
        
        if let commentController = self.pageWrapperController.controllers[0] as? CircleCommentController {
            commentController.manager.keyword = self.keyword
            commentController.reload(sortId: self.filterViewModel.sortIds(),
                                     labelId: self.filterViewModel.filterIds())
        }
        
        if let messageController = self.pageWrapperController.controllers[1] as? CircleInfomationController {
            messageController.manager.keyword = self.keyword
            messageController.reload(sortId: self.filterViewModel.sortIds(),
                                     labelId: self.filterViewModel.filterIds())
        }
    }
    
    func makePageController() {
        let controllers = ["评论", "资讯"].map { title -> PageViewController in
            if title == "评论" {
                let viewController = CircleCommentController()
                viewController.title = title
                viewController.isUnderTabBar = false
                viewController.manager.keyword = self.keyword
                return viewController
            }
            let viewController = CircleInfomationController()
            viewController.title = title
            viewController.isUnderTabBar = false
            viewController.manager.keyword = self.keyword
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

extension CircleSearchResultController: SearchHeaderViewDelegate {
    
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
        search()
    }
    
    func scanning(mode: ScanningView.Mode) {
        
    }
}

extension CircleSearchResultController: CompletionDelegate {
    
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

extension CircleSearchResultController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search()
        return true
    }
     
    func search() {
        let text = headerView.textField.text ?? ""
        guard self.keyword != text else {
            return
        }
        self.keyword = text
        reloadMessage()
    }
}
