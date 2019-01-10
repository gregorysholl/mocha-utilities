//
//  DeviceUtils.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 05/06/17.
//
//

import UIKit

import AudioToolbox

// MARK: - Actions

public class DeviceUtil {
    
    public static func call(_ phoneNumber: String) {
        let number = digitsOnly(of: phoneNumber)
        guard !number.isEmpty, let url = URL(string: "tel://\(number)") else {
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    public static func sms(_ phoneNumber: String) {
        let number = digitsOnly(of: phoneNumber)
        guard let url = URL(string: "sms://\(number)") else {
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    public static func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    public static func vibrate() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    public static func copyToClipboard(_ string: String?) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = string
    }
}

// MARK: - Helpers

private extension DeviceUtil {
    
    private static func digitsOnly(of phoneNumber: String) -> String {
        let numberArray = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted)
        let number = numberArray.joined(separator: "")
        return number
    }
}

// MARK: - Information

public extension DeviceUtil {
    
    public static var uuid: String {
        return NSUUID().uuidString
    }
    
    public static var platformCode: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let platform = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return platform
    }
    
    public static var version: Float {
        return NumberUtil.toFloat(UIDevice.current.systemVersion)
    }
    
    public static var name: String {
        var name = "\(platformCode)_\(version)_\(uuid)"
        name = name.replacingOccurrences(of: ",", with: ".")
        name = name.replacingOccurrences(of: "-", with: "_")
        return name
    }
}

// MARK: - Sizes

public extension DeviceUtil {
    
    public static var screenSize: CGSize {
        return UIScreen.main.bounds.size
    }
    
    public static var screenWidth: CGFloat {
        return screenSize.width
    }
    
    public static var screenHeight: CGFloat {
        return screenSize.height
    }
}

// MARK: - Scales

public extension DeviceUtil {
    
    public static var screenScale: CGFloat {
        return UIScreen.main.scale
    }
    
    public static func isNormalDisplay() -> Bool {
        if version < 4.0 {
            return false
        }
        return screenScale == 1.0
    }
    
    public static func isRetinaDisplay() -> Bool {
        if version < 4.0 {
            return false
        }
        return screenScale == 2.0
    }
    
    public static func isHdDisplay() -> Bool {
        if version < 4.0 {
            return false
        }
        return screenScale == 3.0
    }
}

// MARK: - Model

public extension DeviceUtil {
    
    public static var model: String  {
        return UIDevice.current.model
    }
    
    public static func isSimulator() -> Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
    public static func isPhone() -> Bool {
        let idiom = UIDevice.current.userInterfaceIdiom
        return idiom == .phone
    }
    
    public static func isPad() -> Bool {
        let idiom = UIDevice.current.userInterfaceIdiom
        return idiom == .pad
    }
    
    public static func isIphone4() -> Bool {
        if isPad() {
            return false
        }
        return screenHeight == 480.0
    }
    
    public static func isIphone5() -> Bool {
        if isPad() {
            return false
        }
        return screenHeight == 568.0
    }
    
    public static func isIphone6() -> Bool {
        if isPad() {
            return false
        }
        return screenHeight == 667.0
    }
    
    public static func isIphone6Plus() -> Bool {
        if isPad() {
            return false
        }
        return screenHeight == 736.0
    }
}
