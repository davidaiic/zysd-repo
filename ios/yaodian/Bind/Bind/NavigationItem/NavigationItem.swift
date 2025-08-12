//
//  UINavigationItem.swift
//  Drug
//
//  Created by wangteng on 2023/2/11.
//

import Foundation

public extension UINavigationItem {
    
    enum Position {
        case left, right
    }
    
    func add(_ buttons: [BaseButton], position: Position, completionHandler: @escaping (BaseButton) -> Void) {
        buttons.forEach { button in
            button.bind.addTargetEvent { btn in
                completionHandler(btn)
            }
        }
        switch position {
        case .left:
            self.leftBarButtonItems = buttons.map{ UIBarButtonItem(customView: $0) }
            self.backBarButtonItem = nil
        case .right:
            self.rightBarButtonItems = buttons.map{ UIBarButtonItem(customView: $0) }
        }
    }
    
    func add(_ button: BaseButton, position: Position, completionHandler: @escaping (BaseButton) -> Void) {
        self.add([button], position: position, completionHandler: completionHandler)
    }
}

