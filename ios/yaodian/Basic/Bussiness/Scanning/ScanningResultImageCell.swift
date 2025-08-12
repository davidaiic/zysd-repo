//
//  ScanningResultImageCell.swift
//  Basic
//
//  Created by wangteng on 2023/3/25.
//

import Foundation

class ScanningResultImageCell: UITableViewCell, Reusable {
    
    lazy var thumb: UIImageView = {
        let thumb = UIImageView()
        thumb.backgroundColor = .background
        thumb.layer.cornerRadius = 8
        thumb.layer.masksToBounds = true
        thumb.contentMode = .scaleAspectFill
        return thumb
    }()
    
    lazy var bt: BaseButton = {
        let baseBt = BaseButton()
            .bind(.axis(.horizontal))
            .bind(.image("font_icon".bind.image))
            .bind(.title("提取文字"))
            .bind(.spacing(4))
            .bind(.color(UIColor(0x0FC8AC)))
            .bind(.font(.systemFont(ofSize: 12)))
        return baseBt
    }()
    
    private lazy var divide: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        
        selectionStyle = .none
        
        contentView.addSubview(thumb)
        thumb.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(280)
            make.height.equalTo(210)
        }
        
        contentView.addSubview(bt)
        bt.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-10)
            make.height.equalTo(50)
        }
        
        contentView.addSubview(divide)
        divide.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(10)
        }
    }
}
