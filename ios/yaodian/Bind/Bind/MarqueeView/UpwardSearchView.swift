//
//  UpwardTextField.swift
//  MotorFansKit
//
//  Created by wangteng on 2022/4/29.
//

import UIKit

@objc public protocol UpwardSearchViewDelegate: NSObjectProtocol {
    
    @objc optional func didClickedUpward(at index: Int)
}

@objcMembers
public class UpwardSearchView: UIView {
    
    public var titles: [String] = [] {
        didSet {
            upwardSingleMarqueeView.reloadData()
        }
    }
    
    public lazy var upwardSingleMarqueeView: MarqueeView = {
        let upwardSingleMarqueeView = MarqueeView()
        upwardSingleMarqueeView.delegate = self
        upwardSingleMarqueeView.stopWhenLessData = true
        upwardSingleMarqueeView.direction = .upward
        upwardSingleMarqueeView.touchEnabled = true
        upwardSingleMarqueeView.timeIntervalPerScroll = 4.0
        upwardSingleMarqueeView.timeDurationPerScroll = 0.5
        return upwardSingleMarqueeView
    }()
    
    public lazy var contentView: UIView = {
        let container = UIView()
        container.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9764705882, blue: 0.9843137255, alpha: 1)
        return container
    }()
    
    public weak var delegate: UpwardSearchViewDelegate?
    
    public lazy var searchIcon: UIImageView = {
        let searchIcon = UIImageView()
        searchIcon.contentMode = .scaleAspectFit
        searchIcon.isUserInteractionEnabled = true
        return searchIcon
    }()
    
    public var searchIconLeft: CGFloat = 5 {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    public var upwardSingleMarqueeViewLeft: CGFloat = 3 {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    public var contentInsets: UIEdgeInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5) {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
    }
    
    func configureHierarchy() {
        addSubview(contentView)
        contentView.addSubview(searchIcon)
        contentView.addSubview(upwardSingleMarqueeView)
        updateLayout()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }
    
    private func updateLayout() {
        contentView.frame = CGRect(x: contentInsets.left,
                                   y: contentInsets.top,
                                   width: self.frame.width-contentInsets.left-contentInsets.right,
                                   height: self.frame.height-contentInsets.top-contentInsets.bottom)
        
        var upwardSingleMarqueeViewLeft: CGFloat = searchIconLeft + self.upwardSingleMarqueeViewLeft
        if let searchIconSize = searchIcon.image?.size {
            searchIcon.frame = CGRect(x: searchIconLeft, y: (contentView.bounds.height-searchIconSize.height)*0.5,
                                      width: searchIconSize.width,
                                      height: searchIconSize.height)
            upwardSingleMarqueeViewLeft = searchIcon.frame.origin.x+searchIconSize.width+searchIconLeft + self.upwardSingleMarqueeViewLeft
        }
        
        upwardSingleMarqueeView.frame = CGRect(x: upwardSingleMarqueeViewLeft,
                                               y: 0,
                                               width: contentView.bounds.width-upwardSingleMarqueeViewLeft-searchIconLeft,
                                               height: contentView.bounds.height)
        contentView.layer.cornerRadius = contentView.bounds.height*0.5
    }
    
    open override var intrinsicContentSize: CGSize {
        UIView.layoutFittingExpandedSize
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UpwardSearchView: MarqueeViewDelegate {
    
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
        delegate?.didClickedUpward?(at: atIndex)
    }
}
