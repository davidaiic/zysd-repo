//
//  BasicSharedModel.swift
//  MotorFans
//
//  Created by wangteng on 2022/7/26.
//  Copyright © 2022 MotorFans, JDD. All rights reserved.
//

import UIKit

@objcMembers
class BasicSharedModel: NSObject {
    
    var platforms: [BasicSharedItemModel] = []
    var operations: [BasicSharedItemModel] = []
    
    var items: [BasicSharedItemModel] {
        return [platforms, operations].flatMap { $0 }.sorted(by: { $0.sortIdx < $1.sortIdx })
    }
    
    var containerHeight: CGFloat {
        var height: CGFloat = 109+UIScreen.bind.safeBottomInset // 25+25+44+15
        let maxColum = UIScreen.main.bounds.width > 320 ? 5 : 4
        switch items.count {
        case 0...maxColum:
            height += 69
        default:
            height += 158 // 69*2+20
        }
        return height
    }
    
    override init() {
        super.init()
    }
    
    init(platformTypes: [BasicSharedPlatformType]) {
        self.platforms = platformTypes.map { $0.basicSharedItemModel }
    }
    
    init(platforms: [BasicSharedItemModel]) {
        self.platforms = platforms
    }
  
    init(platforms: [BasicSharedItemModel], operations: [BasicSharedItemModel]) {
        self.operations = operations
        self.platforms = platforms
    }
    
    init(platformTypes: [BasicSharedPlatformType], operationTypes: [BasicSharedOperationType]) {
        self.platforms = platformTypes.map { $0.basicSharedItemModel }
        self.operations = operationTypes.map { $0.basicSharedItemModel }
    }
      
    func find(operationType: BasicSharedOperationType) -> BasicSharedItemModel? {
        operations.first(where: { $0.operationType == operationType})
    }
}

@objcMembers
class BasicSharedItemModel: NSObject {
    
    var title = ""
    var imageNamed = ""
    var textColor: UIColor =  #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
    
    var operationType: BasicSharedOperationType = .unspecified
    var platformType: BasicSharedPlatformType = .unspecified
    
    // 排序值、越小越靠前
    var sortIdx = 0
    
    override init() {
        super.init()
    }
    
    class func collectOperation(hasCollected: Bool) -> BasicSharedItemModel {
        if hasCollected {
            return BasicSharedItemModel(operationType: .cancelCollect)
        } else {
            return BasicSharedItemModel(operationType: .collect)
        }
    }
  
}

/// 初始化方法
extension BasicSharedItemModel {
    
    convenience init(title: String = "",
                     imageNamed: String = "",
                     operationType: BasicSharedOperationType? = nil,
                     platformType: BasicSharedPlatformType? = nil) {
        self.init()
        self.title = title
        self.imageNamed = imageNamed
        self.operationType = operationType ?? .unspecified
        self.platformType = platformType ?? .unspecified
    }
    
    convenience init(title: String = "",
                     imageNamed: String = "",
                     operationType: BasicSharedOperationType) {
        self.init()
        self.title = title
        self.imageNamed = imageNamed
        self.operationType = operationType
    }

    convenience init(title: String = "",
                     imageNamed: String = "",
                     platformType: BasicSharedPlatformType) {
       
        self.init()
        self.title = title
        self.imageNamed = imageNamed
        self.platformType = platformType
    }
    
    convenience init(operationType: BasicSharedOperationType) {
        self.init()
        let model = operationType.basicSharedItemModel
        self.title = model.title
        self.imageNamed = model.imageNamed
        self.operationType = operationType
    }
    
    convenience init(platformType: BasicSharedPlatformType) {
        self.init()
        let model = platformType.basicSharedItemModel
        self.title = model.title
        self.imageNamed = model.imageNamed
        self.platformType = platformType
    }
}

extension BasicSharedItemModel {
    
    class func wechatSession() -> BasicSharedItemModel {
        BasicSharedPlatformType.wechatSession.basicSharedItemModel
    }
    class func wechatTimeLine() -> BasicSharedItemModel {
        BasicSharedPlatformType.wechatTimeLine.basicSharedItemModel
    }
    class func miniProgram() -> BasicSharedItemModel {
        BasicSharedPlatformType.miniProgram.basicSharedItemModel
    }
}

@objc
enum BasicSharedPlatformType: Int {
    
    case unspecified
    /// 微信好友
    case wechatSession
    /// 微信朋友圈
    case wechatTimeLine
    /// 微信小程序
    case miniProgram
    
    var basicSharedItemModel: BasicSharedItemModel {
        switch self {
        case .unspecified:
            return BasicSharedItemModel(title: "", imageNamed: "", platformType: self)
        case .miniProgram:
            return BasicSharedItemModel(title: "微信", imageNamed: "shared_default_image", platformType: self)
        case .wechatSession:
            return BasicSharedItemModel(title: "微信分享", imageNamed: "share_icon_weixin", platformType: self)
        case .wechatTimeLine:
            return BasicSharedItemModel(title: "朋友圈", imageNamed: "share_icon_pengyouquan", platformType: self)
        }
    }
    
    var installTip: String {
        switch self {
        case .unspecified:
            return ""
        case .miniProgram, .wechatSession, .wechatTimeLine:
            return "请先安装微信客户端"
        }
    }
}

@objc
enum BasicSharedOperationType: Int {
    /// 无效
    case unspecified
    /// 自定义
    case custom
    // 取消按钮
    case hide
    /// 收藏
    case collect
    /// 取消收藏
    case cancelCollect
    
    var basicSharedItemModel: BasicSharedItemModel {
        switch self {
        case .custom:
            return BasicSharedItemModel(title: "", imageNamed: "", operationType: self)
        case .unspecified, .hide:
            return BasicSharedItemModel(title: "", imageNamed: "")
        case .collect:
            return BasicSharedItemModel(title: "收藏", imageNamed: "share_icon_collect", operationType: self)
        case .cancelCollect:
            return BasicSharedItemModel(title: "取消收藏", imageNamed: "share_icon_collected", operationType: self)
        }
    }
}
