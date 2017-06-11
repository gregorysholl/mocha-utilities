//
//  AppUtils.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 05/06/17.
//
//

import UIKit

public class AppUtil {
    
    //MARK: - Information
    
    static public func object(forInfoDictionaryKey key: String) -> Any? {
        return Bundle.main.object(forInfoDictionaryKey: key)
    }
    
    static public var name: String {
        guard let displayName = object(forInfoDictionaryKey: "CFBundleDisplayName") as? String else {
            return ""
        }
        return displayName
    }
    
    static public var version: String {
        guard let shortVersion = object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            return ""
        }
        return shortVersion
    }
    
    static public var bundleNumber: String {
        guard let bundleVersion = object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
            return ""
        }
        return bundleVersion
    }
    
    static public var viewControllerBasedStatusBarAppearance: Bool {
        guard let vcBased = object(forInfoDictionaryKey: "UIViewControllerBasedStatusBarAppearance") as? Bool else {
            MochaLogger.log("The attribute 'UIViewControllerBasedStatusBarAppearance' was not found in project's Info.plist.")
            return false
        }
        return vcBased
    }
    
    //MARK: - App Store
    
    static public func openAppStore(appLink: String) {
        let appStorePrefix = "itms://itunes.apple.com/br/app/"
        
        var url = appLink
        url = url.replacingOccurrences(of: appStorePrefix, with: "")
        
        if let nsurl = URL(string: "\(appStorePrefix)\(url)") {
            UIApplication.shared.openURL(nsurl)
        }
    }
    
    //MARK: - State
    
    static public var state: UIApplicationState {
        return UIApplication.shared.applicationState
    }
    
    static public var active: Bool {
        return state == .active
    }
    
    static public var inBackground: Bool {
        return state == .background
    }
}
