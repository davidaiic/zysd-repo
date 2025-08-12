//
//  MarqueeView.swift
//  MotorFansKit_Example
//
//  Created by wangteng on 2022/4/27.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

@objc public protocol MarqueeViewDelegate: NSObjectProtocol {
    
    func numberOfDataForMarqueeView(marqueeView: MarqueeView) -> Int
    
    func createItemView(itemView: UIView, for marqueeView: MarqueeView)
    
    func updateItemView(itemView: UIView, atIndex: Int, for marqueeView: MarqueeView)
    
    @objc optional func numberOfVisibleItems(for marqueeView: MarqueeView) -> Int
    
    @objc optional func itemViewWidth(atIndex: Int, for marqueeView: MarqueeView) -> CGFloat
    
    @objc optional func itemViewHeight(atIndex: Int, for marqueeView: MarqueeView) -> CGFloat
    
    @objc optional func didTouchItemView(atIndex: Int, for marqueeView: MarqueeView)
}

@objcMembers
public class MarqueeView: UIView {

    @objc public enum Direction: Int {
        /// scroll from bottom to top
    case upward
        /// scroll from right to left
    case leftward
    }
    
    let DEFAULT_VISIBLE_ITEM_COUNT = 2
    
    public weak var delegate: MarqueeViewDelegate?
    
    public var timeIntervalPerScroll: TimeInterval = 4.0

    public var timeDurationPerScroll: TimeInterval = 1.0
    
    public var useDynamicHeight = false
    
    public var scrollSpeed: Float = 40.0
    
    public var itemSpacing: CGFloat = 20.0
    
    public var stopWhenLessData = true
    
    var touchReceiver: MarqueeViewTouchReceiver?
    
