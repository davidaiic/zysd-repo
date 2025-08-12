//
//  CommentDetailInfoCell.swift
//  Basic
//
//  Created by wangteng on 2023/3/19.
//

import Foundation

class CommentDetailInfoCell: UITableViewCell, Reusable {
    
    var info = CommentDetailInfoModel() {
        didSet {
            avatar.kf.setImage(with: info.avatar.bind.url)
            nameLabel.text = info.username
            timeLabel.text = info.created
            contentText.attributedText = info.attributedContent()
            markView.marks = info.marks
           
            markView.snp.remakeConstraints { make in
                make.height.equalTo(info.masksHeight)
                make.left.equalTo(nameLabel).offset(-10)
                make.top.equalTo(nameLabel.snp.bottom).offset(5)
                make.right.equalTo(-5)
            }
        }
    }
    
    private lazy var avatar: UIImageView = {
        let avatar = UIImageView()
        avatar.layer.cornerRadius = 17.5
        avatar.layer.masksToBounds = true
        avatar.contentMode = .scaleAspectFill
        return avatar
    }()
    
    lazy var divide: UIView = {
        let divide = UIView()
        divide.backgroundColor = UIColor(0xEAEAEA)
        return divide
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        nameLabel.textColor = UIColor(0x262626)
        return nameLabel
    }()
    
    lazy var timeLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        nameLabel.textColor = UIColor(0x8C8C8C)
        return nameLabel
    }()
    
    lazy var markView: CircleInformationMarkView = {
        CircleInformationMarkView()
    }()
    
    lazy var contentText: UILabel = {
        let contentText = UILabel()
        contentText.font = UIFont.systemFont(ofSize: 14)
        contentText.textColor = UIColor(0x333333)
        contentText.numberOfLines = 0
        return contentText
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
        contentView.addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.top.left.equalTo(15)
            make.width.height.equalTo(35)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatar.snp.right).offset(14)
            make.top.equalTo(avatar)
            make.height.equalTo(20)
        }
        
        contentView.addSubview(markView)
        markView.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.left).offset(-10)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.right.equalTo(-15)
        }
        
        contentView.addSubview(contentText)
        contentText.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(markView.snp.bottom).offset(10)
            make.right.equalTo(-15)
            make.bottom.equalTo(-15)
        }
    }
}
