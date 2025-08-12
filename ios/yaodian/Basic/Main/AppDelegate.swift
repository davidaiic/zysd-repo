//
//  AppDelegate.swift
//  Basic
//
//  Created by wangteng on 2023/3/1.
//

import UIKit
import Bind

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setup()
        return true
    }
}

extension AppDelegate {
    
    private func setup() {
        ReachabilityManager.shared.setupReachability()
        QuickLoginManager.shared.register()
        registerWechat()
        Thread.sleep(forTimeInterval: 1.5)
        configureWindow()
    }
    
    private func configureWindow() {
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0;
        }
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        self.window?.rootViewController = EntryTabController()
        self.window?.makeKeyAndVisible()
        configurePhoto()
    }
}

extension AppDelegate: WXApiDelegate {
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        var mode: ScanningView.Mode = .scan
        switch shortcutItem.type {
        case "1":
            mode = .capture
        case "2":
            mode = .scan
        default:
            completionHandler(false)
            return
        }
        let scanningController = ScanningController(type: .bar)
        scanningController.mode = mode
        scanningController.hidesBottomBarWhenPushed = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            scanningController.bind.push()
        }
        completionHandler(true)
    }
    
    func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        return true
    }
    
    private func registerWechat() {
        let register = WXApi.registerApp(AppKeys.wechatAppId, universalLink: AppKeys.universalLink)
        debugPrint(#function,register)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        if let webpageURL = userActivity.webpageURL {
            let webpageURLString = webpageURL.absoluteString
            if webpageURLString.hasPrefix(AppKeys.universalLink) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    Router.shared.route(webpageURLString)
                }
                return true
            }
        }
        return WXApi.handleOpenUniversalLink(userActivity, delegate: self)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return WXApi.handleOpen(url, delegate: self)
    }
    
    func onReq(_ req: BaseReq) {

    }
    
    func onResp(_ resp: BaseResp) {
        switch resp {
        case let res as SendMessageToWXResp:
            debugPrint(res.errCode)
            NotificationCenter.default.post(name: .share, object: nil)
        default:
            break
        }
    }
}
