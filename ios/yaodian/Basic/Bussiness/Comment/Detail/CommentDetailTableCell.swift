//
//  CommentDetailTableCell.swift
//  Basic
//
//  Created by wangteng on 2023/3/19.
//

import Foundation

class CommentDetailTableCell: CommentTableCell {
    
    lazy var delikeBt: BaseButton = {
        return BaseButton()
            .bind(.image(UIImage(named: "comment_like_s")))
            .bind(.title("点赞"))
            .bind(.color(UIColor(0x999999)))
            .bind(.axis(.horizontal))
            .bind(.spacing(3))
            .bind(.font(UIFont.systemFont(ofSize: 13)))
    }()
    
    var type: CommentDetailDetailType = .comment
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(delikeBt)
        delikeBt.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.right.equalTo(-15)
            make.height.equalTo(44)
        }
        addTargets()
    }
    
    private func addTargets() {
        delikeBt.bind.addTargetEvent { [weak self] _ in
            guard let self = self else { return }
            if self.type == .comment {
                self.model.likeOp { [weak self] in
                    guard let self = self else { return }
                    self.setUpLike()
                }
            } else {
                self.model.articleCommetLike { [weak self] in
                    guard let self = self else { return }
                    self.setUpLike()
                }
            }
        }
    }
    
    private func setUpLike() {
        if model.likeNum == 0 {
            delikeBt.titleLabel.text = "点赞"
        } else {
            delikeBt.titleLabel.text =  "\(model.likeNum)".bind.numberFormat
        }
        if model.isLike {
            delikeBt.imageView.image = "comment_liked_s".bind.image
        } else {
            delikeBt.imageView.image = "comment_like_s".bind.image
        }
    }
    
    override func updateData() {
        super.updateData()
        self.setUpLike()
    }
}
