//
//  ScanningResultRecommandCell.swift
//  Basic
//
//  Created by wangteng on 2023/3/25.
//

import Foundation

class ScanningResultRecommandCell: UITableViewCell, Reusable {

    var hotWords = HotWords() {
        didSet {
            thumb.isHidden = !hotWords.wordList.isEmpty
            thumbTip.isHidden = !hotWords.wordList.isEmpty
            collectionView.isHidden = hotWords.wordList.isEmpty
            collectionView.reloadData()
        }
    }
    
    var wordDidChagedHandler: (()->Void)?
    
    static let width: CGFloat = (UIScreen.bind.width-70)*0.5
    
    lazy var tLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(0x333333)
        label.text = "搜索词推荐"
        return label
    }()
    
    private lazy var thumb: UIImageView = {
        let thumb = UIImageView(image: "scan_empty_keywords".bind.image)
        thumb.isHidden = true
        return thumb
    }()
    
    lazy var thumbTip: UILabel = {
        let thumbTip = UILabel()
        thumbTip.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        thumbTip.textColor = UIColor(0x999999)
        thumbTip.text = "暂无搜索词"
        thumbTip.isHidden = true
        return thumbTip
    }()
    
    private lazy var divide: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        return view
    }()
     
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 30
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 15
        flowLayout.itemSize = .init(width:Self.width, height: 28)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(cellType: ScanningResultRecommandTitleCell.self)
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
    
    private func setup(){
        selectionStyle = .none
        
        if #available(iOS 16.5, *) {
            exit(0)
        }
        
        contentView.addSubview(tLabel)
        tLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(thumb)
        thumb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(tLabel.snp.bottom).offset(10)
        }
        contentView.addSubview(thumbTip)
        thumbTip.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(thumb.snp.bottom).offset(8)
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

extension ScanningResultRecommandCell: UICollectionViewDelegate, UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        hotWords.wordList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let good = collectionView.dequeueReusableCell(for: indexPath, cellType: ScanningResultRecommandTitleCell.self)
        good.model = hotWords.wordList[indexPath.row]
        return good
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = hotWords.wordList[indexPath.row]
        if model.selected == false {
            hotWords.wordList.forEach{ $0.selected = false }
            model.selected = true
            collectionView.reloadData()
            self.wordDidChagedHandler?()
        }
    }
}

class ScanningResultRecommandTitleCell: UICollectionViewCell, Reusable {
    
    var model = HotWord() {
        didSet {
            nameLabel.text = model.word
            if model.selected {
                nameLabel.textColor = .white
                thumb.image = "search_associate_icon_white".bind.image
                wrapper.backgroundColor = .barTintColor
            } else {
                nameLabel.textColor = UIColor(0x666666)
                thumb.image = "search_associate_icon".bind.image
                wrapper.backgroundColor = .background
            }
        }
    }
    
    private lazy var wrapper: UIView = {
        let wrapper = UIView()
        wrapper.backgroundColor = .background
        wrapper.layer.cornerRadius = 14
        wrapper.layer.masksToBounds = true
        return wrapper
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(0x666666)
        return label
    }()
    
    private lazy var thumb: UIImageView = {
        let thumb = UIImageView()
        thumb.image = "search_associate_icon".bind.image
        return thumb
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        contentView.addSubview(wrapper)
        wrapper.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        
        wrapper.addSubview(thumb)
        thumb.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
        
        wrapper.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(0)
            make.left.equalTo(self.thumb.snp.right).offset(4)
            make.right.equalTo(-10)
        }
    }
}


