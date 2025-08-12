//
//  CircleInfomationCell.swift
//  Basic
//
//  Created by wangteng on 2023/3/20.
//

import Foundation

class CircleInfomationCell: UITableViewCell, Reusable {
    
    var model = MessageModel() {
        didSet {
            markView.marks = model.marks
            setUpLike()
            thumb.kf.setImage(with: model.cover.bind.url, placeholder: "place_holder".bind.image)
            lblLabel.text = model.title
            commentBt.bind(.title("\(model.commentNum)".bind.numberFormat(placeholder: "评论")))
        }
    }
 
    private lazy var thumb: UIImageView = {
        let thumb = UIImageView()
        thumb.backgroundColor = .background
        thumb.layer.cornerRadius = 10
        thumb.layer.masksToBounds = true
        thumb.contentMode = .scaleAspectFill
        return thumb
    }()
    
    lazy var markView: CircleInformationMarkView = {
        CircleInformationMarkView()
    }()
    
    lazy var lblLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor(0x333333)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var bottomOpWrapper: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 40
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    lazy var likeBt: BaseButton = {
        return BaseButton()
            .bind(.image(UIImage(named: "comment_like_s")))
            .bind(.title("点赞"))
            .bind(.color(UIColor(0x666666)))
            .bind(.axis(.horizontal))
            .bind(.spacing(3))
            .bind(.font(UIFont.systemFont(ofSize: 13)))
    }()
    
    lazy var tagWrapper: UIStackView = {
        let wrapper = UIStackView()
        wrapper.axis = .horizontal
        wrapper.spacing = 10
        return wrapper
    }()
    
    lazy var commentBt: BaseButton = {
        return BaseButton()
            .bind(.image(UIImage.init(named: "comment_message_s")))
            .bind(.title("评论"))
            .bind(.color(UIColor(0x666666)))
            .bind(.spacing(3))
            .bind(.axis(.horizontal))
            .bind(.font(UIFont.systemFont(ofSize: 13)))
    }()
    
    lazy var sharedBt: BaseButton = {
        return BaseButton()
            .bind(.image(UIImage.init(named: "comment_share_s")))
            .bind(.font(UIFont.systemFont(ofSize: 13)))
    }()
    
    lazy var divide: UIView = {
        let divide = UIView()
        divide.backgroundColor = UIColor(0xEAEAEA)
        return divide
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func setup() {
        selectionStyle = .none
        contentView.addSubview(thumb)
        thumb.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.width.height.equalTo(90)
            make.centerY.equalToSuperview()
        }

        contentView.addSubview(lblLabel)
        lblLabel.snp.makeConstraints { make in
            make.top.equalTo(18)
            make.left.equalTo(15)
            make.right.equalTo(thumb.snp.left).offset(-15)
            make.height.equalTo(40)
        }
        
        contentView.addSubview(markView)
        markView.snp.makeConstraints { make in
            make.bottom.equalTo(-47)
            make.left.equalTo(5)
            make.top.equalTo(lblLabel.snp.bottom).offset(5)
            make.right.equalTo(thumb.snp.left).offset(-10)
        }
        
        contentView.addSubview(bottomOpWrapper)
        bottomOpWrapper.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.height.equalTo(47)
            make.bottom.equalTo(0)
        }
        
        bottomOpWrapper.addArrangedSubview(likeBt)
        
        commentBt.isUserInteractionEnabled = false
        bottomOpWrapper.addArrangedSubview(commentBt)
        bottomOpWrapper.addArrangedSubview(sharedBt)
        
        contentView.addSubview(divide)
        divide.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(0)
            make.height.equalTo(0.5)
        }
       
        addTargets()
    }
    
    private func addTargets() {
        likeBt.bind.addTargetEvent { [weak self] _ in
            guard let self = self else { return }
            self.model.likeOp { [weak self] in
                guard let self = self else { return }
                self.setUpLike()
            }
        }
    }
    
    private func setUpLike() {
        if model.isLike {
            likeBt.bind(.image(UIImage(named: "comment_liked_s")))
        } else {
            likeBt.bind(.image(UIImage(named: "comment_like_s")))
        }
        likeBt.bind(.title("\(model.likeNum)".bind.numberFormat(placeholder: "点赞")))
    }
}
