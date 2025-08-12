//
//  SearchViewCell.swift
//  Basic
//
//  Created by wangteng on 2023/3/6.
//

import UIKit
import Bind

class SearchViewCell: UICollectionViewCell, Reusable {
    
    private lazy var wrapper: UIView = {
        let wrapper = UIView()
        wrapper.layer.cornerRadius = 14
        wrapper.backgroundColor = UIColor("#F6F7F8")
        wrapper.layer.masksToBounds = true
        return wrapper
    }()
    
    var model = HistoryModel(){
        didSet {
            expand.isHidden = !model.showExpand
            lblLabel.isHidden = model.showExpand
            lblLabel.text = model.title
        }
    }
    
    lazy var lblLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = "#666666".color
        label.textAlignment = .center
        return label
    }()
    
    private lazy var expand: UIImageView = {
        let expand = UIImageView()
        expand.isHidden = true
        expand.image = UIImage(named: "search_history_down")
        return expand
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
        
        contentView.addSubview(wrapper)
        wrapper.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        
        wrapper.addSubview(lblLabel)
        lblLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.bottom.equalTo(0)
        }
        
        wrapper.addSubview(expand)
        expand.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        
    }
}

class HistoryHeader: UICollectionReusableView {
    
    var title = UILabel()
    var clearButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(title)
        title.text = "历史记录"
        title.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        title.textColor = UIColor("#111E36")
        title.snp.makeConstraints { (maker) in
            maker.left.equalTo(13)
            maker.centerY.equalToSuperview().offset(5)
        }
        
        addSubview(clearButton)
        clearButton.setImage(UIImage(named: "search_history_delete"), for: .normal)
        clearButton.snp.makeConstraints { (maker) in
            maker.right.equalTo(-4)
            maker.width.equalTo(44)
            maker.centerY.equalTo(title)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SearchHotViewCell: UICollectionViewCell, Reusable {
    
    private lazy var wrapper: UIView = {
        let wrapper = UIView()
        return wrapper
    }()
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = UIColor(0xFC511E)
        return label
    }()
    
    lazy var lblLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = "#666666".color
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    lazy var textWrapper: UIView = {
        let textWrapper = UIView()
        textWrapper.backgroundColor = UIColor(0xF6F7F8)
        return textWrapper
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
        
        contentView.addSubview(wrapper)
        wrapper.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        
        wrapper.addSubview(numberLabel)
        numberLabel.layer.cornerRadius = 10
        numberLabel.layer.masksToBounds = true
        numberLabel.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        textWrapper.layer.cornerRadius = 14
        textWrapper.layer.masksToBounds = true
        
        wrapper.addSubview(textWrapper)
        textWrapper.snp.makeConstraints { make in
            make.left.equalTo(numberLabel.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.height.equalTo(28)
            make.right.equalTo(-10)
        }
        
        textWrapper.addSubview(lblLabel)
        lblLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.bottom.equalTo(0)
        }
    }
}

class SearchTipViewCell: UICollectionViewCell, Reusable {
    
    lazy var wrapper: TipView = {
        let wrapper = TipView()
        return wrapper
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
        contentView.addSubview(wrapper)
        wrapper.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
    }
}
