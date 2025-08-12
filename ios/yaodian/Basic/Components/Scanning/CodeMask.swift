//
//  CodeMask.swift
//  Basic
//
//  Created by wangteng on 2023/3/5.
//

import UIKit
import AVFoundation

class CodeMask {
    
    var maskWrapper: UIView!
    
    var captureVideoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    func metadataObjects(_ objectes: [AVMetadataObject]) {
        objectes.forEach { metadata in
            let metadataObject = self.captureVideoPreviewLayer.transformedMetadataObject(for: metadata) as? AVMetadataMachineReadableCodeObject
            let view =  UIView(frame: .init(x: 0, y: 0, width: 30, height: 30))
            view.backgroundColor  = .red
            view.center = metadataObject!.centerPoint
            maskWrapper.addSubview(view)
        }
    }
}

extension AVMetadataMachineReadableCodeObject {
    
    var centerPoint: CGPoint {
        var totalX: CGFloat = 0
        var totalY: CGFloat = 0
        corners.forEach { pt in
            totalX += pt.x;
            totalY += pt.y;
        }
        let averX = totalX / CGFloat(corners.count)
        let averY = totalY / CGFloat(corners.count)
        return .init(x: averX, y: averY)
    }
}
