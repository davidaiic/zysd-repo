//
//  EntryTotTableCell.swift
//  Basic
//
//  Created by wangteng on 2023/3/12.
//

import UIKit
import Bind

class EntryTotTableCell: UITableViewCell, Reusable {

    var model = HotCommodity() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    lazy var tLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(0x333333)
        label.text = "热门药品"
        return label
    }()
    
    lazy var titleShadow: UIImageView = {
        let shadow = UIImageView()
        shadow.image = "title_shadow_image".bind.image
        return shadow
    }()
    
    private lazy var divide: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        return view
    }()
    
    static let width: CGFloat = (UIScreen.bind.width-45)*0.5
    static let height: CGFloat = ((UIScreen.bind.width-45)*0.5)*0.75+95
     
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 15
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 15
        flowLayout.itemSize = .init(width:Self.width, height: Self.height)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(cellType: CommodityCell.self)
        collectionView.delegate = self
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(){
        selectionStyle = .none
        
        contentView.addSubview(tLabel)
        tLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(titleShadow)
        titleShadow.snp.makeConstraints { make in
            make.left.right.equalTo(tLabel)
            make.bottom.equalTo(tLabel).offset(-3)
            make.height.equalTo(3)
        }
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(tLabel.snp.bottom).offset(10)
            make.bottom.equalTo(-25)
        }
        
        contentView.addSubview(divide)
        divide.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(10)
        }
    }
}

extension EntryTotTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        model.goodsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let good = collectionView.dequeueReusableCell(for: indexPath, cellType: CommodityCell.self)
        good.model = model.goodsList[indexPath.row]
        return good
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = model.goodsList[indexPath.row]
        model.open()
    }
}
