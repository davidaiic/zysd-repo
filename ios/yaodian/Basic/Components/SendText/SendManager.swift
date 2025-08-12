//
//  SendManager.swift
//  Basic
//
//  Created by wangteng on 2023/3/25.
//

import Foundation

class SendManager {
    
    var isSending = false
    
    func send(type: CommentDetailDetailType,
              id: String,
              text: String,
              images: [AppendImageModel],
              handler: @escaping (String)->Void) {
        
        guard !isSending else { return }
        isSending = true
        uploadImages(images: images) { [weak self] imageURL in
            guard let self = self else { return }
            self._send(type: type, id:id, text: text, pictures: imageURL, handler: handler)
        }
    }
    
    private func uploadImages(images: [AppendImageModel], handler: @escaping (String)->Void) {
        guard !images.isEmpty else {
            handler("")
            return
        }
      
        let group = DispatchGroup()
        for image in images where image.image != nil {
            
            group.enter()
            
            if !image.imageURL.isEmpty {
                group.leave()
                continue
            }
           
            image.setupImageData { form in
                UploadManager.upload(form) {  (res ,msg)  in
                    if let res = res {
                        image.imageURL = res.url
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main, work: DispatchWorkItem(block: {
            let imageURLs = images.map{ $0.imageURL }.filter { !$0.bind.trimmed.isEmpty }
            handler(imageURLs.joined(separator: ","))
        }))
    }
    
    private func _send(type: CommentDetailDetailType, id: String, text: String, pictures: String, handler: @escaping (String)->Void) {
        BasicApi(type.sendApiPath)
            .addParameter(key: type.sendApiKey, value: id)
            .addParameter(key: "content", value: text)
            .addParameter(key: "pictures", value: pictures)
            .perform { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    self.isSending = false
                    handler("")
                case .failure(let error):
                    self.isSending = false
                    handler(error.domain)
                }
            }
    }
}
