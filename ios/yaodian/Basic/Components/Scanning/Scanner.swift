//
//  Scanning.swift
//  Scanner
//

import Foundation
import UIKit
import AVFoundation
import Vision

public final class Scanner: NSObject {
    
    private var session = AVCaptureSession()
    private var captureVideoPreviewLayer: AVCaptureVideoPreviewLayer!
    public  var device: AVCaptureDevice?
    private var stillImageOutput = AVCapturePhotoOutput()
    private var output = AVCaptureMetadataOutput()
    private var priviewView: UIView?

    public weak var delegate: ScannerDelegate?
    
    private let barCodes: [AVMetadataObject.ObjectType] =  [.itf14, .upce, .code39, .code39Mod43, .code93, .code128, .ean8, .ean13, .interleaved2of5]
    private let tdCodes: [AVMetadataObject.ObjectType] = [.aztec, .dataMatrix, .pdf417, .qr]
    
    public var support: CodeType = .all
    
    public var handleScanResult: Bool = true
    
    /// 设置扫描预览视图 只支持条码和二维码类型 其他不支持 .
    public func setupDevice<T>(with view: T, support: CodeType) where T: UIView {
        self.support = support
        guard authorzation(),
                let device = AVCaptureDevice.default(for: AVMediaType.video) else {
            return
        }
        self.device = device
        self.session.sessionPreset = sessionPreset()
        inputOutput()
        previewLayer(with: view)
        autoFocusing()
        startRunning()
    }
    
    func sessionPreset() -> AVCaptureSession.Preset {
        guard let device = self.device else { return .low }
        if device.supportsSessionPreset(.hd1280x720) {
            return .hd1280x720
        }
        if device.supportsSessionPreset(.iFrame960x540) {
            return .iFrame960x540
        }
        if device.supportsSessionPreset(.vga640x480) {
            return .vga640x480
        }
        if device.supportsSessionPreset(.cif352x288) {
            return .cif352x288
        }
        if device.supportsSessionPreset(.high) {
            return .high
        }
        if device.supportsSessionPreset(.medium) {
            return .medium
        }
        return .low
    }

    private func inputOutput() {
        guard let device = self.device else {
            return
        }
        if let input = try? AVCaptureDeviceInput(device: device),
            session.canAddInput(input) {
            self.session.addInput(input)
        }
        if self.session.canAddOutput(self.stillImageOutput) {
            self.session.addOutput(self.stillImageOutput)
        }
     
        if self.session.canAddOutput(self.output) {
            self.session.addOutput(self.output)
            var metadataObjectTypes: [AVMetadataObject.ObjectType] = []
            switch support {
            case .all:
                metadataObjectTypes.append(contentsOf: barCodes)
                metadataObjectTypes.append(contentsOf: tdCodes)
            case .bar:
                metadataObjectTypes.append(contentsOf: barCodes)
            case .td:
                metadataObjectTypes.append(contentsOf: tdCodes)
            }
            self.output.metadataObjectTypes = metadataObjectTypes
            self.output.setMetadataObjectsDelegate(self, queue: .main)
        }
    }
    
    private func previewLayer(with view: UIView) {
        self.captureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)
        self.captureVideoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        let subview = UIView(frame: view.bounds)
        view.addSubview(subview)
        self.captureVideoPreviewLayer?.frame = subview.layer.bounds
        subview.layer.insertSublayer(captureVideoPreviewLayer, at: 0)
        priviewView = subview
    }
    
    deinit {
        self.session.stopRunning()
        debugPrint("deinit--\(self)")
    }
}

public extension Scanner {
    
    /// 改变镜头倍率
    func controlRate(_ rate: CGFloat) {
        guard let device = self.device else {
            return
        }
        try? device.lockForConfiguration()
        device.videoZoomFactor = rate
        device.unlockForConfiguration()
    }
    
    /// 自动聚焦
    func autoFocusing() {
        guard let device = self.device else {
            return
        }
        try? device.lockForConfiguration()
        if (device.isFocusModeSupported(.continuousAutoFocus)) {
            device.focusPointOfInterest = CGPoint(x:0.5 , y:0.5)
            device.focusMode = .continuousAutoFocus
        }
        device.unlockForConfiguration()
    }
    
