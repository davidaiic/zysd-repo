//
//  FDScanningController.swift
//  Scanning
//
import UIKit
import AVFoundation
import Bind

public protocol ScanningControllerProtocal {
    func scanning(message info: String?)
}

public class ScanningController: UIViewController {
    
    var mode: ScanningView.Mode = .scan
    
    private var scanner: Scanner?
    private var scannerLayer: CAGradientLayer?
    private var scaningView: ScanningView?
    
    public var delegate: ScanningControllerProtocal?
    
    var supportType: CodeType = .bar
    
    /// 查真伪
    var isQueryAuthenticity: Bool = false
    
    var scanBridge: Bool = false
    
    public convenience init(type: CodeType) {
        self.init()
        self.supportType = type
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.scanner = Scanner()
        self.scanner?.delegate = self
        self.navigation.bar.backgroundColor = .clear
        navigation.bar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 17, weight: .medium)
        ]
        self.buildUserInterface()
        
        let hanler = { [weak self] authorized in
            guard let self = self else { return }
            if authorized {
                self.setupDevice()
                self.view.bringSubviewToFront(self.scaningView!)
            } else {
                ScanAuthorzation.popCamera()
            }
        }
        Authorzation.camera(completionHandler: hanler)
    }
    
    private func setupDevice() {
        self.scanner?.setupDevice(with: self.view, support: self.supportType)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.scanner?.startRunning()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.scanner?.stopRunning()
    }
    
    @objc
    func closPage() {
        if let vcCount = self.navigationController?.viewControllers.count , vcCount <= 1  {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    deinit {
        debugPrint("deinit--\(self)")
    }
}

extension ScanningController: ScannerDelegate {
    
    private func scanCode(_ message: String) {
        
        Hud.show(.custom(contentView: BallScaleMultiple()))
        ScannerApiManager.scanCode(message) { scanCodeResponseModel in
            Hud.hide()
            guard let scanCodeResponseModel = scanCodeResponseModel else {
                self.scanner?.startRunning()
                return
            }
            if scanCodeResponseModel.result == 0 {
                BasicPopManager()
                    .bind(.title("该条形码未查询到结果"))
                    .bind(.message("请对准商品正面拍照"))
                    .action(titles: ["拍照","取消"], handler: { [weak self] action in
                        guard let self = self else { return }
                        action.handler = { [weak self] selectedIndex -> Bool in
                            guard let self = self else { return true }
                            if selectedIndex == 0 {
                                self.scaningView?.mode = .capture
                            }
                            self.scanner?.startRunning()
                            return true
                        }
                    })
                    .pop()
            } else {
                BasicPopManager()
                    .bind(.title("请确认是否为该商品"))
                    .bind(.message("您查真伪的商品是\(scanCodeResponseModel.goodsName)", { text in
                        text.attributedText.bind.hightLight(scanCodeResponseModel.goodsName,
                                                            font: UIFont.systemFont(ofSize: 14, weight: .medium),
                                                            color: .barTintColor)
                    }))
                    .contentMaxWidth(280)
                    .action(titles: ["否,拍照查验", "是"], handler: { [weak self] action in
                        guard let self = self else { return }
                        action.handler = { [weak self] selectedIndex -> Bool in
                            guard let self = self else { return true }
                            if selectedIndex == 0 {
                                self.scaningView?.mode = .capture
                                self.scanner?.startRunning()
                            } else {
                                /// 无风险
                                if scanCodeResponseModel.risk == 0 {
                                    /// 查真伪
                                    if self.isQueryAuthenticity {
                                        BaseWebViewController.init(webURL: scanCodeResponseModel.webURL, navigationTitle: scanCodeResponseModel.serverName).bind.push()
                                    } else {
                                        LoginManager.shared.loginHandler {
                                            ScanningSafeController(goodsId: scanCodeResponseModel.goodsId).bind.push()
                                        }
                                    }
                                }
                                /// 有风险
                                else {
                                    let smRiskConfiguration = AppWebPathConfiguration.shared.webPath(.smRisk)
                                    let webURL = smRiskConfiguration.webURL+"&goodsId="+scanCodeResponseModel.goodsId
                                    BaseWebViewController.init(webURL: webURL, navigationTitle: smRiskConfiguration.navigationTitle).bind.push()
                                }
                            }
                            return true
                        }
                        action.configureHandler = { bt in
                            bt.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
                        }
                    })
                    .pop()
            }
        }
    }
    
    public func scanResult(_ result: ScannerResult) {
        switch result {
        /// 扫描结果
        case .scan(let message):
            if let delegate = self.delegate {
                delegate.scanning(message: message)
                self.closPage()
            } else {
                self.scanCode(message)
            }
           
        /// 拍照
        case .capture(let image):
            let fixedImage = image.bind.fixOrientation()
            capture(fixedImage)
        /// 从相册中读取
        case .detector(let message):
            if let delegate = self.delegate {
                delegate.scanning(message: message)
                self.closPage()
            } else {
                self.scanCode(message)
            }
            
        /// 失败
        case .failure(let code):
            if code != .noPermission {
                BasicPopManager()
                    .bind(.title(code.popString))
                    .action(titles: ["重新识别"], handler: { action in
                        action.handler = { _ -> Bool in
                            self.scanner?.startRunning()
                            return true
                        }
                    })
                    .pop()
            }
        }
    }
    
    /// 解析相册中的图片
    func detectorFromPhoto(_ image: UIImage) {
        guard let scaningView = self.scaningView else {
            return
        }
        /// 扫描模式
        if scaningView.mode == .scan,
            let ciImage = CIImage(image: image),
            let scanner = self.scanner  {
            scanner.read(with: ciImage)
        }
        /// 拍照模式
        else {
            capture(image)
        }
    }
    /// 处理拍照模式下的图片
    func capture(_ image: UIImage) {
        let scanPhotoView = ScanPhotoView(frame: .init(origin: .zero, size: UIScreen.bind.size))
        scanPhotoView.photo.image = image
        
        let popup = Popup(contentView: scanPhotoView)
        popup.show()
        Hud.show(.custom(contentView: BallScaleMultiple()))
        Hud.allowsInteraction = true
        scanPhotoView.closeButton.bind.addTargetEvent { [weak self] _ in
            guard let self = self else { return }
            popup.dismiss()
            Hud.allowsInteraction = false
            self.scanner?.startRunning()
            Hud.hide()
        }
        
        let data = image.bind.compressImage(maxKb: 1024)
        ScannerApiManager.recognition(data) { res  in
            Hud.hide()
            Hud.allowsInteraction = false
            popup.dismiss()
            if let res = res {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    ScanningResultController(recognition: res).bind.push()
                }
            }
        }
    }
    
    private func openPhotoLibrary() {
        let config = PhotoConfiguration.default()
        config.allowSelectImage = true
        config.allowSelectVideo = false
        config.maxSelectCount = 1
        let photoPicker = PhotoManager()
        photoPicker.selectImageBlock = { [weak self] (images, _) in
            guard let self = self, let image = images.first?.image else { return }
            self.detectorFromPhoto(image)
        }
        photoPicker.showPhotoLibrary(sender: self)
    }
}

