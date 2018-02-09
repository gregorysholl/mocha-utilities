//
//  UIColor+Core.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 18/07/17.
//
//

import UIKit

public extension UIColor {
    
    public convenience init(rgbWithRed red: Int, green: Int, blue: Int, alpha: CGFloat) {
        self.init(red: CGFloat(red) / 255,
                  green: CGFloat(green) / 255,
                  blue: CGFloat(blue) / 255,
                  alpha: alpha)
    }
    
    public convenience init(hex value: Int, alpha: CGFloat){
        self.init(red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(value & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}
