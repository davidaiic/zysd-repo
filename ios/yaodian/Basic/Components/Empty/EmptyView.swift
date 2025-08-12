//
//  EmptyView.swift
//  Drug
//
//  Created by wangteng on 2023/2/28.
//

import UIKit
import Bind
import SnapKit

public class EmptyView: UIView {
    
    var contentView: BasicPopContentView?
    
    lazy var wrapperView: UIView = {
        var wrapperView = UIView()
        wrapperView.backgroundColor = UIColor(0xF9F9F9)
        return wrapperView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(wrapperView)
        wrapperView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show(failure: NSError, handler: (() -> Void)? = nil) {
        if BasicResponse.BasicErrorCode
            .allCases
            .map({ $0.rawValue })
            .contains(failure.code) {
            if failure.needLogin {
                show(style: .init(image: "load_failed".bind.image,
                                  title: "抱歉，需要登陆～"+"(\(failure.code))",
                                  buttonTitle: "重新登陆"),
                          handler: {
                    LoginManager.shared.showLogin()
                })
            } else {
                show(style: .init(image: "load_failed".bind.image,
                                  title: "抱歉，加载失败哦～"+"(\(failure.code))",
                                  buttonTitle: "重新加载"),
                          handler: handler)
            }
            
        } else {
            show(style: .netError(), handler: handler)
        }
    }
    
    public func show(style: EmptyViewStyle, handler: (() -> Void)? = nil) {
        
        alpha = 1
      
        let configuration = style
        
        let popManager = BasicPopManager()
        
        if let image = configuration.image {
            popManager.bind(.image(image))
        }
        
        if !configuration.title.isEmpty {
            popManager.bind(.title(configuration.title, {
                $0.attributedText.bind.foregroundColor(UIColor(0x999999))
                    .font(UIFont.systemFont(ofSize: 14))
            }))
        }
        
        if !configuration.detail.isEmpty {
            popManager.bind(.message(configuration.detail, {
                $0.attributedText.bind.foregroundColor(UIColor.lightGray)
            }))
        }
        
        if !configuration.buttonTitle.isEmpty {
            popManager.bind(.action(titles: [configuration.buttonTitle], handler: {
                $0.handler = {  _ -> Bool in
                    handler?()
                    return true
                }
                $0.spacingLeftRight = 0
                $0.configureHandler = { btn in
                    btn.bind
                        .font(UIFont.systemFont(ofSize: 15))
                        .backgroundColor(.clear)
                        .foregroundColor(UIColor(0x0FC8AC))
                }
            }))
        }
        
        if let superview = superview {
            popManager.bind(.contentMaxWidth(superview.bounds.width))
        }
        
        let contentView = BasicPopContentView(configuration: popManager.config)
        contentView.backgroundColor = .clear
        wrapperView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(style.centerYoffset)
        }
        self.contentView = contentView
    }
    
    func hide() {
        if alpha != 0 {
            alpha = 0
        }
    }
}

public extension UIView {
    
    private struct EmptyViewKeys {
        static var empty = "com.empty-swift"
    }
    
    var emptyView: EmptyView {
        get {
            if let emptyView = objc_getAssociatedObject(self, &EmptyViewKeys.empty) as? EmptyView {
                return emptyView
            } else {
                let emptyView = EmptyView()
                objc_setAssociatedObject(self, &EmptyViewKeys.empty, emptyView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                addSubview(emptyView)
                bringSubviewToFront(emptyView)
                emptyView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                return emptyView
            }
        }
    }
}
