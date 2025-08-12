//
//  CommentDetailInfoImageCell.swift
//  Basic
//
//  Created by wangteng on 2023/3/19.
//

import Foundation

class CommentDetailInfoImageCell: UITableViewCell, Reusable {
    
    lazy var thumb: UIImageView = {
        let thumb = UIImageView()
        thumb.contentMode = .scaleAspectFill
        thumb.backgroundColor = .background
        thumb.clipsToBounds = true
        return thumb
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
            make.left.equalTo(25)
            make.top.equalTo(0)
            make.right.equalTo(-25)
            make.bottom.equalTo(-20)
        }
    }
}
