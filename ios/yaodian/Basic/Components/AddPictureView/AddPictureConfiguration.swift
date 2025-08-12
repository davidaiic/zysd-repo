//
//  AddPictureViewConfiguration.swift
//  Basic
//
//  Created by wangteng on 2023/3/2.
//

import UIKit
import ZLPhotoBrowser
import Bind

class AddPictureConfiguration {
    
    var models: [AppendImageModel] = [AppendImageModel(opType: .add)]
    
    var maxImages = 9
    
    var canBroswer = true
    
    var maxWidth: CGFloat = 300 {
        didSet {
            configItemSize()
        }
    }
    
    var row = 3 {
        didSet {
            configItemSize()
        }
    }
    
    var spacing: CGFloat = 10 {
        didSet {
            configItemSize()
        }
    }
    
    var itemSize: CGSize = .zero
    
    func configItemSize() {
        let width = (maxWidth-CGFloat(row-1)*spacing)/CGFloat(row)
        self.itemSize = .init(width: width, height: width)
    }
    
    var height: CGFloat {
        var rows = models.count%row
        if rows == 0 {
            rows = models.count/row
        } else {
            rows = models.count/row + 1
        }
        let height = CGFloat(rows)*(itemSize.height+spacing) - spacing
        return height
    }
    
    func add(images: [AppendImageModel]) {
        self.models.insert(contentsOf: images, at: self.models.count-1)
        let images = self.models.filter({$0.opType == .image})
        if images.count == self.maxImages {
            self.models = images
        }
        heightHandler?(height)
    }
    
    func remove(_ index: Int) {
        guard models.indices ~= index else {
            return
        }
        models.remove(at: index)
        
        if imageCount < maxImages {
            if !models.contains(where: { $0.opType == .add }) {
                models.append(AppendImageModel(opType: .add))
            }
        }
        
        heightHandler?(height)
    }
    
    var heightHandler: ((CGFloat) -> Void)?
    
    var imageCount: Int {
        models.filter({$0.opType == .image}).count
    }
    
    var imagModels: [AppendImageModel] {
        models.filter({$0.opType == .image})
    }
    
    func removeAllImages() {
        models.removeAll()
        models.append(AppendImageModel(opType: .add))
    }
}
