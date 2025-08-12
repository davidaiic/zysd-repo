//
//  BasicAlertContentView.swift
//  MotorFans
//
//  Created by wangteng on 2023/1/4.
//  Copyright © 2023 MotorFans, JDD. All rights reserved.
//

import UIKit
import SnapKit

@objcMembers
public class BasicPopContentView: UIView {

    public var configuration = BasicPopConfiguration()
    
    public lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 20
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    public lazy var closeButton: UIButton = {
        let closeButton = UIButton(type: .custom)
        closeButton.addTarget(self, action: #selector(triggerClose), for: .touchUpInside)
        return closeButton
    }()
    
    func triggerClose() {
        configuration.closeHandler?()
    }
    
    public lazy var bottomButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 20
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private func addHierarchy() {
        
        backgroundColor = .white
        layer.cornerRadius = 10
        
        addSubview(contentStackView)
        addSubview(closeButton)
    }
    
    public init(configuration: BasicPopConfiguration) {
        let left = (UIScreen.main.bounds.width-configuration.contentMaxWidth)*0.5
        let height = configuration.height
        let top = (UIScreen.main.bounds.height-height)*0.5
        super.init(frame: .init(origin: .init(x: left, y: top),
                                size: .init(width: configuration.contentMaxWidth,
                                            height: height)))
        addHierarchy()
        self.configuration = configuration
        updateConfiguration()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // 处理关闭按钮在底部时可以响应事件
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let supView = super.hitTest(point, with: event)
        if configuration.closePosition == .bottomCenter {
            for subView in self.subviews {
                let convertedPoint = subView.convert(point, from: self)
                let targetView = subView.hitTest(convertedPoint, with: event)
                if targetView != nil {
                    return targetView
                }
            }
        }
        return supView
    }
}

// MARK: - Arranged
extension BasicPopContentView {
    
    private func makeArrangedButton(title: String, tag: Int) -> UIButton {
        let bottomButton = UIButton(type: UIButton.ButtonType.custom)
        bottomButton.layer.cornerRadius = 20.0
        bottomButton.tag = tag
        bottomButton.setTitle(title, for: .normal)
        bottomButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return bottomButton
    }
    
    private func makeArrangedTextView() -> UITextView {
        let messageTextView = UITextView()
        messageTextView.isEditable = false
        messageTextView.isScrollEnabled = false
        messageTextView.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        messageTextView.delegate = self
        messageTextView.linkTextAttributes = [:]
        messageTextView.textContainerInset = .zero
        messageTextView.backgroundColor = .clear
        messageTextView.showsVerticalScrollIndicator = false
        messageTextView.showsHorizontalScrollIndicator = false
        messageTextView.textContainer.lineFragmentPadding = 0
        messageTextView.textContainerInset = .zero
        return messageTextView
    }
    
    private func makeArrangedImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        return imageView
    }
}

// MARK: - Configuration
extension BasicPopContentView {
    
    private func updateConfiguration() {
        layoutContentStackView()
        layoutCloseButton()
        layoutItems()
    }
    
    private func layoutContentStackView() {
        contentStackView.spacing = configuration.spacing
        contentStackView.snp.remakeConstraints { make in
            make.top.equalTo(configuration.padding.top)
            make.left.equalTo(configuration.padding.left)
            make.right.equalTo(-configuration.padding.right)
            make.bottom.equalTo(-configuration.padding.bottom)
        }
    }
    
