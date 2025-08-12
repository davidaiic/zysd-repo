//
//  ScannerHandler.swift
//  Basic
//
//  Created by wangteng on 2023/3/5.
//

import Foundation
import Bind
import KakaJSON

public enum ScanCodeError: String, Error {
    case noDevice
    case unAvailable
    case noPermission
    case unSupportBar
    case unSupportTd
    case capture
    case detector
    
    var popString: String {
        switch self {
        case .noDevice:
            return "未发现相机"
        case .unAvailable:
            return "未发现摄像头"
        case .noPermission:
            return "请在iPhone的\"设置 > 隐私 > 相机\"选项中，允许\(UIApplication.shared.bind.appBundleName)访问你的相机"
        case .unSupportBar:
            return "未识别到有效的二维码"
        case .unSupportTd:
            return "未识别到有效的条形码"
        case .capture:
            return "未识别到有效的图片"
        case .detector:
            return "未识别到有效的条形码"
        }
    }
}

public protocol ScannerDelegate: NSObjectProtocol {
    func scanResult(_ result: ScannerResult)
}

public enum ScannerResult {
    case scan(message: String)
    case capture(image: UIImage)
    case failure(ScanCodeError)
    case detector(message: String)
}

public enum CodeType {
    case td
    case bar
    case all
}

class ScannerApiManager {
    
    static func recognition(_ data: Data?,
                     handler: @escaping (RecognitionModel?) -> Void) {
      
        let api = BasicApi("query/imageRecognition")
        api.upload(form: .init(data: data)) { _ in
            
        } completionHandler: { result in
            switch result {
            case .success(let res):
                handler(res.model(RecognitionModel.self))
            case .failure(let error):
                handler(nil)
                Toast.showMsg(error.domain)
            }
        }
    }
    
    static func scanCode(_ code: String,
                     handler: @escaping (ScanCodeResponseModel?) -> Void) {
        let api = BasicApi("query/scanCode2")
        api.addParameter(key: "code", value: code)
            .perform { result in
                switch result {
                case .success(let res):
                    handler(res.model(ScanCodeResponseModel.self))
                case .failure(let error):
                    handler(nil)
                    Toast.showMsg(error.domain)
                }
        }
    }
}

class ScanCodeResponseModel: Convertible {
    
    required init() {}
    
    /// 0-无结果，1-有结果
    var result = 0
    
    /// 药品风险等级，为1显示高风险，为0不显示
    var risk = 0
    
    /// 药品id
    var goodsId = ""
    
    /// 药品名称
    var goodsName = ""
    
    var serverName = ""
    
    var linkUrl = ""
    
    var webURL: String {
        BasicApi.url(linkUrl, type: .h5)
    }
    
}


class RecognitionModel: Convertible {
    
    class Keywords: Convertible {
        required init() {}
        var name = ""
    }
    
    required init() {}
    
    var imageId = ""
    var imageUrl = ""
    var keywords: [Keywords] = []
    
    
    func router() {
        
    }
    
}
