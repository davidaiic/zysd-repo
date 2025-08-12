//
//  BasicSharedView.swift
//  MotorFans
//
//  Created by wangteng on 2022/7/26.
//  Copyright © 2022 MotorFans, JDD. All rights reserved.
//

import UIKit

class BasicSharedView: UIView {

    var basicSharedModel = BasicSharedModel() {
        didSet {
            self.items = basicSharedModel.items
            configureItemSize()
            update()
        }
    }
    
    var items: [BasicSharedItemModel] = []
    
    var didSelectedBlock: ((BasicSharedItemModel) -> Void)?
    var closeBlock: (() -> Void)?
    
    var itemWidth: CGFloat = 0
    var sectionSpace: Int = 0
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(BasicSharedViewCell.self, forCellWithReuseIdentifier: "BasicSharedViewCell")
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    private lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var hideButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitle("取消", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(hideButtonAction), for: .touchUpInside)
        return btn
    }()
    
    private lazy var overLayView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        return view
    }()
    
    deinit {
        debugPrint("deinit--\(self)")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addHierarchy()
        configureItemSize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addHierarchy()
        configureItemSize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureItemSize() {
        guard !items.isEmpty else {
            return
        }
        
        var colum = 1
        let maxColum = UIScreen.bind.width > 320 ? 5 : 4
        switch items.count {
        case 0...maxColum:
            colum = items.count
        default:
            colum = maxColum
        }
       
        let space = CGFloat((CGFloat(UIScreen.bind.width)-CGFloat(colum*48))/CGFloat(colum+1))
        self.sectionSpace = Int(space*0.5)
        self.itemWidth = (UIScreen.bind.width-CGFloat(space))/CGFloat(colum)
    }
    
    private func addHierarchy() {
        
        addSubview(overLayView)
        addSubview(container)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(hideButtonAction))
        overLayView.addGestureRecognizer(tap)
        overLayView.snp.makeConstraints { make in
            make.left.top.right.equalTo(0)
            make.bottom.equalTo(container.snp.top)
        }
        
        container.addSubview(hideButton)
        hideButton.layer.cornerRadius = 22
        hideButton.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-15-UIScreen.bind.safeBottomInset)
            make.height.equalTo(44)
        }
        
        container.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.equalTo(0)
            make.top.equalTo(25)
            make.bottom.equalTo(hideButton.snp.top).offset(-25)
        }
    }
    
    func update() {
        container.snp.remakeConstraints { make in
            make.left.right.equalTo(0)
            make.bottom.equalTo(basicSharedModel.containerHeight)
            make.height.equalTo(basicSharedModel.containerHeight)
        }
        
        let roundedRect: CGRect = .init(x: 0, y: 0, width: UIScreen.bind.width, height: basicSharedModel.containerHeight)
        let maskPath = UIBezierPath(roundedRect: roundedRect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = roundedRect
        maskLayer.path = maskPath.cgPath
        container.layer.mask = maskLayer
        
        collectionView.reloadData()
    }
    
    func show() {
        guard let delegate =  UIApplication.shared.delegate,
              let window = delegate.window as? UIWindow else { return }
        self.frame = window.bounds
        window.addSubview(self)
        layoutIfNeeded()
        UIView.animate(withDuration: 0.2) {
            self.container.snp.remakeConstraints { make in
                make.left.right.equalTo(0)
                make.bottom.equalTo(0)
                make.height.equalTo(self.basicSharedModel.containerHeight)
            }
            self.layoutIfNeeded()
            self.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
        }
    }
    
    func hide() {
        layoutIfNeeded()
        UIView.animate(withDuration: 0.2) {
            self.container.snp.remakeConstraints { make in
                make.left.right.equalTo(0)
                make.bottom.equalTo(self.basicSharedModel.containerHeight)
                make.height.equalTo(self.basicSharedModel.containerHeight)
            }
            self.layoutIfNeeded()
            self.backgroundColor = .clear
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    @objc func hideButtonAction() {
        closeBlock?()
        hide()
    }
}

extension BasicSharedView: UICollectionViewDelegateFlowLayout,
                            UICollectionViewDelegate,
                           UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BasicSharedViewCell", for: indexPath)  as? BasicSharedViewCell ?? BasicSharedViewCell()
        cell.model = items[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets.init(top: 0, left: CGFloat(sectionSpace), bottom: 0, right: CGFloat(sectionSpace))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize.init(width: itemWidth, height: 69)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectedBlock?(items[indexPath.row])
        hide()
    }
}

class BasicSharedViewCell: UICollectionViewCell {
    
    var model = BasicSharedItemModel() {
        didSet {
            imageView.image = UIImage(named: model.imageNamed)
            lblLabel.text = model.title
            lblLabel.textColor = model.textColor
        }
    }
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.bind.cornerRadius(6)
        return view
    }()
    
    lazy var lblLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = #colorLiteral(red: 0.2666666667, green: 0.2666666667, blue: 0.2666666667, alpha: 1)
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addHierarchy()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addHierarchy()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addHierarchy() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(0)
            make.width.height.equalTo(48)
        }
        
        contentView.addSubview(lblLabel)
        lblLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(6)
            make.height.equalTo(15)
        }
    }
}
