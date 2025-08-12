//
//  MarkWrapper.swift
//  Basic
//
//  Created by wangteng on 2023/4/24.
//

import UIKit

class MarkWrapper: UIView {
    
    lazy var textLabel: BindInsLabel = {
        let label = BindInsLabel()
            .bind
            .font(.systemFont(ofSize: 11))
            .alignment(.center)
            .cornerRadius(2)
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
        addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.left.equalTo(4)
            make.right.equalTo(-4)
            make.top.bottom.equalTo(0)
        }
    }
    
    func setupModel(_ model: CommodityMarkFactory.CommodityMarkModel) {
        textLabel
            .bind
            .text(model.text)
            .foregroundColor(UIColor(model.color))
            .alignment(.center)
        
        textLabel.insicMaxWidth = model.maxWidth
        self.tag = CommodityMarkFactory.tag
        self.bind.backgroundColor(UIColor(model.color, alpha: 0.1)).cornerRadius(2)
    }
}
