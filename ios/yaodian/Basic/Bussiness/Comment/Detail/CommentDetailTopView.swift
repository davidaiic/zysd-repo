//
//  CommentDetailTopView.swift
//  Basic
//
//  Created by wangteng on 2023/3/19.
//

import Foundation

class CommentDetailTopView: UIView {
    
    var leftwardMarqueeViewData: [String] = ["凡涉及治疗方案/用药等内容均存在个体差异，请勿盲目效仿."] {
        didSet {
            upwardLeftMarqueeView.reloadData()
        }
    }
    
    lazy var upwardLeftMarqueeView: MarqueeView = {
        let upwardLeftMarqueeView = MarqueeView(frame: CGRect(x: 37.0, y: 0, width: UIScreen.bind.width-50, height: 28))
        upwardLeftMarqueeView.delegate = self
        upwardLeftMarqueeView.direction = .leftward
        upwardLeftMarqueeView.timeIntervalPerScroll = 0.0
        upwardLeftMarqueeView.scrollSpeed = 60.0
        upwardLeftMarqueeView.itemSpacing = 10.0
        upwardLeftMarqueeView.touchEnabled = true
        upwardLeftMarqueeView.stopWhenLessData = true
        return upwardLeftMarqueeView
    }()
    
    private lazy var noti: UIImageView = {
        let noti = UIImageView()
        noti.image = "comment_detail_noti".bind.image
        return noti
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
        addSubview(noti)
        noti.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        backgroundColor = UIColor(0xF2F3F5, alpha: 0.7)
        addSubview(upwardLeftMarqueeView)
        
        upwardLeftMarqueeView.reloadData()
    }
}

extension CommentDetailTopView: MarqueeViewDelegate {
    
    func numberOfDataForMarqueeView(marqueeView: MarqueeView) -> Int {
        return leftwardMarqueeViewData.count
    }
    
    func createItemView(itemView: UIView, for marqueeView: MarqueeView) {
        let content = UILabel()
        content.tag = 1002
        content.numberOfLines = 0
        content.font = UIFont.systemFont(ofSize: 12)
        content.textColor = UIColor(0x999999)
        itemView.addSubview(content)
        content.snp.makeConstraints { make in
            make.left.equalTo(5)
            make.top.bottom.equalTo(0)
            make.right.equalTo(-5)
        }
    }
    
    func updateItemView(itemView: UIView, atIndex: Int, for marqueeView: MarqueeView) {
        let text = leftwardMarqueeViewData[atIndex]
        let content = itemView.viewWithTag(1002) as? UILabel
        content?.text = text
    }
    
    func numberOfVisibleItems(for marqueeView: MarqueeView) -> Int {
        return 1
    }
    
    func didTouchItemView(atIndex: Int, for marqueeView: MarqueeView) {
       
    }
    
    func itemViewWidth(atIndex: Int, for marqueeView: MarqueeView) -> CGFloat {
        let text = leftwardMarqueeViewData[atIndex]
        let width = text.bind.boundingRect(.fontWidth(height: 28, font: UIFont.systemFont(ofSize: 12)))
        return width + 1
    }
    
    func itemViewHeight(atIndex: Int, for marqueeView: MarqueeView) -> CGFloat {
        return 28
    }
}
