//
//  HudSpinner.swift
//  Basic
//
//  Created by wangteng on 2023/3/29.
//

import Foundation

class HudSpinner: UIView {
    
    var spinner: DRPLoadingSpinner!
    
    static let defaultHudSpinnerFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: 156.0, height: 156.0))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: HudSpinner.defaultHudSpinnerFrame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        
        let spinnerSize: CGSize = .init(width: 30, height: 30)
        self.spinner = DRPLoadingSpinner.init(frame: .init(origin: .init(x: (bounds.size.width-spinnerSize.width)*0.5, y: (bounds.size.height-spinnerSize.height)*0.5), size: spinnerSize))
        self.spinner.rotationCycleDuration = 0.5
        self.spinner.drawCycleDuration = 0.2
        self.spinner.lineWidth = 2
        self.spinner.colorSequence = [UIColor.init(red: 94.0/255.0, green: 204.0/255.0, blue: 178.0/255.0, alpha: 1)]
        self.spinner.maximumArcLength = .pi / 3
        self.spinner.minimumArcLength = .pi / 3
        self.spinner.backgroundRailColor = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1)
        self.spinner.rotationDirection = .clockwise
        addSubview(self.spinner)
    }
    
}

extension HudSpinner: HudAnimating {
    
    func stopAnimation() {
        self.spinner.stopAnimating()
    }
    
    func startAnimation() {
        self.spinner.startAnimating()
    }
}
