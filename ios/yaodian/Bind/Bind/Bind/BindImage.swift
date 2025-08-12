//
//  BindImage.swift
//  Bind
//
//  Created by wangteng on 2023/3/4.
//

import Foundation

public extension Bind where T: UIImage {
    
    func compressImage(maxKb: Int = 128) -> Data? {
        
        autoreleasepool {
            let maxLength = maxKb*1024
            var compressionQuality: CGFloat = 1
            var compressData = self.base.jpegData(compressionQuality: compressionQuality)
            if let data = compressData, data.count < maxLength {
                return data
            }
            var max: CGFloat = 1
            var min: CGFloat = 0
            for _ in 0 ... 6 {
                compressionQuality = (max + min) * 0.5
                if let data: Data = self.base.jpegData(compressionQuality: compressionQuality) {
                    compressData = data
                    // 缩小压缩比例
                    if Float(data.count) < Float(maxLength) * 0.9 {
                        min = compressionQuality
                    }
                    // 扩大压缩比例
                    else if data.count > maxLength {
                        max = compressionQuality
                    } else {
                        break
                    }
                }
            }
            return compressData
        }
    }
    
    /// 修复图片旋转
    /// - Returns: UIImage
    func fixOrientation() -> UIImage {
        if self.base.imageOrientation == .up{
            return self.base
        }
        var transform = CGAffineTransform.identity

        switch self.base.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x:self.base.size.width, y:self.base.size.height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x:self.base.size.width, y:0)
            transform = transform.rotated(by: .pi/2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x:0, y:self.base.size.height)
            transform = transform.rotated(by: -.pi/2)
        default:
            break
        }
        switch self.base.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x:self.base.size.width, y:0)
            transform = transform.scaledBy(x:-1, y:1)
            break

        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x:self.base.size.height, y:0);
            transform = transform.scaledBy(x:-1, y:1)
            break
        default:
            break
        }
        let ctx = CGContext(data:nil, width:Int(self.base.size.width), height:Int(self.base.size.height), bitsPerComponent:self.base.cgImage!.bitsPerComponent, bytesPerRow:0, space:self.base.cgImage!.colorSpace!, bitmapInfo:self.base.cgImage!.bitmapInfo.rawValue)
        ctx?.concatenate(transform)

        switch self.base.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(self.base.cgImage!, in:CGRect(x:CGFloat(0), y:CGFloat(0), width:CGFloat(base.size.height), height:CGFloat(base.size.width)))
        default:
            ctx?.draw(self.base.cgImage!, in:CGRect(x:CGFloat(0), y:CGFloat(0), width:CGFloat(base.size.width), height:CGFloat(base.size.height)))
        }
        let cgimg:CGImage = (ctx?.makeImage())!
        let img = UIImage(cgImage: cgimg)
        return img
    }
    
    func gaussianBlur(_ radius: CGFloat = 10) -> UIImage? {
        guard let ciImage = CIImage(image: self.base) else { return nil }
        // 创建高斯模糊滤镜类
        guard let blurFilter = CIFilter(name: "CIGaussianBlur") else { return nil }
        
        // key 可以在控制台打印 po blurFilter.inputKeys
        // 设置图片
        blurFilter.setValue(ciImage, forKey: "inputImage")
        // 设置模糊值
        blurFilter.setValue(radius, forKey: "inputRadius")
        // 从滤镜中 取出图片
        guard let outputImage = blurFilter.outputImage else { return nil }

        // 创建上下文
        let context = CIContext(options: nil)
        // 根据滤镜中的图片 创建CGImage
        guard let cgImage = context.createCGImage(outputImage, from: ciImage.extent) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
}

/// QRCode
public extension Bind where T: UIImage {
    
    /// 生成二维码
    static func generateQRCode(_ content: String, size: CGFloat,
                               avatar: UIImage?,
                               foregroundColor: UIColor = .black,
                               backgroundColor: UIColor = .white) -> UIImage? {
        guard let generateFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        // 设置二维码内容
        generateFilter.setValue(content.data(using: .utf8), forKey: "inputMessage")
        // 设置二维码的级别(纠错率) L: 7% M(默认): 15% Q: 25% H: 30%
        generateFilter.setValue("H", forKeyPath: "inputCorrectionLevel")
        
        // 直接返回 UIImage(ciImage: outputImage) 会是模糊的二维码
        guard let outputImage = generateFilter.outputImage else { return nil }

        // 转化为 清晰的图像
        guard let clearImage = generateNonInterpolatedQRCode(outputImage, size: size) else { return nil }
        
        // 设置二维码 颜色
        guard let colorsImage = setQRCodeColors(clearImage, foregroundColor: foregroundColor, backgroundColor: backgroundColor) else { return nil}
        
        // 返回插入头像的二维码
        return insertAvatarToQRCode(avatar, qrCodeImage: colorsImage)
        
    }

