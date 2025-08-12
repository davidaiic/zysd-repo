//
//  MainTabBar.swift
//  Drug
//
//  Created by wangteng on 2023/2/10.
//

import UIKit
import Bind

class EntryTabBar: UITabBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.shadowPath = UIBezierPath.init(roundedRect: CGRect(x: 0,
                                                                      y: 0,
                                                                      width: self.bounds.width,
                                                                      height: self.bounds.height),
                                                  cornerRadius: 5).cgPath
        
        for button in subviews where button is UIControl  {
            var frame = button.frame
            frame.origin.y = -2
            button.frame = frame
        }
    }
    
    @objc func setUp() {
        self.isTranslucent = false
        self.shadowImage = UIImage()
        self.barTintColor = .white
        self.backgroundImage = UIImage(fd_color: .white, fd_size: .init(width: 1, height: 1))
        self.bind.shadow(color: .black, radius: 5, offset: .zero, opacity: 0.1)
        self.layer.masksToBounds = false
        configureAppearance()
    }
    
    public func configureAppearance() {
        
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor.white
        appearance.shadowImage = UIImage(fd_color: .white, fd_size: .init(width: 1, height: 1))
        appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
        /// 选中
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor("#5CC5AD")
        ]
        /// 非选中
        appearance.stackedLayoutAppearance.normal.titleTextAttributes =  [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor("#C0C0C0")
        ]
        appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
     
        self.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            self.scrollEdgeAppearance = appearance
        }
    }
}

extension UIImage {
    
    /// FDFoundation: Create UIImage from color and size.
    ///
    /// - Parameters:
    ///   - color: image fill color.
    ///   - size: image size.
    convenience init(fd_color: UIColor, fd_size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(fd_size, false, 1)
        fd_color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: fd_size.width, height: fd_size.height))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            self.init()
            return
        }
        UIGraphicsEndImageContext()
        guard let aCgImage = image.cgImage else {
            self.init()
            return
        }
        self.init(cgImage: aCgImage)
    }
}
