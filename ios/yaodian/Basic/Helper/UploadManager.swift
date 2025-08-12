//
//  UploadManager.swift
//  Basic
//
//  Created by wangteng on 2023/3/18.
//

import Foundation
import KakaJSON

class UploadManager {
    
    enum UploadType: String {
        /// 缺省
        case unspecified
        /// 照片
        case photo
        /// 头像
        case avatar
        /// 轮播图
        case banner
        /// 药品图
        case goods
        /// 药厂图
        case company
        /// 图标
        case icon
        /// 二维码
        case qrcode
        /// 意见反馈
        case feedback
    }
    
    static func upload(_ form: UploadForm, type: UploadType = .unspecified,
                       handler: @escaping (UploadResponse?, String?) -> Void) {
        
        var path = "plugin/upload"
        switch type {
        case .avatar:
            path = "user/updateAvatar"
        default:
            break
        }
      
        let api = BasicApi(path)
        switch type {
        case .avatar:
            break
        case .unspecified:
            break
        default:
            api.addParameter(condition: true, key: "type", value: type.rawValue)
        }
        
        api.upload(form: form) { _ in
            
        } completionHandler: { result in
            switch result {
            case .success(let res):
                handler(res.model(UploadResponse.self), nil)
            case .failure(let error):
                handler(nil, error.domain)
            }
        }
    }
}

class UploadResponse: Convertible {
    
    required init() {}
    
    var url = ""
    
    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        switch property.name {
        case "url": return "avatar"
        default: return property.name
        }
    }
}
