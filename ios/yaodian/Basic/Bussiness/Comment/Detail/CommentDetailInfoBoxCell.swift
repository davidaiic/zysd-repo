//
//  CommentDetailInfoBoxCell.swift
//  Basic
//
//  Created by wangteng on 2023/5/11.
//

import Foundation
import Lantern

class CommentDetailInfoBoxCell: UITableViewCell, Reusable {
    
    lazy var boxView: BoxView = {
        let box = BoxView()
        box.layer.cornerRadius = 6
        box.clipsToBounds = true
        box.delegate = self
        return box
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var info = CommentDetailInfoModel() {
        didSet {
            boxView.boxLayout = info.boxLayout
            boxView.snp.remakeConstraints { make in
                make.left.equalTo(15)
                make.top.equalTo(0)
                make.size.equalTo(info.boxLayout.boxWrapperSize)
            }
        }
    }
    
    private func setup() {
        selectionStyle = .none
        contentView.addSubview(boxView)
    }
}

extension CommentDetailInfoBoxCell: BoxViewDelegate {
    
    func didTaped(_ boxView: BoxView, index: Int, imageView: UIImageView) {
        openLantern(with: index)
    }
    
    func openLantern(with index: Int) {
        let lantern = Lantern()
        lantern.numberOfItems = {[weak self] in
            guard let self = self else { return 0}
            return self.info.boxLayout.imageURLs.count
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
            let url = self.info.boxLayout.imageURLs[context.index]
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
