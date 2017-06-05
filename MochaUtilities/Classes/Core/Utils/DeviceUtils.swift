//
//  DeviceUtils.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 05/06/17.
//
//

import UIKit

import AudioToolbox

public class DeviceUtils {
    
    //MARK: - Helpers
    
    static private func getOnlyDigits(of phoneNumber: String) -> String {
        let numberArray = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted)
        let number = numberArray.joined(separator: "")
        return number
    }
    
    //MARK: - Actions
    
    static public func call(_ phoneNumber: String) {
        let number = getOnlyDigits(of: phoneNumber)
        if let url = URL(string: "tel://\(number)") {
            UIApplication.shared.openURL(url)
        }
    }
    
    static public func sms(_ phoneNumber: String) {
        let number = getOnlyDigits(of: phoneNumber)
        if let url = URL(string: "sms://\(number)") {
            UIApplication.shared.openURL(url)
        }
    }
    
    static public func openSettings() {
        if let url = URL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.shared.openURL(url)
        }
    }
    
    static public func vibrate() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    //MARK: - Information
    
    static public func getUUID() -> String {
        let uuid = NSUUID().uuidString
        return uuid
    }
    
    static public func getPlatformCode() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let platform = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return platform
    }
    
    static public func getName() -> String {
        let model = getPlatformCode()
        let version = "\(getVersion())"
        let uniqueIdentifier = getUUID()
        
        var name = "\(model)_\(version)_\(uniqueIdentifier)"
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
    
    static public func getScreenSize() -> CGSize {
        return UIScreen.main.bounds.size
    }
    
    static public func getScreenWidth() -> CGFloat {
        return getScreenSize().width
    }
    
    static public func getScreenHeight() -> CGFloat {
        return getScreenSize().height
    }
    
    //MARK: - Scales
    
    static public func getScreenScale() -> CGFloat {
        return UIScreen.main.scale
    }
    
    static public func isNormalDisplay() -> Bool {
        let version = getVersion()
        if version < 4.0 {
            return false
        }
        
        let scale = getScreenScale()
        return scale == 1.0
    }
    
    static public func isRetinaDisplay() -> Bool {
        let version = getVersion()
        if version < 4.0 {
            return false
        }
        
        let scale = getScreenScale()
        return scale == 2.0
    }
    
    static public func isHdDisplay() -> Bool {
        let version = getVersion()
        if version < 4.0 {
            return false
        }
        
        let scale = getScreenScale()
        return scale == 3.0
    }
    
    //MARK: - Model
    
    static public func getModel() -> String  {
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
        
        let screenHeight = getScreenHeight()
        return screenHeight == 480.0
    }
    
    static public func isIphone5() -> Bool {
        if isPad() {
            return false
        }
        
        let screenHeight = getScreenHeight()
        return screenHeight == 568.0
    }
    
    static public func isIphone6() -> Bool {
        if isPad() {
            return false
        }
        
        let screenHeight = getScreenHeight()
        return screenHeight == 667.0
    }
    
    static public func isIphone6Plus() -> Bool {
        if isPad() {
            return false
        }
        
        let screenHeight = getScreenHeight()
        return screenHeight == 736.0
    }
    
    //MARK: - Version
    
    static public func getVersion() -> Float {
        return NumberUtils.toFloat(UIDevice.current.systemVersion)
    }
}
