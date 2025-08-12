//
//  ReachabilityManager.swift
//  Drug
//
//  Created by wangteng on 2023/2/10.
//

import Foundation

public class ReachabilityManager {
    
    public static let shared = ReachabilityManager()
    
    public var reachability: Reachability?

    public func setupReachability(_ hostName: String? = "baidu.com") {
        let reachability: Reachability?
        if let hostName = hostName {
            reachability = try? Reachability(hostname: hostName)
        } else {
            reachability = try? Reachability()
        }
        self.reachability = reachability
        try? reachability?.startNotifier()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reachabilityChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )
    }
    
    @objc public func reachabilityChanged(_ note: Notification) {
        let reachability = note.object as! Reachability
        debugPrint(reachability.connection.description)
        AppWebPathConfiguration.shared.setup()
    }
}
