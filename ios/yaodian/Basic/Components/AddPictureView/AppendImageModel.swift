//
//  AppendImageModel.swift
//  Basic
//
//  Created by wangteng on 2023/4/15.
//

import Foundation
import Photos
import ZLPhotoBrowser

class AppendImageModel {
    
    enum OpType {
        case add
        case image
    }
  
    var image: UIImage?
    var opType: OpType = .image
   
    var asseet: PHAsset?
    var imageURL = ""
    var imageData: Data?
    
    var isGIF: Bool {
        if let asseet = asseet, asseet.isGIF {
            return true
        }
        return false
    }
    
    convenience init(opType: OpType) {
        self.init()
        self.opType = opType
    }
    
    func setupImageData(handler: @escaping (UploadForm) -> Void) {
        compressImage(handler: handler)
    }
    
    func compressImage(handler: @escaping (UploadForm) -> Void) {
        if let image = image {
            imageData = image.bind.compressImage(maxKb: 400)
            handler(self.uploadForm)
        } else {
            handler(self.uploadForm)
        }
    }
    
    var uploadForm: UploadForm {
        guard let data = imageData else {
            return UploadForm(data: nil)
        }
        let uploadForm = UploadForm(data: data)
        return uploadForm
    }
}
