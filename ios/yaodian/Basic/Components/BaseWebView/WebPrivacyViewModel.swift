//
//  WebPrivacyViewModel.swift
//  Basic
//
//  Created by wangteng on 2023/3/18.
//

import Foundation
import KakaJSON

public class WebPrivacyViewModel: BaseViewModel {
        
    public enum WebPrivacyType: String {
        
        case unspecified
        
        /// 用户协议
        case proto = "protocol"
        
        /// 隐私政策
        case privacy
        
        /// 评论规范公约
        case criterion
        
        /// 药品批准文号
        case number
        
        /// 防伪码
        case security
        
        /// 法规解读
        case statute
        
        /// 成本解读
        case cost
        
        /// 物流服务流程
        case logistics
        
        /// 如何找微信号
        case findWx
        
        /// 如何找二维码
        case findQrCode
        
        /// 第三方信息共享清单
        case thirdShareInventory
        
        /// 用户基本信息
        case basicUserInfo
        
        /// 设备属性信息
        case deviceInfo
        
        /// 用户使用过程信息
        case userUseInfo
        
        var navigationTitle: String {
            switch self {
            case .unspecified:
                return ""
            case .proto: return "用户协议"
            case .privacy: return "隐私政策"
            case .criterion: return "评论规范公约"
            case .number: return "药品批准文号"
            case .security: return "防伪码"
            case .statute: return "法规解读"
            case .cost: return "成本解读"
            case .logistics: return "物流服务流程"
            case .findWx: return "如何找微信号"
            case .findQrCode:  return "如何找二维码"
            case .thirdShareInventory: return "第三方信息共享清单"
            case .basicUserInfo: return "用户基本信息"
            case .deviceInfo: return "设备属性信息"
            case .userUseInfo: return "用户使用过程信息"
            }
        }
    }
    
    var webPrivacyType: WebPrivacyType = .unspecified
    var webPrivacyModel = WebPrivacyModel()
    
    func fetchWebData() {
        
        guard webPrivacyType != .unspecified else { return }
        
        BasicApi("plugin/content")
            .addParameter(key: "keyword", value: webPrivacyType.rawValue)
            .perform { result in
                switch result {
                case .success(let res):
                    self.webPrivacyModel = res.model(WebPrivacyModel.self)
                    self.fetchDelegate?.onCompletion(.onCompleted)
                case .failure(let failure):
                    self.fetchDelegate?.onCompletion(.failure(failure))
                }
            }
    }
}

class WebPrivacyModel: Convertible {
    
    required init() {}
    
    var title = ""
    var content = ""
}
