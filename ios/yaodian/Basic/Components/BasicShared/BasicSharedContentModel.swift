//
//  BasicSharedContentModel.swift
//  MotorFans
//
//  Created by wangteng on 2022/12/13.
//  Copyright © 2022 MotorFans, JDD. All rights reserved.
//

import UIKit
import Kingfisher
import KakaJSON

@objcMembers
/// 分享内容
class BasicSharedContentModel: NSObject, Convertible {
    
    var url = ""
    
    var title = ""
    
    var desc = ""
    
    /// 微信小程序Path
    var path = ""
    
    ///  base64 || url
    var imageURL: String?
    
    required override init() {
        super.init()
    }
    
}

extension BasicSharedContentModel {
    
    func imageObject(platform: BasicSharedPlatformType, completion: @escaping (WXMediaMessage?) -> Void ) {

        sharedImage { [weak self] image in
            guard let self = self else { return }
            
            /// 仅仅分享图片
            if self.title.isEmpty && self.desc.isEmpty && image != nil {
                let imageObject = WXImageObject()
                imageObject.imageData = image?.bind.compressImage() ?? Data()
                let message = WXMediaMessage()
                message.mediaObject = imageObject
                completion(message)
                return
            }

            switch platform {
            case .unspecified:
                completion(nil)
                return
            case .miniProgram:
                let object = WXMiniProgramObject()
                object.webpageUrl = self.url;
                object.userName = "gh_15bcd961d4b4";
                object.path = self.path;
                let imageData = image?.bind.compressImage() ?? Data()
                object.hdImageData = imageData
                object.miniProgramType = .release
                
                let message = WXMediaMessage()
                message.title = self.title
                message.description = self.desc
                message.mediaObject = object
                completion(message)
            case .wechatSession, .wechatTimeLine:
                let webpageObject = WXWebpageObject()
                webpageObject.webpageUrl = self.url
                let message = WXMediaMessage()
                message.mediaObject = webpageObject
                message.title = self.title
                message.description = self.desc
                if let image = image {
                    message.setThumbImage(image)
                }
                completion(message)
            }
        }
    }
    
    private var shareDesc: String {
        if desc.isEmpty { return "" }
        if desc.count > 200 {
            return String(desc.suffix(200))
        }
        return desc
    }
    
    func sharedImage(completion: @escaping (UIImage?) -> Void) {
        
        let imageURL = imageURL ?? ""
        let hasPrefix = imageURL.hasPrefix("http")
        if !imageURL.bind.trimmed.isEmpty, hasPrefix {
            if imageURL.hasPrefix("http"), let url = URL(string: imageURL) {
                KingfisherManager.shared.retrieveImage(with: url) { result in
                    switch result {
                    case .success(let value):
                        DispatchQueue.main.async {
                            completion(value.image)
                        }
                    case .failure:
                        let downloader = ImageDownloader.default
                        downloader.downloadImage(with: url) { result in
                            switch result {
                            case .success(let value):
                                DispatchQueue.main.async {
                                    completion(value.image)
                                }
                            case .failure:
                                DispatchQueue.main.async {
                                    completion(self.placeHolderImage())
                                }
                            }
                        }
                    }
                }
            } else {
                let base64Encoded = (imageURL as NSString).replacingOccurrences(of: "data:image/png;base64,", with: "")
                if let imageData = Data(base64Encoded: base64Encoded),
                    let image = UIImage(data: imageData) {
                    completion(image)
                } else {
                    completion(self.placeHolderImage())
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if let keyWindow = UIWindow.currentWindow,
                    let image = keyWindow.bind.screenshot {
                    let crop = image.kf.crop(to: .init(width: UIScreen.bind.width, height: UIScreen.bind.width), anchorOn:  CGPoint(x: 0.5, y: 0.5))
                    completion(crop)
                }
            }
        }
    }
    
    func placeHolderImage() -> UIImage? {
         UIImage(named: "shared_default_image")
    }
}
