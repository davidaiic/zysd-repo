//
//  PopManager.swift
//
//  Created by wangteng on 2023/2/12.
//

import Foundation

@objc public enum BasicPopDirection: Int {
   case left, top, right, bottom, center
}

public class BasicPopManager: NSObject {
    
    @objc public override init() { super.init() }
    
    public typealias ImageHandler = (BasicPopImageItem) -> Void
    public typealias TextHandler = (BasicPopTextItem) -> Void
    public typealias ActionHandler = (BasicPopActionItem) -> Void
    public typealias PopViewHandler = (BasicPopContentView) -> Void
    public typealias DismissHandler = () -> Void
    public typealias AttributedText = NSMutableAttributedString
    
    @objc public let config = BasicPopConfiguration()
    
    public enum Bind {
        
        /// 添加图片 `BasicPopImageItem`
        /// size: 图片显示的尺寸，默认为0， 为0获取image的尺寸
        /// handler: 回掉`BasicPopImageItem`
        case image(UIImage?, size: CGSize = .zero, handler: ImageHandler? = nil)
        
        /// 默认字体 `UIFont.systemFont(ofSize: 16, weight: .medium)` 默认颜色 `黑色`
        case title(String, TextHandler? = nil)
        
        /// 默认字体 `UIFont.systemFont(ofSize: 14, weight: .regular)` 默认颜色: `0x333333`
        case message(String, TextHandler? = nil)
        
        /// 自定义view
        case wrapper(UIView)
        
        /// 分隔高度
        case divide(CGFloat, UIColor = .white)
        
        /// 属性标题 默认字体剧中显示
        case attributedTitle(AttributedText, TextHandler? = nil)
        case attributedMessage(AttributedText, TextHandler? = nil)
        
        /// 按钮配置
        case action(titles: [String],
                    handler: ActionHandler? = nil)
        
        /// 关闭按钮 默认不显示
        /// 参数一: 按钮的位置
        /// 参数二：按钮的图片, 为nil 时候使用默认图片
        case close(BasicPopConfiguration.ClosePosition, UIImage? = nil)
        
        /// item 之间的高度尺寸默认 20
        case spacing(CGFloat)
        
        /// 点击背景是否消失
        case maskClose(Bool)
        
        /// 内容的内间距
        case padding(UIEdgeInsets)
        
        /// 视图的最大宽度
        case contentMaxWidth(CGFloat)
        
        /// BasicPopContentView
        case popViewHandler(PopViewHandler)
        
        case dismissHandler(DismissHandler)
    }
    
    /// BasicPopContentView
    public var popViewHandler: PopViewHandler?
    public var dismissHandler: DismissHandler?
 
    @discardableResult
    public func bind(_ bind: Bind) -> BasicPopManager {
        switch bind {
        case let .image(image, size, handler):
            let imageItem = BasicPopImageItem()
            imageItem.image = image
            imageItem.size = size
            handler?(imageItem)
            config.popItems.append(imageItem)
        case let .title(title, handler):
            let titleAttributed = AttributedText(string: title)
                .bind.foregroundColor(UIColor(0x000000))
                .font(UIFont.systemFont(ofSize: 16, weight: .medium))
            self.bind(.attributedTitle(titleAttributed.base, handler))
        case let .message(message, handler):
            let messageAttributed = AttributedText(string: message)
                .bind.foregroundColor(UIColor(0x333333))
                .font(UIFont.systemFont(ofSize: 14, weight: .regular))
            self.bind(.attributedMessage(messageAttributed.base, handler))
        case .wrapper(let view):
            let item = BasicPopWrapperItem()
            item.wrapper = view
            config.popItems.append(item)
            
        case let .divide(height, color):
            let divideView = UIView(frame: .init(x: 0, y: 0, width: 0, height: height))
            divideView.backgroundColor = color
            self.bind(.wrapper(divideView))
        case let .attributedTitle(title, handler):
            let textItem = BasicPopTextItem()
            textItem.textAlignment = .center
            textItem.attributedText = title
            handler?(textItem)
            config.popItems.append(textItem)
            
        case let .attributedMessage(message, handler):
            let textItem = BasicPopTextItem()
            textItem.textAlignment = .center
            textItem.attributedText = message
            handler?(textItem)
            config.popItems.append(textItem)
            
        case let .action(actionTitles, handler):
            let actionItem = BasicPopActionItem()
            actionItem.titles = actionTitles
            handler?(actionItem)
            config.popItems.append(actionItem)
            
        case let .close(closePosition, image):
            config.closePosition = closePosition
            if let image = image {
                config.closeImage = image
            }
        case .spacing(let spacing):
            config.spacing = spacing
        case .maskClose(let close):
            config.didMaskClose = close
        case .padding(let insets):
            config.padding = insets
        case .contentMaxWidth(let maxWidth):
            config.contentMaxWidth = maxWidth
        case .popViewHandler(let handler):
            self.popViewHandler = handler
        case .dismissHandler(let handler):
            self.dismissHandler = handler
        }
        return self
    }
    
