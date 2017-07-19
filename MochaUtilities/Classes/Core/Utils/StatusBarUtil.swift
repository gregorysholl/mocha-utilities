//
//  StatusBarUtils.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 05/06/17.
//
//

import UIKit

//MARK: - Sizes

public class StatusBarUtil {
    
    static public var height: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height
    }
}

//MARK: - Show & Hide

public extension StatusBarUtil {
    
    static public func show() {
        UIApplication.shared.isStatusBarHidden = false
    }
    
    static public func hide() {
        UIApplication.shared.isStatusBarHidden = true
    }
    
    static public var isHidden: Bool {
        return UIApplication.shared.isStatusBarHidden
    }
}

//MARK: - Text Color

public extension StatusBarUtil {
    
    static public func setDefaultTextColor(_ animated: Bool = true) {
        UIApplication.shared.setStatusBarStyle(.default, animated: animated)
    }
    
    static public func setWhiteTextColor(_ animated: Bool = true) {
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: animated)
    }
}

//MARK: - Background Color

public extension StatusBarUtil {
    
    static public func setBackgroundColor(_ color: UIColor) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: DeviceUtil.screenWidth, height: 20))
        view.backgroundColor = color
        
        let window = UIApplication.shared.keyWindow
        if let window = window {
            window.rootViewController?.view.addSubview(view)
        }
    }
}
