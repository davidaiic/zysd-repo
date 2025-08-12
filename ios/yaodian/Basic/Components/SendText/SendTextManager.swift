//
//  SendTextManager.swift
//  Basic
//
//  Created by wangteng on 2023/3/17.
//

import Foundation

class SendTextManager {
    
    static let shared = SendTextManager()
    
    private lazy var blur: UIView = {
        let blur = UIView()
        blur.backgroundColor = UIColor(0x000000, alpha: 0.4)
        return blur
    }()
    
    lazy var sendTextView: SendTextView = {
        let sendTextView = SendTextView()
        sendTextView.backgroundColor = .white
        sendTextView.frame = .init(x: 0, y: UIScreen.bind.height, width: UIScreen.bind.width, height: sendTextView.height)
        return sendTextView
    }()
    
    init() {
        addKeyboardObservers()
    }
    
    deinit {
        clear()
        debugPrint("\(self) dealloc")
    }
    
    func show() {
        guard let keyWindow = UIWindow.currentWindow else {
            return
        }
        
        self.blur.alpha = 0
        blur.bind.onTap { [weak self] _ in
            guard let self = self else { return }
            self.sendTextView.textView.resignFirstResponder()
        }
        blur.frame = keyWindow.bounds
        keyWindow.addSubview(blur)
        
        keyWindow.addSubview(sendTextView)
        sendTextView.textView.becomeFirstResponder()
        
        sendTextView.imagesView.addImageHandler = { [weak self] in
            guard let self = self else { return }
            self._hide { [weak self] in
                guard let self = self else { return }
                self.pickPhoto()
            }
        }
        
        sendTextView.privacyBt.bind.addTargetEvent { [weak self] _ in
            guard let self = self else { return }
            self._hide { [weak self] in
                guard let self = self else { return }
                let webView = BaseWebViewController(privacyType: .criterion)
                webView.backBarButtonItemBackHandler = { [weak self] in
                    guard let self = self else { return }
                    self._show()
                }
                webView.bind.push()
            }
        }
    }
    
    func _show() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.sendTextView.textView.becomeFirstResponder()
        }
    }
    
    func _hide(handler: @escaping (() -> Void)) {
        self.sendTextView.textView.resignFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            handler()
        }
    }
    
    func resetting() {
        self.sendTextView.textView.text = ""
        self.sendTextView.configuration.removeAllImages()
        self.sendTextView.imagesView.reloadData()
        self._hide { }
    }
}

extension SendTextManager {
    
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func clear() {
        self.blur.removeFromSuperview()
        self.sendTextView.removeFromSuperview()
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardShow(_ notification: Notification) {
        let kbInfo = notification.userInfo
        let kbRect = (kbInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let options = UIView.AnimationOptions(rawValue: UInt(7 << 16))
       
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: options,
                       animations: { [weak self] in
            guard let self = self else { return }
            let y = kbRect.origin.y-self.sendTextView.height
            self.sendTextView.bind.frame(.top(y))
            self.blur.alpha = 1
        }, completion: { (_) in
           
        })
    }

    @objc private func hideKeyboard(_ notifacation: Notification) {
        let options = UIView.AnimationOptions(rawValue: UInt(7 << 16))
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: options,
                       animations: { [weak self] in
            guard let self = self else { return }
            self.blur.alpha = 0
            self.sendTextView.bind.frame(.top(UIScreen.bind.height))
        }, completion: { (_) in
            
        })
    }
}

extension SendTextManager {
    
    func pickPhoto() {
        guard let sender = UIWindow.bind.topViewController() else {
            return
        }
        let config = PhotoConfiguration.default()
        config.allowSelectImage = true
        config.allowSelectVideo = false
        config.maxSelectCount = sendTextView.configuration.maxImages-sendTextView.configuration.imageCount
        let photoPicker = PhotoManager()
        photoPicker.selectImageBlock = { [weak self] (images, _) in
            guard let self = self else { return }
            let sequence = images.map { image -> AppendImageModel in
                let imageModel = AppendImageModel.init()
                imageModel.image = image.image
                imageModel.opType = .image
                imageModel.asseet = image.asset
                return imageModel
            }
            self.sendTextView.configuration.add(images: sequence)
            self.sendTextView.imagesView.collectionView.reloadData()
            self._show()
        }
        photoPicker.cancelBlock = {
            self._show()
        }
        photoPicker.showPhotoLibrary(sender: sender)
    }
}
