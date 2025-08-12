//
//  CircleInformationMark.swift
//  Basic
//
//  Created by wangteng on 2023/4/26.
//

import UIKit

class CircleInformationMarkView: UIView {

    lazy var collectionView: UICollectionView = {
        let flowLayout = TagLayout()
        flowLayout.minimumLineSpacing = 10
        flowLayout.delegate = self
        flowLayout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(cellType: CircleInformationMarkCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.isUserInteractionEnabled = false
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .clear
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()
    
    var marks: [CircleInformationMarkModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
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
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(0)
            make.top.equalTo(0)
        }
    }
}

extension CircleInformationMarkView: TagLayoutDelegate {
    
    func collectionView(_ layout: TagLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        marks[indexPath.row].textSize
    }
}

extension CircleInformationMarkView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        marks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemView = collectionView.dequeueReusableCell(for: indexPath, cellType: CircleInformationMarkCell.self)
        itemView.setup(marks[indexPath.row])
        return itemView
    }
}

class CircleInformationMarkCell: UICollectionViewCell, Reusable {
    
    lazy var textLabel: UILabel = {
        let label = UILabel()
            .bind
            .font(.systemFont(ofSize: 11))
            .alignment(.left)
        return label.base
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
        textLabel.numberOfLines = 0
        contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.left.equalTo(4)
            make.top.equalTo(4)
            make.right.equalTo(-4)
            make.bottom.equalTo(-4)
        }
    }
    
    func setup(_ model: CircleInformationMarkModel) {
        textLabel
            .bind
            .text(model.text)
            .foregroundColor(model.color)
            .font(model.font)
        
        self.contentView
            .bind
            .backgroundColor(model.backgroundColor)
        self.contentView.layer.cornerRadius = 3
        
        if model.isTag {
            textLabel.snp.remakeConstraints { make in
                make.left.equalTo(model.spacing)
                make.top.equalTo(model.spacing)
                make.right.equalTo(-model.spacing)
                make.bottom.equalTo(-model.spacing)
            }
        } else {
            textLabel.snp.remakeConstraints { make in
                make.left.equalTo(0)
                make.top.equalTo(model.spacing)
                make.right.equalTo(0)
                make.bottom.equalTo(-model.spacing)
            }
        }
    }
}

class CircleInformationMarkModel {
    
    var maxWidth: CGFloat = UIScreen.bind.width-125
    
    var text = ""
    
    var color: UIColor = UIColor("0x0FC8AC")
    
    var backgroundColor: UIColor = .white
    
    var font: UIFont = .systemFont(ofSize: 11)
    
    var textSize: CGSize = .zero
    
    var isTag = true
    
    var spacing: CGFloat = 4
    
    func setup() {
        let totalSpacing = spacing*2+1
        let exWidth: CGFloat = isTag ? totalSpacing : 1
        let width = text.bind.boundingRect(.fontWidth(height: 20, font: font)) + exWidth
        let height = text.bind.boundingRect(.fontHeight(width: maxWidth, font: font)) + totalSpacing
        textSize = .init(width: min(width, maxWidth), height: height)
    }
    
    init(text: String,
         isTag: Bool = true,
         maxWidth: CGFloat = UIScreen.bind.width-125,
         font: UIFont = .systemFont(ofSize: 11),
         color: UIColor = UIColor("0x0FC8AC"),
         backgroundColor: UIColor = UIColor("0x0FC8AC", alpha: 0.1)) {
        self.text = text
        self.isTag = isTag
        self.maxWidth = maxWidth - spacing*2+1
        self.font = font
        self.color = color
        self.backgroundColor = backgroundColor
        setup()
    }
}