extension ScanningController {
    
    private func buildUserInterface() {
    
        view.backgroundColor = UIColor(0x000000)
        view.clipsToBounds = true
        
        let left = BaseButton()
            .bind(.image(UIImage(named: "navigation_back_white")))
            .bind(.contentEdgeInsets(.init(top: 10, left: 10, bottom: 10, right: 10)))
        navigation.item.add(left, position: .left) {  [weak self] _ in
            guard let self = self else { return }
            self.closPage()
        }
     
        let scanView = ScanningView.initFromNib()
        scanView.mode = mode
        self.scanner?.handleScanResult = mode == .scan
        scanView.modeDidChaned = { [weak self] mode in
            guard let self = self else { return }
            self.scanner?.handleScanResult = mode == .scan
        }
        
        scanView.takePhotoHandler = { [weak self] in
            guard let self = self else { return }
            self.scanner?.capturePhoto()
        }
        
        scanView.photoButton.bind.addTargetEvent{[weak self] _ in
            guard let self = self else { return }
            Authorzation.photo(completionHandler: { [weak self] authorized in
                guard let self = self else { return }
                if authorized {
                    self.openPhotoLibrary()
                } else {
                    ScanAuthorzation.popPhoto()
                }
            })
        }
        
        scanView.flashButton.bind.addTargetEvent{ [weak self] btn in
            guard let self = self else { return }
            self.handleEvent(btn)
        }
        
        scanView.scanLightBt.bind.addTargetEvent { [weak self] btn in
            guard let self = self else { return }
            self.handleEvent(btn)
        }
        
        /// 隐藏拍照
        scanView.scanBridge = scanBridge
        self.view.addSubview(scanView)
        self.scaningView = scanView
        scanView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        
        
        if supportType == .td {
            scanView.exampleView.isHidden = true
            scanView.scanMode.isHidden = true
        }
    }
    
    func handleEvent(_ button: UIButton) {
        guard let device = self.scanner?.device else {
            return
        }
        if device.hasTorch && device.isTorchAvailable {
            try? device.lockForConfiguration()
            if device.torchMode == .off {
                if button.titleLabel?.text != nil {
                    button.setTitle("轻触关闭", for: .normal)
                }
                button.setImage(UIImage(named: "scaning_flashlight_on"), for: .normal)
            } else {
                if button.titleLabel?.text != nil {
                    button.setTitle("轻触点亮", for: .normal)
                }
                button.setImage(UIImage(named: "scaning_flashlight_off"), for: .normal)
            }
            device.torchMode = device.torchMode == .off ? .on : .off
            device.unlockForConfiguration()
        }
    }
}