    public var touchEnabled = false {
        didSet {
            if touchEnabled {
                if touchReceiver == nil {
                    let touchReceiver = MarqueeViewTouchReceiver()
                    touchReceiver.touchDelegate = self
                    addSubview(touchReceiver)
                    touchReceiver.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        touchReceiver.rightAnchor.constraint(equalTo: self.rightAnchor),
                        touchReceiver.topAnchor.constraint(equalTo: self.topAnchor),
                        touchReceiver.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                        touchReceiver.leftAnchor.constraint(equalTo: self.leftAnchor)
                    ])
                    self.touchReceiver = touchReceiver
                } else {
                    bringSubviewToFront(self.touchReceiver!)
                }
            } else {
                if touchReceiver != nil {
                    touchReceiver?.removeFromSuperview()
                    touchReceiver = nil
                }
            }
        }
    }
    
    private var isPausingBeforeTouchesBegan = false
    private var isPausingBeforeResignActive = false
    private var isScrollNeedsToStop = false
    private var isWaiting = false
    private var isScrolling = false
    private var visibleItemCount = 1
    private var firstItemIndex = 0
    private var dataIndex = 0
    private var scrollTimer: Timer?
    private var items: [MarqueeItemView] = []
    
    public var direction: MarqueeView.Direction = .upward
    
    public lazy var contentView: UIView = {
        let contentView = UIView(frame: self.bounds)
        contentView.clipsToBounds = true
        return contentView
    }()
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.bounds
        self.repositionItemViews()
    }
    
    public func reloadData() {
        if isWaiting {
            if scrollTimer != nil {
                scrollTimer?.invalidate()
                scrollTimer = nil
            }
            resetAll()
            startAfter(timeInterval: true)
        } else if isScrolling {
            resetAll()
        } else {
            // stopped
            resetAll()
            startAfter(timeInterval: true)
        }
    }
    
    public func start() {
        self.isScrollNeedsToStop = false
        if !self.isScrolling && !self.isWaiting {
            startAfter(timeInterval: false)
        }
    }
    
    public func pause() {
        self.isScrollNeedsToStop = true
    }
    
    func resetLeftward() {
        let itemHeight = self.frame.height / CGFloat(max(self.visibleItemCount, 1))
        var lastMaxX: CGFloat = 0.0
        
        for i in 0..<self.items.count {
            let index = (i + self.firstItemIndex) % self.items.count
            var itemWidth = self.frame.width
            if i == 0 {
                items[index].frame = CGRect(x: -itemWidth, y: CGFloat(0.0), width: itemWidth, height: itemHeight)
                lastMaxX = 0.0
                create(itemView: self.items[index])
            } else {
                moveToNextDataIndex()
                let item = self.items[index]
                item.tag = self.dataIndex
                item.width = self.itemWidth(at: item.tag)
                itemWidth = max(item.width + self.itemSpacing, itemWidth)
                item.frame = CGRect(x: lastMaxX, y: CGFloat(0.0), width: itemWidth, height: itemHeight)
                lastMaxX += itemWidth
                update(itemView: item, at: item.tag)
            }
        }
    }
    
    func resetAll() {
        self.dataIndex = -1
        self.firstItemIndex = 0

        if !self.items.isEmpty {
            self.items.forEach { $0.removeFromSuperview() }
            self.items.removeAll()
        } else {
            self.items.removeAll()
        }
        
        switch direction {
        case .leftward:
            self.visibleItemCount = 1
        case .upward:
            if let delegate = delegate, let visibleItemCount = delegate.numberOfVisibleItems?(for: self) {
                self.visibleItemCount = visibleItemCount
                if visibleItemCount <= 0 {
                    return
                }
            } else {
                self.visibleItemCount = DEFAULT_VISIBLE_ITEM_COUNT
            }
        }
        for _ in 0..<self.visibleItemCount+2 {
            let itemView = MarqueeItemView()
            contentView.addSubview(itemView)
            items.append(itemView)
        }
        
        switch direction {
        case .leftward:
            resetLeftward()
        case .upward:
            if self.useDynamicHeight {
                let itemWidth = self.frame.width
                for i in 0..<self.items.count {
                    let index = (i + self.firstItemIndex) % self.items.count
                    if i == self.items.count - 1 {
                        moveToNextDataIndex()
                        let item = self.items[index]
                        item.tag = dataIndex
                        item.height = itemHeight(at: item.tag)
                        item.alpha = 0.0
                        item.frame = CGRect(x: CGFloat(0), y: self.bounds.origin.y+self.bounds.height,
                                                    width: itemWidth,
                                                    height: item.height)
                        update(itemView: item, at: item.tag)
                    } else {
                        let item = self.items[index]
                        item.tag = dataIndex
                        item.alpha = 0.0
                        item.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: itemWidth, height: CGFloat(0))
                    }
                }
            } else {
                var dataCount = 0
                if let delegate = self.delegate {
                    dataCount = delegate.numberOfDataForMarqueeView(marqueeView: self)
                }
                
                let itemWidth = self.frame.width
                let itemHeight = self.frame.height / CGFloat(max(self.visibleItemCount, 1))
                
                for i in 0..<self.items.count {
                    let index = (i + self.firstItemIndex) % items.count
                    if i == 0 {
                        let item = self.items[index]
                        item.tag = dataIndex
                        item.frame = CGRect(x: CGFloat(0), y: -itemHeight, width: itemWidth, height: itemHeight)
                        create(itemView: item)
                    } else {
                        moveToNextDataIndex()
                        let item = self.items[index]
                        item.tag = dataIndex
                        item.frame = CGRect(x: CGFloat(0), y: itemHeight * CGFloat(i - 1), width: itemWidth, height: itemHeight)
                        if stopWhenLessData {
                            if i <= dataCount {
                                update(itemView: item, at: item.tag)
                            } else {
                                create(itemView: item)
                            }
                        } else {
                            update(itemView: item, at: item.tag)
                        }
                    }
                }
            }
        }
        resetTouchReceiver()
    }
    
    func `repeat`() {
        if !isScrollNeedsToStop {
            startAfter(timeInterval: true)
        }
    }
    
    func repeatWithAnimation(finished: Bool) {
        if !isScrollNeedsToStop {
            startAfter(afterTimeInterval: true, animationFinished: finished)
        }
    }
    
    func startAfter(timeInterval: Bool) {
        startAfter(afterTimeInterval: timeInterval, animationFinished: true)
    }
    
    func startAfter(afterTimeInterval: Bool, animationFinished: Bool) {
        if isScrolling || items.count <= 0 {
            return
        }
        self.isWaiting = true
        var timeInterval: TimeInterval = 1.0
        if animationFinished {
            timeInterval = afterTimeInterval ? timeIntervalPerScroll : 0.0
        }
        self.scrollTimer = Timer.scheduledTimer(timeInterval: timeInterval,
                             target: self,
                             selector: #selector(scrollTimerDidFire(timer:)),
                             userInfo: nil,
                             repeats: false)
    }
    
    private func scrollLeftward() {
        
        self.moveToNextDataIndex()
        
        let itemHeight = self.frame.height
        var firstItemWidth = self.frame.width
        var currentItemWidth = self.frame.width
        var lastItemWidth = self.frame.width
        
        for i in 0..<self.items.count {
            let index = (i + self.firstItemIndex) % self.items.count
            let itemWidth = max(self.items[index].width + self.itemSpacing, self.frame.width)
            if i == 0 {
                firstItemWidth = itemWidth
            } else if i == 1 {
                currentItemWidth = itemWidth
            } else {
                lastItemWidth = itemWidth
            }
        }
        
        // move the left item to right without animation
        self.items[self.firstItemIndex].tag = self.dataIndex
        self.items[self.firstItemIndex].width = self.itemWidth(at: self.items[self.firstItemIndex].tag)
        
        let nextItemWidth = max(self.items[self.firstItemIndex].width + self.itemSpacing, self.frame.width)
        self.items[self.firstItemIndex].frame = CGRect(x: lastItemWidth, y: 0, width: nextItemWidth, height: itemHeight)
        if firstItemWidth != nextItemWidth {
            // if the width of next item view changes, then recreate it by delegate
            self.items[self.firstItemIndex].clear()
        }
        self.update(itemView: self.items[self.firstItemIndex], at: self.items[self.firstItemIndex].tag)
        UIView.animate(withDuration: Double(currentItemWidth/CGFloat(self.scrollSpeed)), delay: 0.0, options: .curveLinear) {
            var lastMaxX: CGFloat = 0.0
            for i in 0..<self.items.count {
                let index = (i + self.firstItemIndex) % self.items.count
                let itemWidth = max(self.items[index].width + self.itemSpacing, self.frame.width)
                if i == 0 {
                    continue
                } else if i == 1 {
                    self.items[index].frame = CGRect(x: -itemWidth, y: CGFloat(0), width: itemWidth, height: itemHeight)
                    lastMaxX = 0.0
                } else {
                    self.items[index].frame = CGRect(x: lastMaxX, y: CGFloat(0), width: itemWidth, height: itemHeight)
                    lastMaxX += itemWidth
                }
            }
        } completion: { [weak self] finished in
            guard let self = self else { return }
            self.isScrolling = false
            self.repeatWithAnimation(finished: finished)
        }
        self.moveToNextItemIndex()
    }
    
    func scrollTimerDidFire(timer: Timer) {
        self.isWaiting = false
        if isScrollNeedsToStop {
            return
        }
        self.isScrolling = true
        if stopWhenLessData {
            var dataCount = 0
            if let delegate = self.delegate {
                dataCount = delegate.numberOfDataForMarqueeView(marqueeView: self)
            }
            switch direction {
            case .leftward:
                if dataCount <= 1 {
                    let itemWidth = max(items[1].width + itemSpacing, self.frame.width)
                    if itemWidth <= self.frame.width {
                        DispatchQueue.main.asyncAfter(deadline: .now() + timeDurationPerScroll) { [weak self] in
                            guard let self = self else { return }
                            DispatchQueue.main.async {
                                self.isScrolling = false
                                self.repeat()
                            }
                        }
                        return
                    }
                }
            case .upward:
                if dataCount <= visibleItemCount {
                    DispatchQueue.main.asyncAfter(deadline: .now() + timeDurationPerScroll) { [weak self] in
                        guard let self = self else { return }
                        DispatchQueue.main.async {
                            self.isScrolling = false
                            self.repeat()
                        }
                    }
                    return
                }
            }
        }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch self.direction {
            case .leftward:
                self.scrollLeftward()
            case .upward:
                self.moveToNextDataIndex()
                let itemWidth = self.frame.width
                let itemHeight = self.frame.height / CGFloat(max(self.visibleItemCount, 1))
                // move the top item to bottom without animation
                self.items[self.firstItemIndex].tag = self.dataIndex
                if self.useDynamicHeight {
                    let firstItemWidth = self.items[self.firstItemIndex].height
                    self.items[self.firstItemIndex].height = self.itemHeight(at: self.items[self.firstItemIndex].tag)
                    self.items[self.firstItemIndex].frame = CGRect(x: CGFloat(0), y: self.bounds.origin.y + self.bounds.height, width: itemWidth, height: self.items[self.firstItemIndex].height)
                    if firstItemWidth != self.items[self.firstItemIndex].height {
                        // if the height of next item view changes, then recreate it by delegate
                        self.items[self.firstItemIndex].clear()
                    }
                } else {
                    self.items[self.firstItemIndex].frame = CGRect(x: CGFloat(0), y: self.bounds.origin.y + self.bounds.height, width: itemWidth, height: itemHeight)
                }
                self.update(itemView: self.items[self.firstItemIndex], at: self.items[self.firstItemIndex].tag)
                
                if self.useDynamicHeight {
                    let lastItemIndex = Int(self.items.count - 1 + self.firstItemIndex) % self.items.count
                    let lastItemHeight = self.items[lastItemIndex].height
                    UIView.animate(withDuration: Double(lastItemHeight / CGFloat(max(1, self.scrollSpeed))), delay: 0.0, options: .curveLinear, animations: { [weak self] in
                        guard let self = self else { return }
                        
                        for i in 0..<self.items.count {
                            let index = (i + self.firstItemIndex) % self.items.count
                            if i == 0 {
                                continue
                            } else if i == 1 {
                                let item = self.items[index]
                                item.frame = CGRect(x: item.frame.origin.x,
                                                                 y: item.frame.origin.y - lastItemHeight,
                                                                 width: itemWidth, height: item.height)
                                item.alpha = 0.0
                            } else {
                                let item = self.items[index]
                                item.frame = CGRect(x: item.frame.origin.x,
                                                                 y: item.frame.origin.y - lastItemHeight,
                                                                 width: itemWidth, height: item.height)
                                item.alpha = 1.0
                            }
                        }
                    }, completion: { [weak self] finished in
                        guard let self = self else { return }
                        self.isScrolling = false
                        self.repeatWithAnimation(finished: finished)
                    })
                } else {
                    var animationOptions: UIView.AnimationOptions = .curveEaseInOut
                    if self.timeIntervalPerScroll <= 0.0 {
                        // smooth animation
                        animationOptions = .curveLinear
                    }
                    UIView.animate(withDuration: self.timeDurationPerScroll, delay: 0.0, options: animationOptions) {
                        for i in 0..<self.items.count {
                            let index = (i + self.firstItemIndex) % self.items.count
                            if i == 0 {
                                continue
                            } else if i == 1 {
                                self.items[index].frame = CGRect(x: 0, y: -itemHeight, width: itemWidth, height: itemHeight)
                            } else {
                                self.items[index].frame = CGRect(x: 0, y: itemHeight * CGFloat(i - 2), width: itemWidth, height: itemHeight)
                            }
                        }
                    } completion: { [weak self] finished in
                        guard let self = self else { return }
                        self.isScrolling = false
                        self.repeatWithAnimation(finished: finished)
                    }
                }
                self.moveToNextItemIndex()
            }
        }
    }
    
    func moveToNextItemIndex() {
        if self.firstItemIndex >= self.items.count - 1 {
            self.firstItemIndex = 0
        } else {
            self.firstItemIndex+=1
        }
    }
    
    func itemWidth(at index: Int) -> CGFloat {
        var itemWidth: CGFloat = 0.0
        if index >= 0 {
            itemWidth = delegate?.itemViewWidth?(atIndex: index, for: self) ?? CGFloat(0)
        }
        return itemWidth
    }
    
    func itemHeight(at index: Int) -> CGFloat {
        var itemHeight: CGFloat = 0.0
        if index >= 0 {
            itemHeight = delegate?.itemViewHeight?(atIndex: index, for: self) ?? CGFloat(0)
        }
        return itemHeight
    }
    
    func update(itemView: MarqueeItemView, at index: Int) {
        if index < 0 {
            itemView.clear()
        }
        if !itemView.didFinishCreate {
            if let delegate = delegate {
                delegate.createItemView(itemView: itemView, for: self)
                itemView.didFinishCreate = true
            }
        }
        
        if index >= 0 {
            if let delegate = delegate {
                delegate.updateItemView(itemView: itemView, atIndex: index, for: self)
            }
        }
    }
    
    func create(itemView: MarqueeItemView) {
        if !itemView.didFinishCreate {
            if let delegate = delegate {
                delegate.createItemView(itemView: itemView, for: self)
                itemView.didFinishCreate = true
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contentView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleResignActiveNotification(_:)), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleBecomeActiveNotification(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    deinit {
        if self.scrollTimer != nil {
            self.scrollTimer?.invalidate()
            self.scrollTimer = nil
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleResignActiveNotification(_ notification: Notification) {
        isPausingBeforeResignActive = isScrollNeedsToStop
        pause()
    }
    
    func handleBecomeActiveNotification(_ notification: Notification) {
        if !isPausingBeforeResignActive {
            start()
        }
    }
}

extension MarqueeView: MarqueeViewTouchResponder {
    
    func moveToNextDataIndex() {
        var dataCount = 0
        if let delegate = self.delegate {
            dataCount = delegate.numberOfDataForMarqueeView(marqueeView: self)
        }
        if dataCount <= 0 {
            self.dataIndex = -1
        } else {
            self.dataIndex = dataIndex + 1
            if dataIndex < 0 || dataIndex > dataCount - 1 {
                self.dataIndex = 0
            }
        }
    }
    
    func resetTouchReceiver() {
        if touchEnabled {
            if touchReceiver == nil {
                let touchReceiver = MarqueeViewTouchReceiver()
                touchReceiver.touchDelegate = self
                addSubview(touchReceiver)
                touchReceiver.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    touchReceiver.rightAnchor.constraint(equalTo: self.rightAnchor),
                    touchReceiver.topAnchor.constraint(equalTo: self.topAnchor),
                    touchReceiver.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                    touchReceiver.leftAnchor.constraint(equalTo: self.leftAnchor)
                ])
            } else {
                bringSubviewToFront(self.touchReceiver!)
            }
        } else {
            if touchReceiver != nil {
                touchReceiver?.removeFromSuperview()
                touchReceiver = nil
            }
        }
    }
    
    func touchesBegan() {
        isPausingBeforeTouchesBegan = isScrollNeedsToStop
        pause()
    }
    
    func touchesEnded(at point: CGPoint) {
        for itemView in items where (itemView.layer.presentation()?.hitTest(point)) != nil {
            var dataCount = 0
            if let delegate = self.delegate {
                dataCount = delegate.numberOfDataForMarqueeView(marqueeView: self)
            }
            if dataCount > 0 && itemView.tag >= 0 && itemView.tag < dataCount {
                if let delegate = self.delegate {
                    delegate.didTouchItemView?(atIndex: itemView.tag, for: self)
                }
            }
            break
        }
        if !isPausingBeforeTouchesBegan {
           start()
        }
    }
    
    func touchesCancelled() {
        if !isPausingBeforeTouchesBegan {
            start()
        }
    }
}

@objc protocol MarqueeViewTouchResponder: NSObjectProtocol {
    
    func touchesBegan()
    func touchesEnded(at point: CGPoint)
    func touchesCancelled()
}

class MarqueeViewTouchReceiver: UIView {
    
    weak var touchDelegate: MarqueeViewTouchResponder?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchDelegate?.touchesBegan()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchDelegate = touchDelegate, let touch = touches.first {
            touchDelegate.touchesEnded(at: touch.location(in: self))
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchDelegate?.touchesCancelled()
    }
}

class MarqueeItemView: UIView {
    
    var didFinishCreate = false
    var width: CGFloat = 0
    var height: CGFloat = 0
    
    func clear() {
        self.subviews.forEach { $0.removeFromSuperview() }
        didFinishCreate = false
    }
}

extension MarqueeView {
    
   func repositionItemViews() {
       switch direction {
       case .leftward:
           let itemHeight: CGFloat = self.frame.height / CGFloat(max(self.visibleItemCount, 1))
           var lastMaxX: CGFloat = 0.0
           for i in 0..<items.count {
               let index = (i + firstItemIndex) % items.count
               let itemWidth = max(items[index].width + itemSpacing, self.frame.width)
               if i == 0 {
                   items[index].frame = CGRect(x: -itemWidth, y: CGFloat(0.0), width: itemWidth, height: itemHeight)
                   lastMaxX = 0.0
               } else {
                   items[index].frame = CGRect(x: lastMaxX, y: CGFloat(0.0), width: itemWidth, height: itemHeight)
                   lastMaxX += itemWidth
               }
           }
       case .upward:
           if useDynamicHeight {
               let itemWidth = self.frame.width
               var lastMaxY: CGFloat = 0.0
               for i in 0..<items.count {
                   let index = (i + firstItemIndex) % items.count
                   if i == 0 {
                       items[index].frame = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: itemWidth, height: CGFloat(0.0))
                       lastMaxY = 0.0
                   } else if i == items.count - 1 {
                       items[index].frame = CGRect(x: CGFloat(0.0), y: self.bounds.origin.y + self.bounds.height, width: itemWidth, height: items[index].height)
                   } else {
                       items[index].frame = CGRect(x: CGFloat(0.0), y: lastMaxY, width: itemWidth, height: items[index].height)
                       lastMaxY += items[index].height
                   }
               }
               let offsetY = self.frame.height - lastMaxY
               for i in 0..<items.count {
                   let index = (i + firstItemIndex) % items.count
                   if i > 0 && i < items.count - 1 {
                       items[index].frame = CGRect(x: items[index].frame.origin.x,
                                                   y: items[index].frame.origin.y+offsetY,
                                                   width: itemWidth,
                                                   height: items[index].height)
                   }
               }
           } else {
               let itemWidth = self.frame.width
               let itemHeight = self.frame.height / CGFloat(max(self.visibleItemCount, 1))
               for i in 0..<items.count {
                   let index = (i + firstItemIndex) % items.count
                   if i == 0 {
                       items[index].frame = CGRect(x: CGFloat(0),
                                                   y: -itemHeight,
                                                   width: itemWidth,
                                                   height: itemHeight)
                   } else {
                       items[index].frame = CGRect(x: CGFloat(0),
                                                   y: itemHeight * CGFloat(i - 1),
                                                   width: itemWidth,
                                                   height: itemHeight)
                   }
               }
           }
       }
   }
}
