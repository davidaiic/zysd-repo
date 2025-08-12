//
//  Assets.swift
//  MotorFansKit
//
//  Created by wangteng on 2021/7/13.
//

import Foundation

public class Assets {
    
    public static func getBundle() -> Bundle {
        var bundle = Bundle(for: Assets.self)
        if let resourcePath = bundle.path(forResource: "Assets", ofType: "bundle") {
            if let resourcesBundle = Bundle(path: resourcePath) {
                bundle = resourcesBundle
            }
        }
        return bundle
    }
    
    public static func imageBy(name: String, inDirectory: String) -> UIImage? {
        var resource = name
        switch UIScreen.main.scale {
        case ...2:
            resource += "@2x"
        case 3...:
            resource += "@3x"
        default:
            break
        }
        guard let path = Assets.getBundle()
                .path(forResource: resource, ofType: "png", inDirectory: inDirectory) else {
            return nil
        }
        return UIImage(contentsOfFile: path)
    }
}
