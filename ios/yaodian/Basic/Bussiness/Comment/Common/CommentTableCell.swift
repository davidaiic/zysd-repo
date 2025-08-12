//
//  CommentTableCell.swift
//  Basic
//
//  Created by wangteng on 2023/3/12.
//

import UIKit
import Bind
import Lantern

class CommentTableCell: UITableViewCell, Reusable {

    var model = CommentModel() {
        didSet {
            updateData()
        }
    }
    
    private lazy var avatar: UIImageView = {
        let avatar = UIImageView()
        avatar.layer.cornerRadius = 17.5
        avatar.layer.masksToBounds = true
        avatar.contentMode = .scaleAspectFill
        return avatar
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
    
    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.textColor = UIColor(0x333333)
        contentLabel.numberOfLines = 0
        return contentLabel
    }()
    
    lazy var boxView: BoxView = {
        let box = BoxView()
        box.layer.cornerRadius = 6
        box.clipsToBounds = true
        box.delegate = self
        return box
    }()
    
    lazy var likeBt: BaseButton = {
        return BaseButton()
            .bind(.title("点赞"))
            .bind(.color(UIColor(0x666666)))
            .bind(.axis(.horizontal))
            .bind(.spacing(3))
            .bind(.image(UIImage(named: "comment_like_s")))
            .bind(.font(UIFont.systemFont(ofSize: 13)))
    }()
    
    lazy var commentBt: BaseButton = {
        return BaseButton()
            .bind(.title("评论"))
            .bind(.color(UIColor(0x666666)))
            .bind(.spacing(3))
            .bind(.axis(.horizontal))
            .bind(.image(UIImage.init(named: "comment_message_s")))
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

    lazy var bottomOpWrapper: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 40
        stackView.distribution = .fillProportionally
        return stackView
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
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setup() {
        
        commentBt.isUserInteractionEnabled = false
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
        
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom)
            make.height.equalTo(16)
        }
        
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(avatar.snp.bottom).offset(10)
            make.right.equalTo(-15)
        }
        
        contentView.addSubview(boxView)
        
        contentView.addSubview(bottomOpWrapper)
        bottomOpWrapper.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.height.equalTo(47)
            make.bottom.equalTo(0)
        }
        
        bottomOpWrapper.addArrangedSubview(likeBt)
        bottomOpWrapper.addArrangedSubview(commentBt)
        bottomOpWrapper.addArrangedSubview(sharedBt)
        sharedBt.snp.makeConstraints { make in
            make.width.equalTo(30)
        }
        
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
        likeBt.bind.addTargetEvent { [weak self] btn in
            guard let self = self else { return }
            btn.isUserInteractionEnabled = false
            self.model.likeOp { [weak self] in
                btn.isUserInteractionEnabled = true
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
        if model.likeNum == 0 {
            likeBt.bind(.title("点赞"))
        } else {
            likeBt.bind(.title("\(model.likeNum)".bind.numberFormat))
        }
    }
    
    private func setUpComment() {
        if model.commentNum == 0 {
            commentBt.bind(.title("评论"))
        } else {
            commentBt.bind(.title("\(model.commentNum)".bind.numberFormat))
        }
    }
    
    func updateData() {
        avatar.kf.setImage(with: model.avatar.bind.url, placeholder: "place_holder".bind.image)
        nameLabel.text = model.username
        timeLabel.text = model.created
        contentLabel.text = model.content
        boxView.boxLayout = model.boxLayout
        boxView.snp.remakeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(contentLabel.snp.bottom).offset(model.pictures.isEmpty ? 0 : 10)
            make.size.equalTo(model.boxLayout.boxWrapperSize)
        }
        
        if model.showBottomOp {
            setUpComment()
            setUpLike()
            bottomOpWrapper.isHidden = false
        } else {
            bottomOpWrapper.isHidden = true
        }
    }
}

extension CommentTableCell: BoxViewDelegate {
    
    func didTaped(_ boxView: BoxView, index: Int, imageView: UIImageView) {
        openLantern(with: index)
    }
    
    func openLantern(with index: Int) {
        let lantern = Lantern()
        lantern.numberOfItems = {[weak self] in
            guard let self = self else { return 0}
            return self.model.boxLayout.imageURLs.count
        }

        lantern.cellClassAtIndex = { _ in
            LoadingImageCell.self
        }
        lantern.reloadCellAtIndex = { [weak self] context in
            guard let self = self else { return }
            guard let lanternCell = context.cell as? LoadingImageCell else {
                return
            }
            lanternCell.index = context.index
            let url = self.model.boxLayout.imageURLs[context.index]
            let placeholder = self.boxView.boxes[context.index].image
            lanternCell.reloadData(placeholder: placeholder, urlString: url)
        }
        lantern.transitionAnimator = LanternZoomAnimator(previousView: { [weak self] index -> UIView? in
            guard let self = self else { return nil }
            return self.boxView.boxes[index]
        })
        lantern.pageIndicator = LanternDefaultPageIndicator()
        lantern.pageIndex = index
        lantern.show()
    }
}


