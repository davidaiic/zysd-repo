//
//  BasicPopImageItem.swift
//  MotorFansKit
//
//  Created by wangteng on 2023/2/24.
//

import Foundation

@objcMembers
public class BasicPopImageItem: NSObject {
    
    /// 当前高度，通过`configureHeight(:_)` 方法进行赋值 由`BasicPopConfiguration`负责调用
    public var height: CGFloat = 0
    
    /// 图片 默认为 `nil`
    public var image: UIImage?
    
    /// 图片显示的尺寸，默认为0， 为0获取image的尺寸
    public var size: CGSize = .zero
    
    /// 个性化 `UIImageView` handler
    public var configureHandler: ((UIImageView) -> Void)?
    
}

extension BasicPopImageItem: BasicPopItemble {
    
    /// 配置高度由`BasicPopConfiguration`负责调用
    public func configureHeight(_ configuration: BasicPopConfiguration) {
        if size.height > 0 {
            height = size.height
        } else if let image = self.image, image.size.width != 0, image.size.height != 0 {
            var imageWidth: CGFloat = 0
            
            let contentMaxWidth = configuration.contentMaxWidth-configuration.padding.left-configuration.padding.right
            
            /// 图片宽度大于容器最大宽度进行等比缩放
            if image.size.width > contentMaxWidth {
                imageWidth = contentMaxWidth
                height = image.size.height/image.size.width*contentMaxWidth
            } else {
                imageWidth = image.size.width
                height = image.size.height
            }
            size = .init(width: imageWidth, height: height)
        }
    }
}
