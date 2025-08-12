//
//  Authorization.swift
//  Drug
//
//  Created by wangteng on 2023/2/10.
//

import Foundation
import Photos
import AVFoundation

public class Authorzation {
    
    public class func photo(completionHandler: @escaping (Bool) -> Void) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            completionHandler(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { authorized in
                DispatchQueue.main.async {
                    completionHandler(authorized == .authorized)
                }
            }
        case .restricted, .denied:
            completionHandler(false)
        case .limited:
            completionHandler(true)
        @unknown default:
            completionHandler(false)
        }
    }
    
    public class func microphone(completionHandler: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .authorized:
            completionHandler(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .audio) { authorized in
                DispatchQueue.main.async {
                    completionHandler(authorized)
                }
            }
        case .restricted, .denied:
            completionHandler(false)
        @unknown default:
            completionHandler(false)
        }
    }
    
    @discardableResult
    public class func camera(completionHandler: @escaping (Bool) -> Void) {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            completionHandler(false)
            return
        }
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completionHandler(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { authorized in
                DispatchQueue.main.async {
                    completionHandler(authorized)
                }
            }
        case .restricted, .denied:
            completionHandler(false)
        @unknown default:
            completionHandler(false)
        }
    }
    
    public class func location() -> Bool {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            return false
        case .restricted:
            return false
        case .denied:
            return false
        case .authorizedAlways:
            return true
        case .authorizedWhenInUse:
            return true
        @unknown default:
            return false
        }
    }
}
