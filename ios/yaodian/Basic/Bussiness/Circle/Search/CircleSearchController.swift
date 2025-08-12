//
//  CircleSearchController.swift
//  Basic
//
//  Created by wangteng on 2023/4/22.
//

import UIKit

class CircleSearchController: BaseViewController {
    
    let manager = CircleSearchManager()
    
    var placeholder = ""
    
    lazy var headerView: CircleSearchHeader = {
        let headerView = CircleSearchHeader()
        headerView.delegate = self
        headerView.textField.delegate = self
        if placeholder.isEmpty {
            headerView.textField.placeholder = "输入关键词，快速找圈找内容"
        } else {
            headerView.textField.placeholder = placeholder
        }
        return headerView
    }()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = TagLayout()
        flowLayout.minimumLineSpacing = 10
        flowLayout.delegate = self
        flowLayout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(HistoryHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "HistoryHeader")
        collectionView.register(cellType: SearchViewCell.self)
        collectionView.register(cellType: SearchHotViewCell.self)
        collectionView.register(cellType: SearchTipViewCell.self)
        collectionView.delegate = self
        collectionView.contentInset = .init(top: 5, left: 5, bottom: 0, right: 5)
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .clear
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        build()
        manager.fetchHot { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
    }
    
    init(placeholder: String) {
        super.init(nibName: nil, bundle: nil)
        self.placeholder = placeholder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        headerView.textField.becomeFirstResponder()
        manager.historyCache.reload()
        collectionView.reloadData()
    }
    
    func build() {
        navigation.item.titleView = headerView
        addNavigationLeft()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(0)
            make.top.equalTo(0)
        }
        collectionView.reloadData()
        if !placeholder.isEmpty {
            headerView.textField.enablesReturnKeyAutomatically = false
        }
    }
}

extension CircleSearchController: TagLayoutDelegate {
    
    func collectionView(_ layout: TagLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.section {
        case 0:
            return CGSize(width: UIScreen.bind.width-20, height: manager.hot.tipHeight)
        case 1:
            let width = manager.historyCache.histories[indexPath.row].width
            return CGSize(width: width, height: 28)
        default:
            return CGSize(width:(UIScreen.bind.width-40)*0.5, height: 30)
        }
    }
    
    func collectionView(_ layout: TagLayout, heightForHeader section: Int) -> CGFloat {
        if section == 1 && !manager.historyCache.histories.isEmpty {
            return 30
        }
        if section == 2 && !manager.hot.wordList.isEmpty {
            return 30
        }
        return 0
    }
}

extension CircleSearchController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HistoryHeader", for: indexPath) as! HistoryHeader
        switch indexPath.section {
        case 1:
            header.title.text = "历史记录"
            header.clearButton.isHidden = false
            header.clearButton.bind.addTargetEvent { [weak self] _ in
                guard let self = self else { return }
                self.manager.historyCache.clear()
                self.collectionView.reloadData()
            }
            return header
        case 2:
            header.title.text = "热门搜索"
            header.clearButton.isHidden = true
            return header
        default:
            return header
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return manager.hot.tipHeight == 0 ? 0 : 1
        case 1:
            return manager.historyCache.histories.count
        default:
            return manager.hot.wordList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let itemView = collectionView.dequeueReusableCell(for: indexPath, cellType: SearchTipViewCell.self)
            itemView.wrapper.lblLabel.text = manager.hot.searchTip
            itemView.wrapper.bt.bind.addTargetEvent { [weak self] _ in
                guard let self = self else { return }
                self.manager.hot.searchTip = ""
                self.collectionView.reloadData()
            }
            return itemView
        case 1:
            let itemView = collectionView.dequeueReusableCell(for: indexPath, cellType: SearchViewCell.self)
            itemView.model = manager.historyCache.histories[indexPath.row]
            return itemView
        default:
            let itemView = collectionView.dequeueReusableCell(for: indexPath, cellType: SearchHotViewCell.self)
            itemView.numberLabel.text = "\(indexPath.row+1)"
            itemView.lblLabel.text = manager.hot.wordList[indexPath.row].word
            
            switch indexPath.row {
            case 0:
                itemView.numberLabel.backgroundColor = UIColor(0xFC511E)
            case 1:
                itemView.numberLabel.backgroundColor = UIColor(0xFF9330)
            case 2:
                itemView.numberLabel.backgroundColor = UIColor(0xFDD986)
            case 3:
                itemView.numberLabel.backgroundColor = UIColor(0x999999)
            default: break
            }
            return itemView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let model = manager.historyCache.histories[indexPath.row]
            manager.historyCache.add(model.title)
            CircleSearchResultController(keyWords: model.title).bind.push()
        } else  if indexPath.section == 2 {
            let model = manager.hot.wordList[indexPath.row]
            manager.historyCache.add(model.word)
            CircleSearchResultController(keyWords: model.word).bind.push()
        }
    }
}

extension CircleSearchController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didTapedSearch()
        return true
    }
    
    func didTapedSearch() {
        if let text = headerView.textField.text, !text.bind.trimmed.isEmpty {
            manager.historyCache.add(text)
            self.collectionView.reloadData()
            CircleSearchResultController(keyWords: text).bind.push()
        } else {
            if !placeholder.isEmpty {
                CircleSearchResultController(keyWords: placeholder).bind.push()
            }
        }
    }
}

extension CircleSearchController: SearchHeaderViewDelegate {
   
    func didTapScan() {
        
    }
    
    func didTapPhoto() {
        
    }
    
    func didTapSearch() {
        didTapedSearch()
    }
}