    @objc public func pop(_ direction: BasicPopDirection = .center) {
        let contentView = BasicPopContentView(configuration: config)
        popViewHandler?(contentView)
        let popup = Popup(contentView: contentView)
        config.closeHandler = {
            popup.dismiss()
            self.dismissHandler?()
        }
        popup.show(.init(rawValue: direction.rawValue) ?? .center)
    }
}

public extension BasicPopManager {
    
    @objc func pop() {
        self.pop(.center)
    }
    
    @discardableResult
    @objc func image(_ image: UIImage, size: CGSize, imageHandler: @escaping ImageHandler) -> BasicPopManager {
        self.bind(.image(image, size: size, handler: imageHandler))
    }
    
    /// 默认字体 `UIFont.systemFont(ofSize: 16, weight: .medium)` 默认颜色 `黑色`
    @discardableResult
    @objc func title(_ title: String) -> BasicPopManager {
        self.bind(.title(title))
    }
    
    /// 默认字体 `UIFont.systemFont(ofSize: 16, weight: .medium)` 默认颜色 `黑色`
    @discardableResult
    @objc func title(_ title: String, handler: @escaping TextHandler) -> BasicPopManager {
        self.bind(.title(title, handler))
    }
    
    /// 默认字体 `UIFont.systemFont(ofSize: 14, weight: .regular)` 默认颜色: `0x333333`
    @discardableResult
    @objc
    func message(_ message: String) -> BasicPopManager {
        self.bind(.message(message))
    }
    
    /// 默认字体 `UIFont.systemFont(ofSize: 14, weight: .regular)` 默认颜色: `0x333333`
    @discardableResult
    @objc func message(_ message: String, handler: @escaping TextHandler) -> BasicPopManager {
        self.bind(.message(message, handler))
    }
    
    @discardableResult
    @objc func wrapper(_ view: UIView) -> BasicPopManager {
        self.bind(.wrapper(view))
    }
    
    @discardableResult
    @objc func attributedTitle(_ attributedText: AttributedText, handler: @escaping TextHandler) -> BasicPopManager {
        self.bind(.attributedTitle(attributedText, handler))
    }
    
    @discardableResult
    @objc func attributedMessage(_ attributedMessage: AttributedText, handler: @escaping TextHandler) -> BasicPopManager {
        self.bind(.attributedMessage(attributedMessage, handler))
    }
    
    @discardableResult
    @objc func action(titles: [String]) -> BasicPopManager {
        self.bind(.action(titles: titles))
    }
    
    @discardableResult
    @objc func action(titles: [String],
                      handler: @escaping ActionHandler) -> BasicPopManager {
        self.bind(.action(titles: titles, handler: handler))
    }
    
    @discardableResult
    @objc func close(_ position: BasicPopConfiguration.ClosePosition, image: UIImage? = nil) -> BasicPopManager {
        self.bind(.close(position, image))
    }
    
    @discardableResult
    @objc func spacing(_ spacing: CGFloat) -> BasicPopManager {
        self.bind(.spacing(spacing))
    }
    
    @discardableResult
    @objc func padding(_ padding: UIEdgeInsets) -> BasicPopManager {
        self.bind(.padding(padding))
    }
    
    @discardableResult
    @objc func maskClose(_ maskClose: Bool) -> BasicPopManager {
        self.bind(.maskClose(maskClose))
    }
    
    @discardableResult
    @objc func contentMaxWidth(_ width: CGFloat) -> BasicPopManager {
        self.bind(.contentMaxWidth(width))
    }

    @discardableResult
    @objc func popViewHandler(_ handler: @escaping PopViewHandler) -> BasicPopManager {
        self.bind(.popViewHandler(handler))
    }
    
}
