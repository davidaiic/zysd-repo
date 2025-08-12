//
//  HoopSearchHeadView.swift
//  Basic
//
//  Created by wangteng on 2023/3/19.
//

import Foundation

public protocol HoopHeaderViewDelegate: AnyObject {
    
    func didClickedUpward(at index: Int)
}

class CircleWrapperHeader: SearchHeaderView {
    
    public var titles: [String] = [] {
        didSet {
            upwardSingleMarqueeView.reloadData()
        }
    }
    
    weak var upwardDelegate: HoopHeaderViewDelegate?
    
    public lazy var upwardSingleMarqueeView: MarqueeView = {
        let upwardSingleMarqueeView = MarqueeView()
        upwardSingleMarqueeView.delegate = self
        upwardSingleMarqueeView.stopWhenLessData = false
        upwardSingleMarqueeView.direction = .upward
        upwardSingleMarqueeView.touchEnabled = true
        upwardSingleMarqueeView.timeIntervalPerScroll = 4.0
        upwardSingleMarqueeView.timeDurationPerScroll = 0.5
        return upwardSingleMarqueeView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        self.scanBt.bind(.image("navigation_search".bind.image))
        self.textField.isUserInteractionEnabled = false
        self.textField.isHidden = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.wrapper.addSubview(upwardSingleMarqueeView)
        self.searchBtn.isHidden = true
        self.divive.isHidden = true
        self.photoBt.isHidden = true
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        updateUpwardLayout()
    }
    
    func updateUpwardLayout() {
        upwardSingleMarqueeView.frame = self.wrapper.bounds
        textField.bind.width += 80
        textField.bind.x -= 10
    }
}

extension CircleWrapperHeader: MarqueeViewDelegate {
    
    public func numberOfDataForMarqueeView(marqueeView: MarqueeView) -> Int {
        titles.count
    }
    
    public func createItemView(itemView: UIView, for marqueeView: MarqueeView) {
        let content = UILabel(frame: itemView.bounds)
        content.tag = 1001
        content.font = UIFont.systemFont(ofSize: 14)
        content.textColor = #colorLiteral(red: 0.5921568627, green: 0.6117647059, blue: 0.662745098, alpha: 1)
        itemView.addSubview(content)
    }
    
    public func updateItemView(itemView: UIView, atIndex: Int, for marqueeView: MarqueeView) {
        let content = itemView.viewWithTag(1001) as? UILabel
        content?.text = titles[atIndex]
    }

    public func numberOfVisibleItems(for marqueeView: MarqueeView) -> Int {
        1
    }
    
    public func didTouchItemView(atIndex: Int, for marqueeView: MarqueeView) {
        upwardDelegate?.didClickedUpward(at: atIndex)
    }
}
