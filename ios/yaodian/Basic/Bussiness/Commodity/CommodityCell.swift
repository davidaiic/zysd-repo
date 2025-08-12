//
//  BaseGoodsCell.swift
//  Basic
//
//  Created by wangteng on 2023/3/16.
//

import Foundation

class CommodityCell: UICollectionViewCell, Reusable {
    
    var model = CommodityModel() {
        didSet {
            thumb.kf.setImage(with: model.goodsImage.bind.url, placeholder: "place_holder".bind.image)
            
            /// 药品名称
            nameLabel.text = model.goodsName
            nameLabel.numberOfLines = model.numberOfLines
            
            risk.isHidden = model.risk == 0
            
            /// 药厂名称
            descLabel.text = model.companyName
            descLabel.numberOfLines = model.numberOfLines
            
            queryNumLabel.text = model.searchNum+"人查询过"
            
            /// 左上角标签
            mark.isHidden = model.drugProperties.isEmpty
            mark.backgroundColor = UIColor(model.drugPropertiesColor)
            mark.text = model.drugProperties
            
            setupTag()
        }
    }
    
    private func setupTag() {
        
        tagWrapper.subviews.forEach {
            if $0.tag == CommodityMarkFactory.tag {
                $0.removeFromSuperview()
            }
        }
        
        /// 国外获批上市标签
        if !model.marketTag.isEmpty {
            tagWrapper.addArrangedSubview(
                CommodityMarkFactory.makeText(.init(text: model.marketTag, color: "#FF9330"))
            )
        }
        
        /// 医保标签
        if !model.medicalTag.isEmpty {
            tagWrapper.addArrangedSubview(
                CommodityMarkFactory.makeText(.init(text: model.medicalTag, color: "#FF9330"))
            )
        }
        
        tagStackWrapper.isHidden = !model.hasTag
    }
    
    private lazy var wrapper: UIView = {
        let wrapper = UIView()
        wrapper.backgroundColor = .white
        wrapper.layer.cornerRadius = 4
        wrapper.layer.masksToBounds = true
        wrapper.layer.borderColor = UIColor(0xE0E0E0).cgColor
        wrapper.layer.borderWidth = 0.5
        return wrapper
    }()
    
    lazy var bottomWrapper: UIStackView = {
        let wrapper = UIStackView()
        wrapper.axis = .vertical
        wrapper.spacing = 4
        wrapper.distribution = .fillProportionally
        return wrapper
    }()
    
    lazy var tagWrapper: UIStackView = {
        let wrapper = UIStackView()
        wrapper.axis = .horizontal
        wrapper.spacing = 10
        return wrapper
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor(0x333333)
        return label
    }()
    
    lazy var descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(0x999999)
        return label
    }()
    
    lazy var queryNumLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(0x0FC8AC)
        return label
    }()
    
    private lazy var thumb: UIImageView = {
        let thumb = UIImageView()
        thumb.backgroundColor = .background
        thumb.contentMode = .scaleAspectFill
        thumb.clipsToBounds = true
        return thumb
    }()
    
    private lazy var risk: UIImageView = {
        let risk = UIImageView()
        risk.backgroundColor = .clear
        risk.image = "risk".bind.image
        risk.isHidden = true
        return risk
    }()
    
    lazy var mark: BindInsLabel = {
        let mark = BindInsLabel()
        mark.font = UIFont.systemFont(ofSize: 12)
        mark.textColor = .white
        mark.insicWidth = 12
        mark.insicMaxWidth = (UIScreen.bind.width-60)*0.5
        mark.textAlignment = .center
        mark.backgroundColor = UIColor(0x459BF0)
        return mark
    }()
    
    var tagStackWrapper = UIView()
    
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
            make.height.equalTo(self.thumb.snp.width).multipliedBy(0.75)
        }
        
        thumb.addSubview(risk)
        risk.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }

        wrapper.addSubview(mark)
        mark.snp.makeConstraints { make in
            make.left.top.equalTo(0)
            make.height.equalTo(18)
        }
        mark.bind.cornerRadius(4, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMaxYCorner])
        
        wrapper.addSubview(bottomWrapper)
        bottomWrapper.snp.makeConstraints { make in
            make.top.equalTo(thumb.snp.bottom).offset(6)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        bottomWrapper.addArrangedSubview(nameLabel)
        bottomWrapper.addArrangedSubview(descLabel)
        
        tagStackWrapper.addSubview(tagWrapper)
        bottomWrapper.addArrangedSubview(tagStackWrapper)
        tagStackWrapper.snp.makeConstraints { make in
            make.height.equalTo(22)
        }
        tagWrapper.snp.makeConstraints { make in
            make.left.top.bottom.equalTo(0)
            make.right.lessThanOrEqualTo(-10)
        }
        bottomWrapper.addArrangedSubview(queryNumLabel)
    }
}

class CommodityMarkFactory {
    
    static let tag = 888
    
    class CommodityMarkModel {
        
        var text = ""
        var color = ""
        
        var maxWidth: CGFloat = UIScreen.bind.width
        
        init(text: String, color: String, maxWidth: CGFloat = UIScreen.bind.width) {
            self.text = text
            self.color = color
            self.maxWidth = maxWidth
        }
    }
    
    class func makeText(_ model: CommodityMarkModel) -> MarkWrapper {
        let mark = MarkWrapper()
        mark.setupModel(model)
        return mark
    }
}
