//
//  ILWebBridge.swift
//  yunbaolive
//
//  Created by wangteng on 2020/8/7.
//  Copyright © 2020 cat. All rights reserved.
//

import UIKit
import KakaJSON
import Kingfisher
import Lantern

extension BaseWebViewController {
    
    /// 同步
    @objc
    func synCallNative(_ arg: NSDictionary) -> NSDictionary {
        guard let model = arg.kj.model(WebBridgeResponse.self) else {
            return [:]
        }
        switch model.action {
        case .getUserInfo:
            return triggerUserInfo()
        case .browserImage:
            browserImage(model)
        case .back:
            backPage()
        case .goodsDetail:
            triggerGoodsDetail(model)
        default: break
        }
        return WebBridgeHandlerResponse(value: arg).response as NSDictionary
    }
    
    /// 异步
    @objc
    func asynCallNative( _ arg: NSDictionary, handler: @escaping (NSDictionary)->Void) {
        self.bridgeHandler = handler
        guard let model = arg.kj.model(WebBridgeResponse.self) else {
            return
        }
        switch model.action {
        case .scan:
            let scanningController = ScanningController(type: .bar)
            scanningController.mode = .scan
            scanningController.delegate = self
            scanningController.supportType = .td
            scanningController.scanBridge = true
            scanningController.hidesBottomBarWhenPushed = true
            scanningController.bind.push()
        case .goLogin:
           triggerLogin()
        case .photo:
            triggerPhoto(model)
        case .share:
            triggerShared(model)
            guard let handler = self.bridgeHandler else { return }
            handler(arg)
            self.bridgeHandler = nil
            
        case .saveImage:
            triggerSaveImage(model)
        default:
            break
        }
    }
}


extension BaseWebViewController {
    
    func browserImage(_ model: WebBridgeResponse) {
        
        var selectedIndex = 0
        guard let imageURLs = model.value["imageURLs"] as? [String],
        !imageURLs.isEmpty else {
            return
        }
        
        if let index = model.value["index"] as? String {
            if imageURLs.indices ~= index.bind.integerValue {
                selectedIndex = index.bind.integerValue
            }
        }
        
        let lantern = Lantern()
        lantern.numberOfItems = {
            return imageURLs.count
        }

        lantern.cellClassAtIndex = { _ in
            LoadingImageCell.self
        }
        lantern.reloadCellAtIndex = { context in
            guard let lanternCell = context.cell as? LoadingImageCell else {
                return
            }
            lanternCell.index = context.index
            let url = imageURLs[context.index]
            lanternCell.reloadData(placeholder: nil, urlString: url)
        }
        lantern.pageIndicator = LanternDefaultPageIndicator()
        lantern.pageIndex = selectedIndex
        lantern.show()
    }
}

extension BaseWebViewController {
    
    func triggerShared(_ model: WebBridgeResponse) {
        
        let shareModel = BasicSharedModel(platformTypes: [.miniProgram])
        sharedManager.model = shareModel
        
        sharedManager.show { [weak self] _  in
            guard let self = self else { return true }
            
            /// 分享内容
            let content = model.value.kj.model(BasicSharedContentModel.self)
            self.sharedManager.content = content
            
            return true
        } completion: { _ in
            
        }
    }
    
    func triggerGoodsDetail(_ model: WebBridgeResponse) {
        guard let goodsId = model.value["goodsId"] as? String else {
            return
        }
        guard let risk = model.value["risk"] as? String else {
            return
        }
        let model = CommodityModel()
        model.goodsId = goodsId
        model.risk = risk.bind.integerValue
        model.open()
    }
}

extension BaseWebViewController {
    
    func triggerSaveImage(_ model: WebBridgeResponse) {
        guard let imageURL = model.value["image"] as? String else {
            return
        }
        if imageURL.hasPrefix("http"), let url = URL(string: imageURL) {
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let value):
                    self.savePhotosAlbum(value.image)
                case .failure:
                    let downloader = ImageDownloader.default
                    downloader.downloadImage(with: url) { result in
                        switch result {
                        case .success(let value):
                            self.savePhotosAlbum(value.image)
                        case .failure:
                            break
                        }
                    }
                }
            }
        } else {
            let base64Encoded = (imageURL as NSString).replacingOccurrences(of: "data:image/png;base64,", with: "")
            if let imageData = Data(base64Encoded: base64Encoded),
                let image = UIImage(data: imageData) {
                savePhotosAlbum(image)
            }
        }
    }
    
    private func savePhotosAlbum(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        guard let handler = self.bridgeHandler else { return }
        if error != nil {
            handler(WebBridgeHandlerResponse.empty as NSDictionary)
            self.bridgeHandler = nil
        } else {
            let res = WebBridgeHandlerResponse(value: true)
            handler(res.response as NSDictionary)
            self.bridgeHandler = nil
        }
    }
}

