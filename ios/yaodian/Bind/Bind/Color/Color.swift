//
//  Color.swift
//  Drug
//
//  Created by wangteng on 2023/2/10.
//

import UIKit

public extension UIColor {
    
    convenience init(_ hex: String, alpha: CGFloat = 1) {
        var hexString = hex
        if hex.hasPrefix("#") {
            hexString = hex.replacingOccurrences(of: "#", with: "")
        }
        let scanner = Scanner(string: hexString)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        self.init( red: CGFloat(r) / 0xff,
                   green: CGFloat(g) / 0xff,
                   blue: CGFloat(b) / 0xff,
                   alpha: alpha)
    }
    
    convenience init(_ rgbValue: UInt, alpha: CGFloat = 1) {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8)/255.0
        let blue = CGFloat(rgbValue & 0x000FF)/255.0
        self.init(red: red,
                  green: green,
                  blue: blue,
                  alpha: alpha)
    }
}


public extension String {
    
    var color: UIColor {
        UIColor.init(self)
    }
}
