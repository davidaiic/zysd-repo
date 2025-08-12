//
//  WeakProxy.swift
//  Bind
//
//  Created by wangteng on 2023/3/4.
//

import Foundation

public class WeakProxy: NSObject  {

    public weak var target: NSObject?
    
    public static func proxyWithTarget(target: NSObject) -> WeakProxy {
        return WeakProxy.init(target: target)
    }

    convenience init(target:NSObject){
        self.init()
        self.target = target
    }
    public override func forwardingTarget(for aSelector: Selector!) -> Any? {
        return target
    }

    public override func isEqual(_ object: Any?) -> Bool {
        return target?.isEqual(object) ?? false
    }
    
    public override var hash: Int{
        return target?.hash ?? -1
    }
    
    public override var superclass: AnyClass?{
        return target?.superclass ?? nil
    }

    public override func isProxy() -> Bool {
        return true
    }

    public override func isKind(of aClass: AnyClass) -> Bool {
        return target?.isKind(of: aClass) ?? false
    }
    
    public override func isMember(of aClass: AnyClass) -> Bool {
        return target?.isMember(of: aClass) ?? false
    }
    
    public override func conforms(to aProtocol: Protocol) -> Bool {
        return  target?.conforms(to: aProtocol) ?? false
    }
    
    public override func responds(to aSelector: Selector!) -> Bool {
        return target?.responds(to: aSelector) ?? false
    }
    
    public override var description: String{
        return target?.description ?? "nil"
    }
    
    public override var debugDescription: String{
        return target?.debugDescription ?? "nil"
    }
    
    deinit {
        debugPrint("deinit--\(self)")
    }
}
