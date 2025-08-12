//
//  EntrySectionHeader.swift
//  Basic
//
//  Created by wangteng on 2023/3/20.
//

import Foundation
import Bind

class EntrySectionHeader: UITableViewHeaderFooterView, Reusable {
    
    lazy var lblLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(0x333333)
        label.text = "热门评论"
        return label
    }()
    
    lazy var moreBt: UIButton = {
        let moreBt = UIButton(type: .custom)
        moreBt.setTitle("更多", for: .normal)
        moreBt.setTitleColor(UIColor(0x0FC8AC), for: .normal)
        moreBt.titleLabel?.font = .systemFont(ofSize: 14)
        return moreBt
    }()
    
    lazy var titleShadow: UIImageView = {
        let shadow = UIImageView()
        shadow.image = "title_shadow_image".bind.image
        return shadow
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup() {
        contentView.backgroundColor = .white
        contentView.addSubview(lblLabel)
        lblLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(titleShadow)
        titleShadow.snp.makeConstraints { make in
            make.left.right.equalTo(lblLabel)
            make.bottom.equalTo(lblLabel).offset(-2)
            make.height.equalTo(3)
        }
        
        contentView.addSubview(moreBt)
        moreBt.snp.makeConstraints { make in
            make.right.equalTo(0)
            make.width.equalTo(68)
            make.top.bottom.equalTo(0)
        }
        
        moreBt.bind.addTargetEvent { _ in
            if let entryTab = UIWindow.currentWindow?.rootViewController as? EntryTabController,
               let navi = entryTab.viewControllers?[1] as? UINavigationController,
               let hoop = navi.viewControllers.first as? CircleWrapperController {
                entryTab.selectedIndex = 1
                hoop.selectIndex = 0
            }
        }
    }
    
    func setupTop(_ top: CGFloat) {
        lblLabel.snp.remakeConstraints { make in
            make.left.equalTo(15)
            make.centerY.equalToSuperview().offset(top)
        }
        
        moreBt.snp.remakeConstraints { make in
            make.right.equalTo(0)
            make.width.equalTo(68)
            make.top.equalTo(top)
            make.bottom.equalTo(0)
        }
    }
}
