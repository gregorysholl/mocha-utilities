//
//  DeviceUtils.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 05/06/17.
//
//

import UIKit

import AudioToolbox

public class DeviceUtil {
    
    //MARK: - Helpers
    
    static private func digitsOnly(of phoneNumber: String) -> String {
        let numberArray = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted)
        let number = numberArray.joined(separator: "")
        return number
    }
    
    //MARK: - Actions
    
    static public func call(_ phoneNumber: String) {
        let number = digitsOnly(of: phoneNumber)
        if let url = URL(string: "tel://\(number)") {
            UIApplication.shared.openURL(url)
        }
    }
    
    static public func sms(_ phoneNumber: String) {
        let number = digitsOnly(of: phoneNumber)
        guard let url = URL(string: "sms://\(number)") else {
            return
        }
        
        UIApplication.shared.openURL(url)
    }
    
    static public func openSettings() {
        guard let url = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }
        
        UIApplication.shared.openURL(url)
    }
    
    static public func vibrate() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    //MARK: - Information
    
    static public var uuid: String {
        return NSUUID().uuidString
    }
    
    static public var platformCode: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let platform = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return platform
    }
    
    static public var version: Float {
        return NumberUtil.toFloat(UIDevice.current.systemVersion)
    }
    
    static public var name: String {
        var name = "\(platformCode)_\(version)_\(uuid)"
        name = name.replacingOccurrences(of: ",", with: ".")
        name = name.replacingOccurrences(of: "-", with: "_")
        return name
    }
    
    //MARK: - Clipboard
    
    static public func copyToClipboard(_ string: String?) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = string
    }
    
    //MARK: - Sizes
    
    static public var screenSize: CGSize {
        return UIScreen.main.bounds.size
    }
    
    static public var screenWidth: CGFloat {
        return screenSize.width
    }
    
    static public var screenHeight: CGFloat {
        return screenSize.height
    }
    
    //MARK: - Scales
    
    static public var screenScale: CGFloat {
        return UIScreen.main.scale
    }
    
    static public func isNormalDisplay() -> Bool {
        if version < 4.0 {
            return false
        }
        return screenScale == 1.0
    }
    
    static public func isRetinaDisplay() -> Bool {
        if version < 4.0 {
            return false
        }
        return screenScale == 2.0
    }
    
    static public func isHdDisplay() -> Bool {
        if version < 4.0 {
            return false
        }
        return screenScale == 3.0
    }
    
    //MARK: - Model
    
    static public var model: String  {
        return UIDevice.current.model
    }
    
    static public func isSimulator() -> Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
    static public func isPhone() -> Bool {
        let idiom = UIDevice.current.userInterfaceIdiom
        return idiom == .phone
    }
    
    static public func isPad() -> Bool {
        let idiom = UIDevice.current.userInterfaceIdiom
        return idiom == .pad
    }
    
    static public func isIphone4() -> Bool {
        if isPad() {
            return false
        }
        return screenHeight == 480.0
    }
    
    static public func isIphone5() -> Bool {
        if isPad() {
            return false
        }
        return screenHeight == 568.0
    }
    
    static public func isIphone6() -> Bool {
        if isPad() {
            return false
        }
        return screenHeight == 667.0
    }
    
    static public func isIphone6Plus() -> Bool {
        if isPad() {
            return false
        }
        return screenHeight == 736.0
    }
}
