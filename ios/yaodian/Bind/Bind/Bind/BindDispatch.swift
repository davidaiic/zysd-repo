//
//  BindDispatch.swift
//  Bind
//
//  Created by wangteng on 2023/3/15.
//

import Foundation

extension DispatchQueue: Bindble { }

public extension Bind where T == DispatchQueue {
    
    // This method will dispatch the `block` to self.
    // If `self` is the main queue, and current thread is main thread, the block
    // will be invoked immediately instead of being dispatched.
    func mainAsync(_ block: @escaping ()->()) {
        if base === DispatchQueue.main && Thread.isMainThread {
            block()
        } else {
            base.async { block() }
        }
    }
    
    /// countDown
    /// - Parameter time: time description
    /// - Parameter deadline: deadline description
    /// - Parameter repeating: repeating description
    /// - Parameter eventHandler: eventHandler description
    /// - Parameter eventHandlerDispatchQueue: eventHandlerDispatchQueue description
    /// - Parameter stop: stop description
    static func countDown(time: Int,
                          deadline: DispatchTime = .now(),
                          repeating: DispatchTimeInterval = .seconds(1),
                          eventHandler: @escaping ((Int)->Void),
                          eventHandlerDispatchQueue: DispatchQueue = .main,
                          stop: @escaping ((Int)->Bool)) {
        var countTime: Int = time
        let codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())
        codeTimer.schedule(deadline: deadline, repeating: repeating)
        codeTimer.setEventHandler(handler: {
            countTime -= 1
            eventHandlerDispatchQueue.async {
                eventHandler(countTime)
            }
            if stop(countTime) {
                codeTimer.cancel()
            }
        })
        codeTimer.resume()
    }
}
