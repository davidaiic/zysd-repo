//
//  TipView.swift
//  Basic
//
//  Created by wangteng on 2023/3/17.
//

import UIKit

class TipView: UIView {
    
    lazy var wrapper: UIView = {
        let wrapper = UIView()
        wrapper.backgroundColor = UIColor(0x0FC8AC, alpha: 0.1)
        wrapper.layer.borderWidth = 1
        wrapper.layer.borderColor = UIColor(0x0FC8AC).cgColor
        wrapper.layer.cornerRadius = 4
        return wrapper
    }()
    
    lazy var lblLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(0x666666)
        label.numberOfLines = 0
        label.text = ""
        return label
    }()
    
    lazy var bt: BaseButton = {
        let baseBt = BaseButton()
            .bind(.image("search_tip_close".bind.image))
        return baseBt
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
        addSubview(wrapper)
        wrapper.snp.makeConstraints { make in
            make.top.equalTo(5)
            make.left.equalTo(0)
            make.right.equalTo(-10)
            make.bottom.equalTo(0)
        }
        
        wrapper.addSubview(lblLabel)
        lblLabel.snp.makeConstraints { make in
            make.top.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-10)
        }
        
        addSubview(bt)
        bt.snp.makeConstraints { make in
            make.centerX.equalTo(wrapper.snp.right)
            make.centerY.equalTo(wrapper.snp.top)
        }
    }

}
