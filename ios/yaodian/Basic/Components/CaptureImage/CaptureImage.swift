//
//  PhotoPicker.swift
//  Basic
//
//  Created by wangteng on 2023/3/18.
//

import Foundation
import Bind

class CaptureImage: NSObject {

    static let shared = CaptureImage()
    
    var picker = UIImagePickerController()
    
    var didSelectedImagePicker: ((UIImage)->())?
    
    func capture(_ allowsEditing: Bool = false) {
        let hanler = { [weak self] authorized in
            guard let self = self else { return }
            if authorized {
                self.addPhotoFromCamera(allowsEditing)
            } else {
                ScanAuthorzation.popCamera()
            }
        }
        Authorzation.camera(completionHandler: hanler)
    }
}

extension CaptureImage: UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        didSelectedImagePicker?(image)
    }
    
    private func addPhotoFromCamera(_ allowsEditing: Bool = false){
        picker.delegate = self
        picker.allowsEditing = allowsEditing
        picker.sourceType = .camera
        UIWindow.bind.topViewController()?.present(self.picker, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
