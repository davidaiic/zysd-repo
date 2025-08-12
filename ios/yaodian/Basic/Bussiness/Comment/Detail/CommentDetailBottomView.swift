//
//  CommentDetailBottomView.swift
//  Basic
//
//  Created by wangteng on 2023/3/18.
//

import Foundation

class CommentDetailBottomView: UIView {
    
    var detailModel = CommentDetailModel() {
        didSet {
            let likeNum = detailModel.info.likeNum
            if likeNum > 0 {
                self.likeBt.titleLabel.text = "\(detailModel.info.likeNum)"
            } else {
                self.likeBt.titleLabel.text = "点赞"
            }
            
            if detailModel.info.isLike {
                likeBt.imageView.image = "comment_liked".bind.image
            } else {
                likeBt.imageView.image = "comment_like".bind.image
            }
        }
    }
    
    lazy var wrapper: UIStackView = {
        let wrapper = UIStackView()
        wrapper.axis = .horizontal
        wrapper.spacing = 10
        wrapper.distribution = .fill
        return wrapper
    }()
    
    lazy var leftView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(0xF2F3F5)
        view.layer.cornerRadius = 16
        return view
    }()
    
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(0x999999)
        label.text = "写下您的评论～"
        return label
    }()
    
    lazy var likeBt: BaseButton = {
        return BaseButton()
            .bind(.color(UIColor(0x666666)))
            .bind(.axis(.horizontal))
            .bind(.spacing(3))
            .bind(.image(UIImage(named: "comment_like")))
            .bind(.font(UIFont.systemFont(ofSize: 14)))
            .bind(.title("点赞"))
            .bind(.contentEdgeInsets(.init(top: 0, left: 5, bottom: 0, right: 5)))
    }()
    
    lazy var sharedBt: BaseButton = {
        return BaseButton()
            .bind(.image(UIImage.init(named: "comment_share")))
            .bind(.font(UIFont.systemFont(ofSize: 13)))
            .bind(.contentEdgeInsets(.init(top: 0, left: 5, bottom: 0, right: 5)))
    }()
    
    lazy var layerView: UIView = {
        let layerView = UIView()
        layerView.backgroundColor = .white
        layerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        layerView.layer.shadowColor = UIColor(0x000000).cgColor
        layerView.layer.shadowOpacity = 0.1
        layerView.layer.shadowRadius = 3
        return layerView
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

        backgroundColor = .white
        
        addSubview(wrapper)
        wrapper.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(11)
            make.right.equalTo(-15)
            make.height.equalTo(32)
        }
        
        leftView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.centerY.equalToSuperview()
        }
        
        wrapper.addArrangedSubview(leftView)
        wrapper.addArrangedSubview(likeBt)
        wrapper.addArrangedSubview(sharedBt)
    }
}
