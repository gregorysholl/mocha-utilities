//
//  StatusBarUtils.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 05/06/17.
//
//

import UIKit

// MARK: - Sizes

public class StatusBarUtil {
    
    public static var height: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height
    }
}

// MARK: - Background Color

public extension StatusBarUtil {
    
    public static func setBackgroundColor(_ color: UIColor) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: DeviceUtil.screenWidth, height: 20))
        view.backgroundColor = color
        
        let window = UIApplication.shared.keyWindow
        if let window = window {
            window.rootViewController?.view.addSubview(view)
        }
    }
}
