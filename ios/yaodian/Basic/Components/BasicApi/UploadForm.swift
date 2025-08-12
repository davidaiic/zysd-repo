//
//  BasicUploadModel.swift
//  Basic
//
//  Created by wangteng on 2023/4/14.
//

import Foundation
import Alamofire

class UploadForm {
    
    var data: Data?
    
    var suffix = "jpeg"
    
    let withName = "file"
    
    var fileName: String { "image_\(Date().timeIntervalSince1970)."+suffix }
    
    var mimeType: String { "image/"+suffix }
    
    func addTo(_ form: MultipartFormData) {
        if let data = data {
            form.append(data, withName: withName, fileName: fileName, mimeType: mimeType)
        }
    }
    
    init(data: Data?, suffix: String = "jpeg") {
        self.data = data
        self.suffix = suffix
    }
}
