//
//  LoadingImageCell.swift
//  Basic
//
//  Created by wangteng on 2023/3/13.
//

import Foundation
import Lantern
import Kingfisher

/// 加上进度环的Cell
class LoadingImageCell: LanternImageCell {
    
    /// 进度环
    let progressView = LanternProgressView()
    
    override func setup() {
        super.setup()
        addSubview(progressView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        progressView.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
    
    func reloadData(placeholder: UIImage?, urlString: String?) {
        progressView.progress = 0
        let url = urlString.flatMap { URL(string: $0) }
        imageView.kf.setImage(with: url) {  [weak self]  receivedSize, totalSize in
            guard let self = self else { return }
            if totalSize > 0 {
                self.progressView.progress = CGFloat(receivedSize) / CGFloat(totalSize)
            }
        } completionHandler: { [weak self] res in
            guard let self = self else { return }
            switch res {
            case .success:
                self.setupPop()
                break
            case .failure:
                break
            }
            self.progressView.progress = 1
            self.setNeedsLayout()
        }
    }
}

extension LoadingImageCell {
    
    func setupPop() {
        self.longPressedAction = { [weak self] _, _ in
            
            guard let self = self else { return }
            
            guard let image = self.imageView.image else { return }
            
            SheetPop().pop(titles: ["保存到相册"]) { [weak self] selectedIndex in
                guard let self = self else { return }
                switch selectedIndex {
                case 0:
                    UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
                default: break
                }
            }
        }
    }
    
    @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if error != nil{
            Toast.showMsg("保存失败")
        } else {
            Toast.showMsg("保存成功")
        }
    }
}