    private func layoutCloseButton() {
        closeButton.isHidden = configuration.closePosition == .unspecified
        closeButton.setImage(configuration.closeImage, for: .normal)
        switch configuration.closePosition {
        case .unspecified:
            break
        case .topRight:
            self.closeButton.snp.remakeConstraints { make in
                make.top.right.equalTo(0.0)
                make.size.equalTo(CGSize.init(width: 41.0, height: 41.0))
            }
        case .bottomCenter:
            self.closeButton.snp.remakeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(self.snp.bottom).offset(20)
                make.size.equalTo(CGSize.init(width: 41.0, height: 41.0))
            }
        }
    }
    
    private func layoutItems() {
        for (idx, item) in configuration.popItems.enumerated() {
            switch item {
            case let imageItem as BasicPopImageItem:
                let arrangedImageWrapper = UIView()
                arrangedImageWrapper.tag = idx
                let arrangedImageView = makeArrangedImageView()
                arrangedImageView.image = imageItem.image
                arrangedImageWrapper.addSubview(arrangedImageView)
                arrangedImageView.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.size.equalTo(imageItem.size)
                }
                imageItem.configureHandler?(arrangedImageView)
                contentStackView.addArrangedSubview(arrangedImageWrapper)
                arrangedImageWrapper.snp.makeConstraints { make in
                    make.height.equalTo(imageItem.height)
                }
            case let textItem as BasicPopTextItem:
                let makeTextView = makeArrangedTextView()
                makeTextView.tag = idx
                makeTextView.attributedText = textItem.attributedText
                makeTextView.textAlignment = textItem.textAlignment
                makeTextView.isScrollEnabled = textItem.scrollEnabled
                contentStackView.addArrangedSubview(makeTextView)
                makeTextView.snp.makeConstraints { make in
                    make.height.equalTo(textItem.height)
                }
            case let wrapperItem as BasicPopWrapperItem:
                if let wrapperView = wrapperItem.wrapper {
                    contentStackView.addArrangedSubview(wrapperView)
                    wrapperView.snp.makeConstraints { make in
                        make.height.equalTo(wrapperItem.height)
                    }
                }
            case let actionItem as BasicPopActionItem:
                switch actionItem.direction {
                case .horizontal:
                    horizontalAction(actionItem: actionItem)
                case .vertical:
                    verticalAction(actionItem: actionItem)
                }
            default:
                break
            }
        }
    }
    
    func actionHandler(_ button: UIButton, item: BasicPopActionItem) {
        if let handler = item.handler {
            if handler(button.tag) {
                triggerClose()
            }
        } else {
            triggerClose()
        }
    }
    
    private func horizontalAction(actionItem: BasicPopActionItem) {
        contentStackView.addArrangedSubview(bottomButtonStackView)
        bottomButtonStackView.snp.makeConstraints { make in
            make.height.equalTo(actionItem.actionHeight)
        }
        bottomButtonStackView.isHidden = actionItem.titles.isEmpty
        if actionItem.titles.count == 1, let title = actionItem.titles.first {
            let buttonWrapper = UIView()
            let button = makeArrangedButton(title: title, tag: 0)
            buttonWrapper.addSubview(button)
            button.snp.makeConstraints { make in
                make.top.bottom.equalTo(0)
                make.left.equalTo(actionItem.spacingLeftRight)
                make.right.equalTo(-actionItem.spacingLeftRight)
            }
            button.red()
            button.bind.onTap { [weak self] _ in
                guard let self = self else { return }
                self.actionHandler(button, item: actionItem)
            }
            actionItem.configureHandler?(button)
            bottomButtonStackView.addArrangedSubview(buttonWrapper)
        } else {
            for (idx, title) in actionItem.titles.enumerated() {
                let button = makeArrangedButton(title: title, tag: idx)
                if actionItem.titles.count == 1 {
                    button.red()
                } else {
                    if idx == 0 {
                        button.gray()
                    } else {
                        button.red()
                    }
                }
                button.bind.onTap { [weak self] _ in
                    guard let self = self else { return }
                    self.actionHandler(button, item: actionItem)
                }
                actionItem.configureHandler?(button)
                bottomButtonStackView.addArrangedSubview(button)
            }
        }
    }
    
    private func verticalAction(actionItem: BasicPopActionItem) {
        for (idx, title) in actionItem.titles.enumerated() {
            let button = makeArrangedButton(title: title, tag: idx)
            contentStackView.addArrangedSubview(button)
            button.snp.makeConstraints { make in
                make.height.equalTo(actionItem.actionHeight)
            }
            button.red()
            actionItem.configureHandler?(button)
            button.bind.onTap { [weak self]  _ in
                guard let self = self else { return }
                self.actionHandler(button, item: actionItem)
            }
        }
    }
}

extension BasicPopContentView: UITextViewDelegate {
    
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        return linkHandler(textView, shouldInteractWith: URL, in: characterRange)
    }
    
    @available(iOS 10.0, *)
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return linkHandler(textView, shouldInteractWith: URL, in: characterRange)
    }
    
    private func linkHandler(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange) -> Bool {
        if configuration.popItems.indices ~= textView.tag,
           let linkHandler = configuration.item(atIndex: textView.tag, type: BasicPopTextItem.self).linkHandler {
            let linkString = (textView.attributedText.string as NSString).substring(with: characterRange)
            if linkHandler(url.absoluteString, linkString) {
                triggerClose()
            }
        }
        return false
    }
}

extension BasicPopContentView: Popupable {
    
    public var maskViewUserInteractionEnabled: Bool {
        configuration.didMaskClose
    }
}

extension UIButton {
    
    func gray() {
        backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.9294117647, blue: 0.9294117647, alpha: 1)
        setTitleColor(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
                      , for: .normal)
    }
    
    func red() {
        backgroundColor = #colorLiteral(red: 0.368627451, green: 0.8, blue: 0.6980392157, alpha: 1)
        setTitleColor(.white, for: .normal)
    }
}
