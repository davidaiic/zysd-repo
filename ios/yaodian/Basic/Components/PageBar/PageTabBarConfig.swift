//
//  PageTabBarConfig.swift
//  Drug
//
//  Created by wangteng on 2023/3/1.
//

import Foundation


public extension PageTabBar {
    
    struct Config {
        
        let normalColor: UIColor
        let normalFont: UIFont
        let selectedColor: UIColor
        let selectedFont: UIFont
        let leftMargin: CGFloat
        let rightMargin: CGFloat
        let minimumInteritemSpacing: CGFloat
        let expandButtonWidth: CGFloat
        let indicatorBottomGap: CGFloat
        let indicatorHeight: CGFloat
        let indicatorCornerRadius: CGFloat
        let indicatorColor: UIColor
        let alignment: Alignment
        let height: CGFloat
        var indicatorImage: UIImage?
    }
    
    enum Alignment {
        case left
        case center
    }
}

extension PageTabBar.Config {
    
    static let common: PageTabBar.Config = PageTabBar.Config(
        normalColor: UIColor("#666666"),
        normalFont: UIFont.systemFont(ofSize: 16, weight: .regular),
        selectedColor: UIColor("#333333"),
        selectedFont: UIFont.systemFont(ofSize: 16, weight: .medium),
        leftMargin: 20,
        rightMargin: 20,
        minimumInteritemSpacing: 35,
        expandButtonWidth: 0,
        indicatorBottomGap: 12,
        indicatorHeight: 3,
        indicatorCornerRadius: 1.5,
        indicatorColor: .clear,
        alignment: .left,
        height: 40,
        indicatorImage: "title_shadow_image".bind.image
    )
    
    static let shareCodeWrapper: PageTabBar.Config = PageTabBar.Config(
        normalColor: .white,
        normalFont: UIFont.systemFont(ofSize: 14, weight: .regular),
        selectedColor: .white,
        selectedFont: UIFont.systemFont(ofSize: 17, weight: .medium),
        leftMargin: 12,
        rightMargin: 12,
        minimumInteritemSpacing: 12,
        expandButtonWidth: 20,
        indicatorBottomGap: 12,
        indicatorHeight: 3,
        indicatorCornerRadius: 1.5,
        indicatorColor: .clear,
        alignment: .center,
        height: 40,
        indicatorImage: nil
    )
}
