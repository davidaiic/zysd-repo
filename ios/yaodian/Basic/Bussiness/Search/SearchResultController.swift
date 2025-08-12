//
//  SearchResultController.swift
//  Basic
//
//  Created by wangteng on 2023/3/6.
//

import UIKit

class SearchResultController: BaseViewController {

    enum EmptySource {
        case normal
        case scan
    }
    
    var source: EmptySource = .scan
    
    let manager = SearchResultViewModel()
    
    /// 搜索联想视图
    private lazy var associateViewController: SearchAssociateController = {
        SearchAssociateController()
    }()
    
    lazy var headerView: SearchHeaderView = {
        let headerView = SearchHeaderView()
        headerView.delegate = self
        headerView.textField.delegate = self
        return headerView
    }()
    
    lazy var emptyController: SearchResultEmptyController = {
        return SearchResultEmptyController()
    }()
    
    lazy var scanEmptyController: ScanSearchEmptyController = {
        return ScanSearchEmptyController()
    }()
    
    lazy var collectionView: UICollectionView = {
        let waterLayout = WaterLayout()
        waterLayout.minimumInteritemSpacing = 15
        waterLayout.minimumLineSpacing = 15
        waterLayout.delegate = self
        waterLayout.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: waterLayout)
        collectionView.register(cellType: CommodityCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.keyboardDismissMode = .onDrag
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationLeft()
        navigation.item.titleView = headerView
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        
        manager.fetchDelegate = self
        addEmptyController()
        search()
        
        if let placeholder = headerView.textField.placeholder, !placeholder.isEmpty {
            headerView.textField.enablesReturnKeyAutomatically = false
        }
        headerView.textField.addTarget(self, action: #selector(textFieldValueChaned(_:)), for: .editingChanged)
        
        /// 搜索联想视图
        addChild(associateViewController)
        view.addSubview(associateViewController.view)
        associateViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        associateViewController.selectedAssociateHandler = { [weak self] (value) in
            guard let self = self else {
                return
            }
            self.manager.keyword = value
            self.headerView.textField.text = value
            self.associateViewController.view.isHidden = true
            self.headerView.textField.resignFirstResponder()
            self.view.showHud(.custom(contentView: HudSpinner()))
            self.manager.clear()
            self.collectionView.reloadData()
            SearchHistoryCache.shared.add(value)
            self.manager.fetchGoods()
        }
        associateViewController.view.isHidden = true
    }
    
    private func addEmptyController() {
        switch source {
        case .normal:
            /// add empty controller
            emptyController.view.alpha = 0
            addChild(emptyController)
            view.addSubview(emptyController.view)
            emptyController.view.snp.makeConstraints { make in
                make.edges.equalTo(0)
            }
        case .scan:
            scanEmptyController.view.alpha = 0
            addChild(scanEmptyController)
            view.addSubview(scanEmptyController.view)
            scanEmptyController.view.snp.makeConstraints { make in
                make.edges.equalTo(0)
            }
        }
    }
    
    private func toggleEmptyController() {
        
        if self.manager.searchResultModel.goodsList.isEmpty {
            switch source {
            case .normal:
                self.emptyController.view.bind.animation(.fadeIn(duration: 0.25))
                self.emptyController.manager.fetch()
            case .scan:
                self.scanEmptyController.view.bind.animation(.fadeIn(duration: 0.25))
                self.scanEmptyController.manager.fetch()
            }
        } else {
            switch source {
            case .normal:
                self.emptyController.view.bind.animation(.fadeOut(duration: 0.25))
            case .scan:
                self.scanEmptyController.view.bind.animation(.fadeOut(duration: 0.25))
            }
        }
    }
    
    init(keyWords: String, source: EmptySource = .normal) {
        super.init(nibName: nil, bundle: nil)
        self.manager.keyword = keyWords
        self.headerView.textField.text = keyWords
        self.source = source
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchResultController {
    
    @objc func textFieldValueChaned(_ textField: UITextField) {
        setAssociateWords()
    }
    
    func setAssociateWords() {
        let keyWords = self.headerView.textField.text ?? ""
        if keyWords.isEmpty {
            associateViewController.view.isHidden = true
        } else {
            if self.headerView.textField.markedTextRange == nil {
                associateViewController.keyWords = keyWords
                associateViewController.view.isHidden = false
            }
        }
    }
}

extension SearchResultController: CompletionDelegate {
    
    func onCompletion(_ fetch: CompletionEnum) {
        self.view.hideHud()
        collectionView.bind.animation(.fadeIn(duration: 0.25))
        switch fetch {
        case .onCompleted:
            self.view.emptyView.hide()
            self.toggleEmptyController()
            self.collectionView.reloadData()
        case .failure(let failure):
            self.view.emptyView.show(failure: failure) { [weak self] in
                guard let self = self else { return }
                self.view.showHud(.custom(contentView: HudSpinner()) )
                self.manager.fetchGoods()
            }
        }
    }
}

extension SearchResultController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search()
        return true
    }
     
    func search() {
        associateViewController.view.isHidden = true
        if let text = headerView.textField.text, !text.isEmpty {
            if self.manager.isFetching {
                return
            }
            self.view.showHud(.custom(contentView: HudSpinner()))
            self.manager.keyword = text
            self.manager.clear()
            self.collectionView.reloadData()
            
            self.manager.fetchGoods()
            SearchHistoryCache.shared.add(text)
        } else if let placeholder = headerView.textField.placeholder, !placeholder.isEmpty {
            if self.manager.isFetching {
                return
            }
            self.view.showHud(.custom(contentView: HudSpinner()))
            self.manager.keyword = placeholder
            self.manager.clear()
            self.collectionView.reloadData()
            self.manager.fetchGoods()
        }
    }
}

extension SearchResultController: WaterLayoutDelegate {
    
    func collectionView(_ layout: WaterLayout,
                        heightForItemAt indexPath: IndexPath) -> CGFloat {
        manager.searchResultModel.goodsList[indexPath.row].size.height
    }
}

extension SearchResultController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
   
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let needFetch = indexPaths.contains { $0.row >= manager.searchResultModel.goodsList.count-1}
        if needFetch {
            manager.fetchGoods(true)
        }
    }
   
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        manager.searchResultModel.goodsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let good = collectionView.dequeueReusableCell(for: indexPath, cellType: CommodityCell.self)
        good.model = manager.searchResultModel.goodsList[indexPath.row]
        return good
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = manager.searchResultModel.goodsList[indexPath.row]
        model.open()
    }
}

extension SearchResultController: SearchHeaderViewDelegate {
    
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
        LoginManager.shared.loginHandler {
            let scanningController = ScanningController(type: .bar)
            scanningController.mode = mode
            scanningController.hidesBottomBarWhenPushed = true
            scanningController.bind.push()
        }
    }
}
