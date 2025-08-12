//
//  BasicSharedManager.swift
//  MotorFans
//
//  Created by wangteng on 2022/7/26.
//  Copyright © 2022 MotorFans, JDD. All rights reserved.
//

import UIKit

@objcMembers
class BasicSharedManager: NSObject {
  
    // 分享平台和操作
    var model = BasicSharedModel()
    
    // 分享内容
    var content = BasicSharedContentModel()
    
    // 分享成功Block
    var sharedCompletion: ((NSError?) -> Void)?
    
    // 分享平台Block，通过返回`true`、`false`来判断是否可以分享。
    var platformBlock: ((BasicSharedItemModel) -> Bool)?
    
    // 分享操作Block
    var operationBlock: ((BasicSharedItemModel) -> Void)?

    func show() {
        if model.platforms.isEmpty && model.operations.isEmpty {
            return
        }
        let sharedView = BasicSharedView()
        sharedView.basicSharedModel = model
        sharedView.didSelectedBlock = { [weak self] model in
            guard let self = self else { return }
            if model.platformType != .unspecified {
                if let platformBlock = self.platformBlock, platformBlock(model) {
                    self.shareTo(platform: model.platformType)
                }
            } else if model.operationType != .unspecified {
                self.operationBlock?(model)
            }
        }
        sharedView.closeBlock = { [weak self] in
            guard let self = self else { return }
            _ = self.operationBlock?(BasicSharedItemModel.init(operationType: .hide))
        }
        sharedView.show()
    }
 
    deinit {
        debugPrint("deinit--\(self)")
    }
    
    /// 分享到平台
    /// - Parameter platform: BasicSharedPlatformType
    func shareTo(platform: BasicSharedPlatformType) {
        
        guard platform != .unspecified else { return }
        
        content.imageObject(platform: platform) { messageObject in
            
            guard let messageObject = messageObject else {
                return
            }
            
            guard WXApi.isWXAppInstalled() else {
                return
            }
            
            let req = SendMessageToWXReq()
            req.bText = false
            req.message = messageObject
            
            switch platform {
            case .unspecified:
                break
            case .wechatSession:
                req.scene = Int32(WXSceneSession.rawValue)
            case .wechatTimeLine:
                req.scene = Int32(WXSceneTimeline.rawValue)
            case .miniProgram:
                req.scene = Int32(WXSceneSession.rawValue)
            }
            WXApi.send(req) { (_) in
                
            }
        }
    }
}

extension BasicSharedManager {
    
    /// 显示分享
    /// - Parameters:
    ///   - platformBlock: 分享平台Block。通过返回`true`、`false`来判断是否可以分享。
    ///   - operationBlock: 操作Block。点击操作进行调用。
    ///   - completion: 分享成功Block
    func show(platformBlock: @escaping ((BasicSharedItemModel) -> Bool),
              operationBlock: @escaping ((BasicSharedItemModel) -> Void),
              completion: @escaping ((NSError?) -> Void)) {
        self.platformBlock = platformBlock
        self.operationBlock = operationBlock
        self.sharedCompletion = completion
        show()
    }
    
    /// 显示分享
    /// - Parameters:
    ///   - platformBlock: 分享平台Block。通过返回`true`、`false`来判断是否可以分享。
    ///   - operationBlock: 操作Block。点击操作进行调用。
    ///   - completion: 分享成功Block
    func show(platformBlock: @escaping ((BasicSharedItemModel) -> Bool),
              completion: @escaping ((NSError?) -> Void)) {
        self.platformBlock = platformBlock
        self.sharedCompletion = completion
        show()
    }
    
    /// 显示分享
    /// - Parameters:
    ///   - platformBlock: 分享平台Block。通过返回`true`、`false`来判断是否可以分享。
    ///   - operationBlock: 操作Block。点击操作进行调用。
    ///   - completion: 分享成功Block
    func show(platformBlock: @escaping ((BasicSharedItemModel) -> Bool)) {
        self.platformBlock = platformBlock
        show()
    }
}
