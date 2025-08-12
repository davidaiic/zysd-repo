//
//  ProfileItemView.swift
//  Basic
//
//  Created by wangteng on 2023/3/19.
//

import Foundation

class ProfileItemView: UITableViewCell, Reusable {
    
    var model: ItemType = .feedback {
        didSet {
            icon.image = model.image
            lblLabel.text = model.rawValue
        }
    }
    
    private lazy var wrapper: UIView = {
        let wrapper = UIView()
        wrapper.backgroundColor = .white
        return wrapper
    }()
    
    private lazy var icon: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private lazy var arrow: UIImageView = {
        let view = UIImageView()
        view.image = "profile_arrow".bind.image
        return view
    }()
    
    lazy var lblLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(0x333333)
        return label
    }()
    
    lazy var divide: UIView = {
        let divide = UIView()
        divide.backgroundColor = UIColor(0xF2F3F5)
        return divide
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
        setup()
    }
    
    private func setup() {
        selectionStyle = .none
        backgroundColor = .background
        contentView.backgroundColor = .background
        contentView.addSubview(wrapper)
        wrapper.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.right.equalTo(0)
        }
        
        contentView.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.width.height.equalTo(34)
            make.centerY.equalToSuperview()
        }
        
        wrapper.addSubview(lblLabel)
        lblLabel.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(14)
            make.centerY.equalToSuperview()
        }
        
        wrapper.addSubview(arrow)
        arrow.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(divide)
        divide.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(0)
            make.height.equalTo(1)
        }
    }
}
