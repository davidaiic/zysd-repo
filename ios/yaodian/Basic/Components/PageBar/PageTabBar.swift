
import UIKit

public protocol PageTabBarDelegate: AnyObject {
    
    func numberOfItem(in tabBar: PageTabBar) -> Int
    
    func pageTabBar(_ tabBar: PageTabBar, itemInfoAt index: Int) -> PageTabBarItem.Info
    
    func pageTabBar(_ tabBar: PageTabBar, shouleSelectedIndex index: Int) -> Bool
    
    func pageTabBar(_ tabBar: PageTabBar, didSelectIndexAt index: Int)
    
}

public class PageTabBar: UIView {
    
    weak var delegate: PageTabBarDelegate?
    
    private(set) var currentSelectIndex: Int = 0
    
    let contentScrollView: UIScrollView = {
        let v = UIScrollView()
        v.scrollsToTop = false
        v.backgroundColor = .clear
        v.showsVerticalScrollIndicator = false
        v.showsHorizontalScrollIndicator = false
        return v
    }()
    
    private let indicatorView: UIImageView = {
        let v = UIImageView()
        return v
    }()
    
    var buttons: [PageTabBarItem] = []
    
    private let config: Config
    
    var intrinsicContentHeight: CGFloat {
        return config.height
    }
    
    init(config: Config) {
        self.config = config
        super.init(frame: .zero)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        self.config = .common
        super.init(coder: coder)
        self.initUI()
    }
    
    private func initUI() {
        self.addSubview(contentScrollView)
        
        indicatorView.layer.cornerRadius = config.indicatorCornerRadius
        if let image = config.indicatorImage {
            indicatorView.image = image
        } else {
            indicatorView.backgroundColor = config.indicatorColor
        }
        self.contentScrollView.addSubview(indicatorView)
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.reloadData(false, newSelectIndex: self.currentSelectIndex)
    }
    
    func reloadData() {
        self.reloadData(false, newSelectIndex: self.currentSelectIndex)
    }
    
