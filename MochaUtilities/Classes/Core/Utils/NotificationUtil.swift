//
//  NotificationUtils.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 05/06/17.
//
//

import UIKit

// MARK: - Register

public class NotificationUtil {
    
    public static func registerName(_ name: Notification.Name, with selector: Selector, for observer: Any) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: nil)
    }
}

// MARK: - Unregister

public extension NotificationUtil {
    
    public static func unregisterName(_ name: Notification.Name, from observer: Any) {
        NotificationCenter.default.removeObserver(observer, name: name, object: nil)
    }
    
    public static func unregisterAllNotifications(from observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }
}

// MARK: - Post

public extension NotificationUtil {
    
    public static func post(_ name: Notification.Name, with object: Any? = nil) {
        NotificationCenter.default.post(name: name, object: object)
    }
    
    public static func post(_ notification: Notification) {
        NotificationCenter.default.post(notification)
    }
}
