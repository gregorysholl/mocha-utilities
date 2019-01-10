//
//  AppUtils.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 05/06/17.
//
//

import UIKit

public class AppUtil {
    
    // MARK: - Information
    
    public static func object(forInfoDictionaryKey key: String) -> Any? {
        return Bundle.main.object(forInfoDictionaryKey: key)
    }
    
    public static var name: String {
        guard let displayName = object(forInfoDictionaryKey: "CFBundleDisplayName") as? String else {
            return ""
        }
        return displayName
    }
    
    public static var version: String {
        guard let shortVersion = object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            return ""
        }
        return shortVersion
    }
    
    public static var bundleNumber: String {
        guard let bundleVersion = object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
            return ""
        }
        return bundleVersion
    }
    
    public static var viewControllerBasedStatusBarAppearance: Bool {
        guard let vcBased = object(forInfoDictionaryKey: "UIViewControllerBasedStatusBarAppearance") as? Bool else {
            MochaLogger.log("The attribute 'UIViewControllerBasedStatusBarAppearance' was not found in project's Info.plist.")
            return false
        }
        return vcBased
    }
    
    // MARK: - App Store
    
    public static func openAppStore(appLink: String) {
        let appStorePrefix = "itms://itunes.apple.com/br/app/"
        
        var urlString = appLink
        urlString = urlString.replacingOccurrences(of: appStorePrefix, with: "")
        
        if let url = URL(string: "\(appStorePrefix)\(urlString)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: - State
    
    public static var state: UIApplication.State {
        return UIApplication.shared.applicationState
    }
    
    public static var active: Bool {
        return state == .active
    }
    
    public static var inBackground: Bool {
        return state == .background
    }
}