    /// 拍照
    func capturePhoto() {
        self.stillImageOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
    
    ///  开始扫描
    func startRunning(handler: (() -> Void)? = nil) {
        guard !self.session.isRunning else {
            return
        }
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self = self else { return }
            self.session.startRunning()
            handler?()
        }
    }
    
    /// 停止扫描
    func stopRunning() {
        guard self.session.isRunning else {
            return
        }
        self.session.stopRunning()
    }
    
    /// 打开手电筒
    func turnOnFlashlight() {
        toggleFlashlight(torchMode: .on)
    }
    
    /// 打开关闭手电筒
    func toggleFlashlight(torchMode: AVCaptureDevice.TorchMode){
        guard let device = self.device,
                device.hasTorch,
                device.isTorchAvailable
        else {
            return
        }
        try? device.lockForConfiguration()
        device.torchMode = torchMode
        device.unlockForConfiguration()
    }
    
    /// 关闭手电筒
    func turnOffFlashlight() {
        toggleFlashlight(torchMode: .off)
    }
}

extension Scanner: AVCapturePhotoCaptureDelegate {
    
    /// 拍照
    public func photoOutput(_ output: AVCapturePhotoOutput,
                            didFinishProcessingPhoto photo: AVCapturePhoto,
                            error: Error?) {
        guard let delegate = delegate else {
            return
        }
        if let imageData = photo.fileDataRepresentation(),
           let image = UIImage(data: imageData) {
            delegate.scanResult(.capture(image: image))
        } else {
            delegate.scanResult(.failure(.capture))
        }
    }
}

extension Scanner: AVCaptureMetadataOutputObjectsDelegate {
    
    public func metadataOutput(_ output: AVCaptureMetadataOutput,
                               didOutput metadataObjects: [AVMetadataObject],
                               from connection: AVCaptureConnection) {
        
        guard handleScanResult else {
            return
        }
        guard let delegate = delegate,
              !metadataObjects.isEmpty,
              let metadata: AVMetadataMachineReadableCodeObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let metadataString = metadata.stringValue
        else {
            return
        }
        stopRunning()
        switch self.support {
        case .all:
            delegate.scanResult(.scan(message: metadataString))
        case .td:
            if tdCodes.contains(metadata.type) {
                delegate.scanResult(.scan(message: metadataString))
            } else {
                delegate.scanResult(.failure(.unSupportTd))
            }
        case .bar:
            if barCodes.contains(metadata.type) {
                delegate.scanResult(.scan(message: metadataString))
            } else {
                delegate.scanResult(.failure(.unSupportBar))
            }
        }
    }
}

extension Scanner {
    
    static func detectBarCode(_ image: UIImage, completion: @escaping (String?)->Void) {
        
        completion("\(image.size.width)")
        
        
    }
    
    /// 从图片中提取二维码
    /// - Parameter image: 图片
    /// - Returns:
    public func read(with image: CIImage) {
        guard let delegate = delegate else {
            return
        }
        
        delegate.scanResult(.failure(.detector))
       
    }
}

extension Scanner {
    
    func authorzation() -> Bool {
        if !isCameraAvailable() {
            delegate?.scanResult(.failure(.noDevice))
            return false
        }
        if !isFrontCameraAvailable() && !isRearCameraAvailable() {
            delegate?.scanResult(.failure(.unAvailable))
            return false
        }
        if !isCameraAuthStatusAvailable() {
            delegate?.scanResult(.failure(.noPermission))
            return false
        }
        return true
    }
    
    private func isCameraAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
    }
    
    private func isFrontCameraAvailable() -> Bool {
        return UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.front)
    }
    
    private func isRearCameraAvailable() -> Bool {
        return UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.rear)
    }
    
    private func isCameraAuthStatusAvailable() -> Bool {
        let status: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if status == AVAuthorizationStatus.authorized || status == AVAuthorizationStatus.notDetermined {
            return true
        }
        return false
    }
}