    /// 生成清晰的 二维码
    private static func generateNonInterpolatedQRCode(_ ciImage: CIImage, size: CGFloat) -> UIImage? {
        // 调整图片大小及位置（小数跳转为整数）位置值向下调整，大小只向上调整
        let extent = ciImage.extent.integral
        
        // 获取图片大小
        let scale = min(size / extent.width, size / extent.height)
        let outputImageWidth = extent.width * scale
        let outputImageHeight = extent.height * scale
        
        // 创建依赖于设备的灰度颜色通道
        let space = CGColorSpaceCreateDeviceGray()
        
        // 创建图形上下文
        let bitmapContext = CGContext(data: nil, width: Int(outputImageWidth), height: Int(outputImageHeight), bitsPerComponent: 8, bytesPerRow: 0, space: space, bitmapInfo: 0)
        
        // 设置缩放
        bitmapContext?.scaleBy(x: scale, y: scale)
        // 设置上下文渲染等级
        bitmapContext?.interpolationQuality = .none
        
        // 上下文
        let context = CIContext(options: nil)
        // 创建 cgImage
        guard let cgImage = context.createCGImage(ciImage, from: extent) else { return nil }
            
        // 绘图
        bitmapContext?.draw(cgImage, in: extent)
        
        // 从图形上下文中创建图片
        guard let scaledImage = bitmapContext?.makeImage() else { return nil }
        
        // 返回UIImage
        return UIImage(cgImage: scaledImage)
        
    }
    
    /// 设置二维码前景色 和背景色
    private static func setQRCodeColors(_ image: UIImage, foregroundColor: UIColor, backgroundColor: UIColor) -> UIImage? {

        guard let colorFilter = CIFilter(name: "CIFalseColor") else { return nil }
        let ciImage = CIImage(image: image)
        
        // 设置图片
        colorFilter.setValue(ciImage, forKey: "inputImage")
        // 设置前景色
        colorFilter.setValue(CIColor(color: foregroundColor), forKey: "inputColor0")
        // 设置背景色
        colorFilter.setValue(CIColor(color: backgroundColor), forKey: "inputColor1")
        
        // 输出图片
        guard let outputImage = colorFilter.outputImage else { return nil }
        
        return UIImage(ciImage: outputImage)
    }

    /// 往 二维码中 插入头像
    private static func insertAvatarToQRCode(_ avatar: UIImage?, qrCodeImage: UIImage) -> UIImage? {
        guard let avatarSize = avatar?.size else { return qrCodeImage }
        let qrCodeSize = qrCodeImage.size
        // 开启上下文
        UIGraphicsBeginImageContext(qrCodeSize)
        
        // 设置头像的最大值
        var maxAvatarSize = min(avatarSize.width, avatarSize.height)
        maxAvatarSize = min(qrCodeSize.width / 3, maxAvatarSize)
        
        // 绘制二维码图片
        qrCodeImage.draw(in: CGRect(origin: .zero, size: qrCodeSize))
        // 绘制头像
        avatar?.draw(in: CGRect(x: (qrCodeSize.width - maxAvatarSize) / 2, y: (qrCodeSize.height - maxAvatarSize) / 2, width: maxAvatarSize, height: maxAvatarSize))
        // 获取图片
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭上下文
        UIGraphicsEndImageContext()
        return outputImage
    }
}

public extension Bind where T: UIImage {
    
    /// 生成条形码
    static func generateBarcode(_ content: String, size: CGSize) -> UIImage? {
        guard let barcodeFilter = CIFilter(name: "CICode128BarcodeGenerator") else { return nil }
        // 条形码内容
        barcodeFilter.setValue(content.data(using: .utf8), forKey: "inputMessage")
        // 左右间距
        barcodeFilter.setValue(0, forKey: "inputQuietSpace")
        // 高度 -> "inputBarcodeHeight"
        
        guard let outputImage = barcodeFilter.outputImage else { return nil }
        
        // 调整图片大小及位置（小数跳转为整数）位置值向下调整，大小只向上调整
        let extent = outputImage.extent.integral
        
        // 条形码放大 处理模糊
        let scaleX = size.width / extent.width
        let scaleY = size.height / extent.height
        let clearImage = UIImage(ciImage: outputImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY)))
        
        return clearImage
    }
    
    /// 往 条形码中插入 文本
    static func insertTextToBarcode(_ text: String?, attributes: [NSAttributedString.Key: Any]?, height: CGFloat, barcodeImage: UIImage) -> UIImage? {
        guard let text = text else { return barcodeImage }
        let barcodeSize = barcodeImage.size
        
        // 开启上下文
        UIGraphicsBeginImageContext(CGSize(width: barcodeSize.width, height: barcodeSize.height + 20))
        
        // 绘制条形码图片
        barcodeImage.draw(in: CGRect(origin: .zero, size: barcodeSize))
        
        // 文本样式
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        let defaultAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.black,
            .kern: 2,
            .paragraphStyle: style
        ]
        let attributes = attributes ?? defaultAttributes
        
        // 绘制文本
        (text as NSString).draw(in: CGRect(x: 0, y: barcodeSize.height, width: barcodeSize.width, height: height), withAttributes: attributes)
        // 获取图片
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭上下文
        UIGraphicsEndImageContext()
        return outputImage
    }
}
