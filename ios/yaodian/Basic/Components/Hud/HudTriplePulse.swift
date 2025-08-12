//
//  BallClipRotate.swift
//  Basic
//
//  Created by wangteng on 2023/4/2.
//

import Foundation

class BallScaleMultiple: UIView {
    
    var animationLayer: CALayer!
    
    static let DefaultFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: 156.0, height: 156.0))
    
    let animationLayerSize: CGSize = .init(width: 80, height: 80)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: BallScaleMultiple.DefaultFrame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        animationLayer = CALayer()
        animationLayer.frame = CGRect(x: 0, y: 0, width: animationLayerSize.width, height: animationLayerSize.height)
        DGActivityIndicatorBallScaleMultipleAnimation().setupAnimation(in: animationLayer, with: animationLayerSize, tintColor: .white)
        layer.addSublayer(animationLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.animationLayer.frame = CGRect(x: (self.bounds.width-animationLayerSize.width)*0.5,
                                           y: (self.bounds.height-animationLayerSize.height)*0.5,
                                           width: animationLayerSize.width, height: animationLayerSize.height)
    }

}

extension BallScaleMultiple: HudAnimating {
    
    func stopAnimation() {
        self.animationLayer.speed = 0
    }
    
    func startAnimation() {
        self.animationLayer.speed = 1
    }
}
