//
//  AppWebPathConfiguration.swift
//  Basic
//
//  Created by wangteng on 2023/4/17.
//

import Foundation
import KakaJSON

class AppWebPathConfiguration {
    
    static let shared = AppWebPathConfiguration()
    
    var webPaths: [AppWebPath] = []
    
    @UserDefaultsWrapper(key: "AppWebPathConfiguration.diskWebPaths.key")
    private var diskWebPaths: String?
    
    func setup() {
        setupWebPaths()
    }
}

extension AppWebPathConfiguration {
    
    func setupWebPaths() {
        
        /// 用户协议
        let privacyUser = AppWebPath()
        privacyUser.linkUrl = AppWebPath.Path.privacyUser.rawValue
        webPaths.append(privacyUser)
        
        /// 隐私政策
        let privacyPolicy = AppWebPath()
        privacyPolicy.linkUrl = AppWebPath.Path.yszy.rawValue
        webPaths.append(privacyPolicy)
        
        if let diskWebPaths = diskWebPaths, !diskWebPaths.isEmpty {
            webPaths = diskWebPaths.kj.modelArray(AppWebPath.self)
        }
        setupWebPathsFromRemote()
    }
    
    func setupWebPathsFromRemote() {
        BasicApi("plugin/webUrl")
            .perform { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let res):
                    self.webPaths = res.modelArray(AppWebPath.self, key: "urlList")
                    self.diskWebPaths = self.webPaths.kj.JSONString()
                case .failure:
                    break
                }
        }
    }
    
    func webPath(_ path: AppWebPath.Path) -> AppWebPath {
        guard let configuration = webPaths.first(where: { $0.path == path }) else {
            return AppWebPath()
        }
        return configuration
    }

    func openWeb(_ path: AppWebPath.Path) {
        let configuration = webPath(path)
        BaseWebViewController.init(webURL: configuration.webURL, navigationTitle: configuration.navigationTitle).bind.push()
    }
}

class AppWebPath: Convertible {
    
    required init() {}
    
    var keyword = ""
    
    var title = ""
    
    var linkUrl = ""
    
    var navigationTitle: String {
        if title.bind.trimmed.isEmpty { return "识药查真伪" }
        return title
    }
    
    var webURL = ""
    
    var path: Path = .unspecified
    
    func kj_didConvertToModel(from json: [String : Any]) {
        setup()
    }
    
    func setup() {
        webURL = BasicApi.url(linkUrl, type: .h5)
        path = Path.init(rawValue: keyword) ?? .unspecified
    }
    
    enum Path: String, CaseIterable {
        
        case unspecified = "识药查真伪"
        /// 用户协议
        case privacyUser = "yhxy"
        /// 联系我们
        case callUs = "lxwm"
        /// 反馈
        case feedback = "yjfk"
        /// 人工核查
        case personCheck = "rghc"
        /// 价格查询
        case queryPrice = "jgcx"
         /// 上传图片
        case uploadPhoto = "zpcx"
        /// 查询历史
        case searchHistory = "lscx"
        /// 分享码
        case sharedCode = "ewm"
        ///  基本信息
        case basicInfo
        /// 设备信息
        case deviceInfo
        /// 三方信息
        case threeInfo
        /// 使用信息
        case useInfo
        /// 我要送检
        case wysj
        /// 我要比价
        case wybj
        ///  隐私政策
        case yszy
        /// 基因检测
        case jyjc
        /// 患者招募
        case hzzm
        /// 慈善救助
        case csjz
        /// 真伪鉴别
        case zwjb
        /// 用户管理
        case userMange
        /// 药厂查询
        case yccx
        case sms
        /// 有分风险
        case smRisk
        /// 关于掌上药店
        case about
    }
}
