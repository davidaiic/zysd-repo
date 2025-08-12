//
//  PHAssetHelper.swift
//  Basic
//
//  Created by wangteng on 2023/4/14.
//

import Foundation
import Photos

extension PHAsset {
    
    var isGIF: Bool {
        if (self.value(forKey: "filesname") as? String)?.hasSuffix("cF") == true {
            return true
        }
        return false
    }
}

