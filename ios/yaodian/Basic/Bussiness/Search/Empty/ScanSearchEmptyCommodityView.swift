//
//  ScanEmptyCommodityView.swift
//  Basic
//
//  Created by wangteng on 2023/3/25.
//

import Foundation

class ScanSearchEmptyCommodityView: UITableViewCell, Reusable {

    var models: [ScanSearchEmptyHotCompany] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    lazy var tLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(0x333333)
        label.text = "国外仿制药热门厂家"
        return label
    }()
    
    private lazy var divide: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        return view
    }()
    
    static let width: CGFloat = (UIScreen.bind.width-45)*0.5
    static let height: CGFloat = ((UIScreen.bind.width-45)*0.5)*0.75+41
     
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 15
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 15
        flowLayout.itemSize = .init(width:Self.width, height: Self.height)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(cellType: ScanEmptyCommodityViewCell.self)
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
        
        contentView.addSubview(tLabel)
        tLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(10)
            make.height.equalTo(22)
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

extension ScanSearchEmptyCommodityView: UICollectionViewDelegate, UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let good = collectionView.dequeueReusableCell(for: indexPath, cellType: ScanEmptyCommodityViewCell.self)
        good.model = models[indexPath.row]
        return good
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let good = models[indexPath.row]
        let configuration = AppWebPathConfiguration.shared.webPath(.yccx)
        let webURL = configuration.webURL+"&companyId="+good.companyId
        BaseWebViewController.init(webURL: webURL, navigationTitle: configuration.navigationTitle).bind.push()
    }
}

class ScanEmptyCommodityViewCell: UICollectionViewCell, Reusable {
    
    var model = ScanSearchEmptyHotCompany() {
        didSet {
            thumb.kf.setImage(with: model.companyImage.bind.url, placeholder: "place_holder".bind.image)
            nameLabel.text = model.companyName
        }
    }
    
    private lazy var wrapper: UIView = {
        let wrapper = UIView()
        wrapper.backgroundColor = .white
        wrapper.layer.cornerRadius = 4
        wrapper.layer.masksToBounds = true
        wrapper.layer.borderColor = UIColor(0xE0E0E0).cgColor
        wrapper.layer.borderWidth = 1
        return wrapper
    }()
    
    lazy var bottomWrapper: UIStackView = {
        let wrapper = UIStackView()
        wrapper.axis = .vertical
        wrapper.spacing = 4
        wrapper.distribution = .fillProportionally
        return wrapper
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor(0x333333)
        return label
    }()
    
    private lazy var thumb: UIImageView = {
        let thumb = UIImageView()
        thumb.backgroundColor = .background
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
            make.left.top.right.equalTo(0)
            make.bottom.equalTo(-41)
        }
        
        wrapper.addSubview(bottomWrapper)
        bottomWrapper.snp.makeConstraints { make in
            make.top.equalTo(thumb.snp.bottom).offset(8)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        bottomWrapper.addArrangedSubview(nameLabel)
    }
}


