//
//  BindControl.swift
//  Bind
//
//  Created by wangteng on 2023/3/1.
//

import Foundation

public extension Bind where T: UIControl {
    
    /// Add a block for UIControl event
    /// - Parameters:
    ///   - event: The UIControl.Event.
    ///   - block: The block which is invoked then the action message is sent
    /// - Returns: No return.
    func addTargetEvent(_ event: UIControl.Event = .touchUpInside,
                        handler: @escaping (T)->()) {
        let targetAction = TargetAction(view: base) { view in
            handler(view as! T)
        }
        base.addTarget(targetAction, action: #selector(targetAction.trigger), for: event)
        self.base.targetAction = targetAction
    }
}