    /// reload
    /// - Parameter animated: is animated
    /// - Parameter newSelectIndex: newSelectIndex
    func reloadData(_ animated: Bool, newSelectIndex: Int) {
        guard let delegate = self.delegate else {
            return
        }
        
        let count = delegate.numberOfItem(in: self)
        var _buttons: [PageTabBarItem] = []
        for index in 0..<count {
            let button: PageTabBarItem
            if index < self.buttons.count {
                button = self.buttons[index]
            } else {
                button = PageTabBarItem(frame: .init(x: self.bounds.width, y: self.bounds.height * 0.5, width: 0, height: 0))
                button.adjustsImageWhenHighlighted = false
                button.setTitleColor(config.normalColor, for: .normal)
                button.setTitleColor(config.selectedColor, for: .selected)
                button.titleLabel?.font = config.normalFont
                button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
                button.titleLabel?.lineBreakMode = .byTruncatingTail
                button.imageView?.contentMode = .scaleAspectFit
                self.contentScrollView.addSubview(button)
            }
            
            let info = delegate.pageTabBar(self, itemInfoAt: index)
            button.setImage(with: info) { [weak self] in
                guard let `self` = self else { return }
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
            self.update(button: button, isSelected: newSelectIndex == index)
            
            _buttons.append(button)
        }
        
        for index in stride(from: count, to: self.buttons.count, by: 1) {
            self.buttons[index].removeFromSuperview()
        }
        
        self.currentSelectIndex = newSelectIndex
        self.buttons = _buttons
        self.contentScrollView.bringSubviewToFront(self.indicatorView)
        
        self.animationUpdate(animated) {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    @objc private func buttonClicked(_ sender: PageTabBarItem) {
        guard let index = self.buttons.firstIndex(of: sender),
            let delegate = self.delegate else {
                return
        }
        if delegate.pageTabBar(self, shouleSelectedIndex: index) {
            self.select(index: index, animated: true)
            delegate.pageTabBar(self, didSelectIndexAt: index)
        }
    }
    
    private func animationUpdate(_ animated: Bool, closure: @escaping ()->Void) {
        if animated {
            UIView.animate(withDuration: 0.25) {
                closure()
            }
        } else {
            closure()
        }
    }
    
    func select(index: Int, animated: Bool) {
        guard index != self.currentSelectIndex else {
            return
        }
        self.update(button: self.buttons[self.currentSelectIndex], isSelected: false)
        self.update(button: self.buttons[index], isSelected: true)
        self.currentSelectIndex = index
        self.animationUpdate(animated) {
            self.updateIndicatorViewFrame()
            self.updateContentScrollViewOffset()
        }
    }
    
    private func update(button: UIButton, isSelected: Bool) {
        guard button.isSelected != isSelected else { return }
        button.isSelected = isSelected
        button.titleLabel?.font = isSelected ? config.selectedFont : config.normalFont
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        defer {
            self.updateIndicatorViewFrame()
            self.updateContentScrollViewOffset()
        }
        
        guard !buttons.isEmpty else {
            return
        }
        
        switch self.config.alignment {
        case .left:
            self.leftAlignmentLayoutSubviews()
        case .center:
            self.centerAlignmentLayoutSubviews()
        }
        
    }
    
    private func centerAlignmentLayoutSubviews() {
        self.contentScrollView.frame = self.bounds
        
        let minMargin: CGFloat = config.minimumInteritemSpacing
        let leftMargin: CGFloat = config.leftMargin
        let rightMargin: CGFloat = config.rightMargin
        let contentHeight = self.bounds.height
        
        var buttonSizes: [CGSize] = []
        for index in 0..<self.buttons.count {
            let button = self.buttons[index]
            buttonSizes.append(self.buttonSize(button: button))
        }
        
        guard self.buttons.count != 1 else {
            let button = self.buttons[0]
            button.frame.size = buttonSizes[0]
            button.center = self.contentScrollView.center
            return
        }
        
        let marginCount = self.buttons.count - 1
        
        let contentWidth = contentScrollView.bounds.width - leftMargin - rightMargin
        let buttonsWidth = buttonSizes.reduce(into: CGFloat(0)) { $0 += $1.width }
        let _margin = ((contentWidth - buttonsWidth)/CGFloat(marginCount))
        let margin = max(minMargin, _margin)
        
        let contentSizeHeight = contentScrollView.bounds.height
        let contentSizeWidth = buttonsWidth + CGFloat(marginCount) * margin + leftMargin + rightMargin
        self.contentScrollView.contentSize = .init(width: contentSizeWidth, height: contentSizeHeight)
        
        var nextButtonX: CGFloat = leftMargin
        for index in 0..<self.buttons.count {
            let button = self.buttons[index]
            let size = buttonSizes[index]
            let frame = CGRect.init(x: nextButtonX, y: (contentHeight - size.height) * 0.5, width: size.width, height: size.height)
            button.frame = frame
            nextButtonX = button.frame.maxX + margin
        }
    }
    
    private func updateIndicatorViewFrame() {
        guard !buttons.isEmpty else {
            self.indicatorView.frame = .zero
            return
        }
        if self.buttons.count <= self.currentSelectIndex {
            return
        }
        let button = self.buttons[self.currentSelectIndex]
        let realButtonWidth = button.bounds.width - config.expandButtonWidth
        let indicatorViewHeight = config.indicatorHeight
        let indicatorViewWidth = realButtonWidth
        let indicatorViewX = button.frame.origin.x + config.expandButtonWidth * 0.5
        let indicatorViewY = self.bounds.height - indicatorViewHeight - config.indicatorBottomGap
        self.indicatorView.frame = .init(x: indicatorViewX, y: indicatorViewY, width: indicatorViewWidth, height: indicatorViewHeight)
    }
    
    private func updateContentScrollViewOffset() {
        guard !buttons.isEmpty,
            self.contentScrollView.contentSize.width > self.contentScrollView.bounds.width else {
                return
        }
        let button = self.buttons[self.currentSelectIndex]
        let leftX = button.center.x - self.contentScrollView.bounds.width * 0.5
        let rightX = button.center.x + self.contentScrollView.bounds.width * 0.5
        let offset: CGPoint
        if leftX <= 0 {
            offset = .zero
        } else if rightX >= self.contentScrollView.contentSize.width {
            offset = .init(x: self.contentScrollView.contentSize.width - self.contentScrollView.bounds.width, y: 0)
        } else {
            offset = .init(x: leftX, y: 0)
        }
        self.contentScrollView.contentOffset = offset
    }
    
}

// Alignment left
extension PageTabBar {
    
    private func leftAlignmentLayoutSubviews() {
        self.contentScrollView.frame = self.bounds
        
        var x: CGFloat = self.config.leftMargin
        let contentHeight = self.bounds.height
        
        for pair in self.buttons.enumerated() {
            let buttonSize = self.buttonSize(button: pair.element)
            pair.element.frame = CGRect(x: x, y: (contentHeight - buttonSize.height) * 0.5, width: buttonSize.width, height: buttonSize.height)
            x += buttonSize.width
            x += self.config.minimumInteritemSpacing
        }
        x -= self.config.minimumInteritemSpacing
        x += self.config.rightMargin
        self.contentScrollView.contentSize = CGSize(width: x, height: self.bounds.height)
    }
    
    private func buttonSize(button: PageTabBarItem) -> CGSize {
        let contentHeight = self.bounds.height
        let expandButtonWidth: CGFloat = config.expandButtonWidth
        var size = button.systemLayoutSizeFitting(.init(width: contentHeight, height: contentHeight))
        
        if button.title(for: .normal) == nil, let s = button.info?.urlImage?.targetSize {
            size = s
        }
        let buttonWidth: CGFloat
        let buttonHeight: CGFloat
        if size.height <= 0 {
            buttonWidth = contentHeight + expandButtonWidth
            buttonHeight = contentHeight
        } else if size.height <= contentHeight {
            buttonWidth = {
                let limit: CGFloat = self.config.alignment == .left ? .infinity : 150.0
                return Swift.min(size.width + expandButtonWidth, limit)
            }()
            buttonHeight = size.height
        } else {
            let tempWidth = size.width/size.height * contentHeight + expandButtonWidth
            buttonWidth = min(tempWidth, 150.0)
            buttonHeight = contentHeight
        }
        return CGSize(width: buttonWidth, height: buttonHeight)
    }
}
