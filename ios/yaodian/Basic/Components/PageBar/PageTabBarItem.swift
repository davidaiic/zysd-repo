//
//  PageTabBarItem.swift
//  Drug
//
//  Created by wangteng on 2023/3/1.
//

import Foundation
import Kingfisher

public class PageTabBarItem: UIButton {
    
    private var completedWorkItem: DispatchWorkItem?
    
    public var info: Info?
    
    private func update(title: String?, normalImage: UIImage?, selectedImage: UIImage?) {
        self.setTitle(title, for: .normal)
        self.setImage(normalImage, for: .normal)
        self.setImage(selectedImage, for: .selected)
    }
    
    public func setImage(with info: Info, urlImageCompleted completed:@escaping () -> Void) {
        self.info = info
        completedWorkItem?.cancel()
        
        self.update(title: info.title, normalImage: nil, selectedImage: nil)
        
        /*
        guard let _ = info.urlImage else {
            return
        }
        let group = DispatchGroup()
      
        let _completedWorkItem = DispatchWorkItem { [weak self] in
            if let `self` = self,
                let normalImage = normalImage,
                let selectedImage = selectedImage {
                self.update(title: nil, normalImage: normalImage, selectedImage: selectedImage)
                completed()
            }
        }
        
        group.notify(queue: .main, work: _completedWorkItem)
        self.completedWorkItem = _completedWorkItem
         */
    }
    
}

extension PageTabBarItem {
    
    public struct Info: Hashable {
        let title: String
        let urlImage: URLImage?
    }
    
    public struct URLImage: Hashable {
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(self.normalURL)
            hasher.combine(self.selectedURL)
            hasher.combine(self.targetSize.width)
            hasher.combine(self.targetSize.height)
        }
        
        let targetSize: CGSize
        let normalURL: URL
        let selectedURL: URL
    }
    
}