extension BaseWebViewController: ScanningControllerProtocal {
    
    /// "拍摄", "从相册选择"
    func triggerPhoto(_ model: WebBridgeResponse) {
        SheetPop().pop(titles: ["拍摄", "从相册选择"]) { [weak self] selectedIndex in
            guard let self = self else { return }
            if selectedIndex == 0 {
                self.capture()
            } else {
                var photoMaxCount = 9
                if let maxCount = model.value["max"] as? String {
                    photoMaxCount = maxCount.bind.integerValue
                }
                if photoMaxCount <= 0 {
                    return
                }
                photoMaxCount = min(photoMaxCount, 9)
                self.pickPhoto(photoMaxCount)
            }
        }
    }
    
    /// 扫码结果回掉
    public func scanning(message info: String?) {
        guard let handler = self.bridgeHandler else { return }
        guard let info = info else {
            handler(WebBridgeHandlerResponse.empty as NSDictionary)
            self.bridgeHandler = nil
            return
        }
        let res = WebBridgeHandlerResponse(value: info)
        handler(res.response as NSDictionary)
        self.bridgeHandler = nil
    }
    
    /// 拍照
    func capture() {
        CaptureImage.shared.didSelectedImagePicker = { [weak self] image in
            guard let self = self else { return }
            let imageModel = AppendImageModel()
            imageModel.image = image
            imageModel.opType = .image
            self.uploadImages(images: [imageModel])
        }
        CaptureImage.shared.capture(false)
    }

    /// 相册选择
    func pickPhoto(_ maxSelectCount: Int) {
        guard let sender = UIWindow.bind.topViewController() else {
            return
        }
        let config = PhotoConfiguration.default()
        config.allowSelectImage = true
        config.allowSelectVideo = false
        config.maxSelectCount = maxSelectCount
        let photoPicker = PhotoManager()
        photoPicker.selectImageBlock = { [weak self] (images, _) in
            guard let self = self else { return }
            let sequence = images.map { image -> AppendImageModel in
                let imageModel = AppendImageModel()
                imageModel.image = image.image
                imageModel.opType = .image
                return imageModel
            }
            self.uploadImages(images: sequence)
        }
        photoPicker.showPhotoLibrary(sender: sender)
    }
    
    /// 上传图片
    private func uploadImages(images: [AppendImageModel]) {
        
        guard let handler = self.bridgeHandler else { return }
        guard !images.isEmpty else {
            let res = WebBridgeHandlerResponse(value: [""])
            handler(res.response as NSDictionary)
            self.bridgeHandler = nil
            return
        }
      
        Hud.show(.custom(contentView: HudSpinner()))
        let group = DispatchGroup()
        for image in images where image.image != nil {
            
            group.enter()
            
            if !image.imageURL.isEmpty {
                group.leave()
                continue
            }
           
            let data = image.image!.bind.compressImage(maxKb: 400)
            UploadManager.upload(UploadForm(data: data)) {  (res ,msg)  in
                if let res = res {
                    image.imageURL = res.url
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main, work: DispatchWorkItem(block: { [weak self] in
            Hud.hide()
            guard let self = self else { return }
            let imageURLs = images.map{ $0.imageURL }.filter { !$0.bind.trimmed.isEmpty }
            let res = WebBridgeHandlerResponse(value: imageURLs)
            handler(res.response as NSDictionary)
            self.bridgeHandler = nil
        }))
    }
   
}

extension BaseWebViewController {

    /// 用户登录
    func triggerLogin() {
        guard let handler = self.bridgeHandler else { return }
        
        LoginManager.shared.loginHandler {
            Hud.show(.custom(contentView: HudSpinner()))
            UserManager.shared.updateUserInfo { [weak self] in
                Hud.hide()
                guard let self = self else { return }
                guard let user = UserManager.shared.user else {
                    handler(WebBridgeHandlerResponse.empty as NSDictionary)
                    self.bridgeHandler = nil
                    return
                }
                let res = WebBridgeHandlerResponse(value: user.kj.JSONObject())
                handler(res.response as NSDictionary)
                self.bridgeHandler = nil
            }
        }
    }
    
    /// 同步获取用户信息
    func triggerUserInfo() -> NSDictionary {
        if UserManager.shared.hasLogin, let user = UserManager.shared.user {
            return WebBridgeHandlerResponse(value: user.kj.JSONObject()).response as NSDictionary
        } else {
            return WebBridgeHandlerResponse(value: "").response as NSDictionary
        }
    }
}
