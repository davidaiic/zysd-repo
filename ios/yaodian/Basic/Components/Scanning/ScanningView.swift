//
//  ScanningView.swift
//  Basic
//
//  Created by wangteng on 2023/3/3.
//

import UIKit
import Bind

class ScanningView: UIView, NibLoadable {

    enum Mode {
    /// 拍照
    case capture
    /// 扫码
    case scan
    }
    
    var modeDidChaned: ((Mode)->Void)?
    var mode: Mode = .scan {
        didSet{
            switch mode {
            case .scan:
                scanModeHandler()
            case .capture:
                takeModeHandler()
            }
            modeDidChaned?(mode)
        }
    }
    
    @IBOutlet weak var exampleView: UIView!
    @IBOutlet weak var squareWrapperView: UIView!
    
    @IBOutlet weak var squareView: UIView!
    
    private var scannerLayer: UIImageView?
    
    
    /// 闪光灯
    @IBOutlet weak var flashButton: UIButton!
    
    /// 相册
    @IBOutlet weak var photoButton: UIButton!
    
    /// 扫码模式
    @IBOutlet weak var scanMode: UIButton!
    
    /// 拍照模式
    @IBOutlet weak var takeMode: UIButton!
    
    @IBOutlet weak var takePhoto: UIButton!
    
    lazy var takePhotoTip: UILabel = {
        let tip = UILabel()
        tip.text = "对准商品，点击拍照"
        tip.font = UIFont.systemFont(ofSize: 14)
        tip.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tip.alpha = 0
        return tip
    }()
    
    var sacnningHandler: (()->Void)?
    var takePhotoHandler: (()->Void)?
    
    /// 只能扫瞄
    var scanBridge: Bool = false {
        didSet {
            if scanBridge {
                hideTake()
            }
        }
    }
    
    @IBOutlet weak var scanLightBt: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addHierarchy()
        
        scanMode.bind.addTargetEvent { [weak self] _ in
            guard let self = self, self.mode != .scan else { return }
            self.mode = .scan
        }
        
        scanLightBt.bind.imagePosition(10, .top)
       
        takeMode.bind.addTargetEvent { [weak self] _ in
            guard let self = self, self.mode != .capture else { return }
            self.mode = .capture
        }
        
        takePhoto.bind.addTargetEvent { [weak self] _ in
            guard let self = self else { return }
            self.takePhotoHandler?()
        }
        
        addSubview(takePhotoTip)
        takePhotoTip.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
    }
    
    func scanModeHandler() {
        UIView.animate(withDuration: 0.25) {
            self.squareWrapperView.alpha = 1
            self.scanMode.alpha = 1
            self.takeMode.alpha = 0.3
            self.takePhoto.alpha = 0
            self.takePhotoTip.alpha = 0
            self.flashButton.alpha = 0
        }
        self.sacnningHandler?()
        self.startScanningAnimation()
        
        UIWindow.bind.topViewController()?.navigation.item.title = "扫一扫"
    }
    
    func takeModeHandler() {
        UIView.animate(withDuration: 0.25) {
            self.squareWrapperView.alpha = 0
            self.takePhoto.alpha = 1
            self.scanMode.alpha = 0.3
            self.takeMode.alpha = 1
            self.takePhotoTip.alpha = 1
            self.flashButton.alpha = 1
        } completion: { _ in
           
        }
        self.stopScanningAnimation()
        UIWindow.bind.topViewController()?.navigation.item.title = "拍照"
    }
    
    /// 隐藏拍照
    func hideTake() {
        self.squareWrapperView.alpha = 1
        self.scanMode.alpha = 1
        self.takeMode.alpha = 0
        self.takePhoto.alpha = 0
        self.takePhotoTip.alpha = 0
        self.flashButton.alpha = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addHierarchy()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addHierarchy() {
        
        self.squareWrapperView.alpha = 0
        
        /*
        let scannerLayer: CAGradientLayer = CAGradientLayer()
        scannerLayer.frame = CGRect(x: 0, y: 0, width: 260, height: 1)
        scannerLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor, UIColor.white.cgColor]
        scannerLayer.startPoint = CGPoint(x: 0, y: 0.5)
        scannerLayer.endPoint = CGPoint(x: 1, y: 0.5)
        self.squareView.layer.addSublayer(scannerLayer)
        */
        
        let scannerLayerImage = UIImageView(image: "scan_line".bind.image)
        scannerLayerImage.frame = CGRect(x: 0, y: 0, width: 260, height: 1)
        self.squareView.addSubview(scannerLayerImage)
        self.scannerLayer = scannerLayerImage
    }
}

extension ScanningView {
    
    func startScanningAnimation() {
        guard let _ = self.scannerLayer else { return }
        scannerLayer?.isHidden = false
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        animation.duration = 2.0
        animation.fromValue = self.scannerLayer!.frame.origin.y + 10
        animation.toValue = self.scannerLayer!.frame.origin.y + self.squareView.frame.size.height - 10
        animation.repeatCount = MAXFLOAT
        animation.isRemovedOnCompletion = false
        scannerLayer?.layer.add(animation, forKey: "keyBasicAnimqation")
    }
    
    func stopScanningAnimation() {
        scannerLayer?.layer.removeAnimation(forKey: "keyBasicAnimation")
        scannerLayer?.isHidden = true
    }
}

