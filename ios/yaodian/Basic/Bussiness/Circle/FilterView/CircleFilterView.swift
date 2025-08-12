//
//  CircleFilterView.swift
//  Basic
//
//  Created by wangteng on 2023/3/20.
//

import Foundation
import Bind

class CircleFilterView: UIView {
    
    var toggleHandler: (() -> Void)?
    var detemineBtHandler : (() -> Void)?
    
    var filterModel = CircleFilterModel() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private lazy var blur: UIButton = {
        let blur = UIButton()
        blur.backgroundColor = UIColor(0x000000, alpha: 0)
        return blur
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
        collectionView.register(cellType: HoopFilterViewCell.self)
        collectionView.delegate = self
        collectionView.contentInset = .init(top: 5, left: 5, bottom: 0, right: 5)
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    lazy var wrapper: UIStackView = {
        let wrapper = UIStackView()
        wrapper.axis = .horizontal
        wrapper.spacing = 20
        wrapper.distribution = .fillEqually
        return wrapper
    }()
    
    private lazy var detemineBt: BaseButton = {
        let baseBt = BaseButton()
            .bind(.title("确定"))
            .bind(.backgroundColor(.barTintColor))
            .bind(.font(.systemFont(ofSize: 16)))
            .bind(.color(.white))
        return baseBt
    }()
    
    private lazy var resttingBt: BaseButton = {
        let baseBt = BaseButton()
            .bind(.title("重置"))
            .bind(.backgroundColor(.white))
            .bind(.font(.systemFont(ofSize: 16)))
            .bind(.color(UIColor(0x999999)))
        return baseBt
    }()
    
    var isShown = false
    
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

        self.blur.bind.addTargetEvent { [weak self]  _ in
            guard let self = self else { return }
            self.hide()
        }
        self.blur.clipsToBounds = true
        
        detemineBt.bind.addTargetEvent { [weak self] _ in
            guard let self = self else { return }
            self.hide()
            self.detemineBtHandler?()
        }
        
        resttingBt.bind.addTargetEvent { [weak self] _ in
            guard let self = self else { return }
            self.filterModel.resetting()
            self.collectionView.reloadData()
        }
        
        backgroundColor = .white
        self.frame = .init(origin: .init(x: 0, y: 0),
                           size: .init(width: UIScreen.bind.width, height: 300))
        
        self.clipsToBounds = true
      
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(-80)
        }
        
        addSubview(wrapper)
        resttingBt.layer.cornerRadius = 20
        resttingBt.layer.borderWidth = 1
        resttingBt.layer.borderColor = UIColor(0xE0E0E0).cgColor
        detemineBt.layer.cornerRadius = 20
        wrapper.addArrangedSubview(resttingBt)
        wrapper.addArrangedSubview(detemineBt)
        wrapper.snp.makeConstraints { make in
            make.left.equalTo(25)
            make.right.equalTo(-25)
            make.height.equalTo(40)
            make.bottom.equalTo(-20)
        }
        collectionView.reloadData()
    }
}

extension CircleFilterView {
    
    func toggle() {
        if self.isShown {
            self.hide()
        } else {
            self.show()
        }
    }
    
    func show() {
        guard let window = UIWindow.currentWindow else {
            return
        }
        self.isShown = true
        toggleHandler?()
        blur.frame = .init(origin: .init(x: 0, y: UIScreen.bind.navigationBarHeight), size: .init(width: window.bounds.width, height: window.bounds.height-UIScreen.bind.navigationBarHeight))
        window.addSubview(blur)
        UIView.animate(withDuration: 0.25) {
            self.blur.backgroundColor = UIColor(0x000000, alpha: 0.5)
        }
       
        blur.addSubview(self)
        self.frame.origin.y = -300
        UIView.animate(
            withDuration:  0.25,
            animations: {
                self.frame.origin.y = 0
            },
            completion: nil
        )
    }
    
    func hide(_ animated: Bool = true) {
        self.isShown = false
        toggleHandler?()
        UIView.animate(
            withDuration: animated ? 0.25 : 0,
            animations: {
                self.frame.origin.y = -300
                self.blur.backgroundColor = UIColor(0x000000, alpha: 0)
            },
            completion: { _ in
                self.removeFromSuperview()
                self.blur.removeFromSuperview()
            }
        )
    }
    
}

extension CircleFilterView: TagLayoutDelegate {
    
    func collectionView(_ layout: TagLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        filterModel.groups[indexPath.section].models[indexPath.row].size
    }
    
    func collectionView(_ layout: TagLayout, heightForHeader section: Int) -> CGFloat {
        return 40
    }
}

extension CircleFilterView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        filterModel.groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HistoryHeader", for: indexPath) as! HistoryHeader
        switch indexPath.section {
        case 0:
            header.title.text = filterModel.groups[indexPath.section].title
            header.clearButton.isHidden = true
            return header
        case 1:
            header.title.text = filterModel.groups[indexPath.section].title
            header.clearButton.isHidden = true
            return header
        default:
            return header
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        filterModel.groups[section].models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemView = collectionView.dequeueReusableCell(for: indexPath, cellType: HoopFilterViewCell.self)
        itemView.model = filterModel.groups[indexPath.section].models[indexPath.row]
        return itemView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let group = filterModel.groups[indexPath.section]
        if group.isMuti {
            group.models[indexPath.row].selected = !group.models[indexPath.row].selected
        } else {
            let selected = group.models[indexPath.row].selected
            group.models.forEach{ $0.selected = false }
            group.models[indexPath.row].selected = !selected
        }
        collectionView.reloadData()
    }
}

class HoopFilterViewCell: UICollectionViewCell, Reusable {
    
    var model = HoopFilterItemModel() {
        didSet {
            lblLabel.text = model.name
            if model.selected {
                lblLabel.textColor = .white
                contentView.backgroundColor = "#0FC8AC".color
            } else {
                lblLabel.textColor = "#333333".color
                contentView.backgroundColor = "#F2F3F5".color
            }
        }
    }
    
    lazy var lblLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = ""
        return label
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
        
        contentView.layer.cornerRadius = 4
        contentView.layer.masksToBounds = true
        contentView.addSubview(lblLabel)
        lblLabel.snp.makeConstraints { make in
            make.left.equalTo(8)
            make.right.equalTo(-8)
            make.top.bottom.equalTo(0)
        }
        
    }
}


