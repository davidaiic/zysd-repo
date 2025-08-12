//
//  PageContainerViewControllerCell.swift
//  nathan
//
//  Created by wangteng on 2021/9/27.
//

import UIKit
import Bind

class PageWrapperCell: UITableViewCell {
    
    var didPage: ((Int)->Void)?
    
    var controllers: [PageViewController] = []
    
    var canLoad = false {
        didSet{ controllers.forEach{ $0.canLoad = canLoad } }
    }
    
    var canSilde: Bool = false {
        didSet{ controllers.forEach{ $0.canSilde = canSilde } }
    }
    
    public var hasSegement = false
    
    func selectedViewController(_ index: Int) {
        guard controllers.indices ~= index else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.25) {
            self.collectionView.scrollToItem(at: IndexPath(row: index, section: 0),
                                        at: UICollectionView.ScrollPosition.centeredHorizontally,
                                        animated: false)
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.delaysContentTouches = false
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.tag = 999
        collectionView.bounces = false
        collectionView.scrollsToTop = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(PageWrapperCollectionCell.self, forCellWithReuseIdentifier: "PageWrapperCollectionCell")
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.bottom.left.right.equalTo(0)
        }
        collectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PageWrapperCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        controllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageWrapperCollectionCell", for: indexPath) as! PageWrapperCollectionCell
        cell.setUpView(controllers[indexPath.row].view, hasSegement: hasSegement)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        bounds.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x/scrollView.bounds.size.width)
        didPage?(index)
    }
}

class PageWrapperCollectionCell: UICollectionViewCell {
    
    var controllerView: UIView?
    
    var hasSegement = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView(_ view: UIView, hasSegement: Bool) {
        
        self.controllerView = view
        self.hasSegement = hasSegement
        
        contentView.subviews.forEach{ $0.removeFromSuperview() }
        contentView.addSubview(view)
        view.snp.remakeConstraints { make in
            make.top.equalTo(UIScreen.bind.navigationBarHeight)
            make.left.right.equalToSuperview()
            if hasSegement {
                make.bottom.equalTo(-44)
            } else {
                make.bottom.equalTo(0)
            }
        }
    }
}
