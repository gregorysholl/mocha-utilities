//
//  KeyboardUtils.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 05/06/17.
//
//

import UIKit

public class KeyboardUtils {
    
    //MARK: - Show
    
    static public func show(at view: UIKeyInput?) {
        guard let view = view as? UIView else {
            return
        }
        
        let selector = #selector(view.becomeFirstResponder)
        
        guard view.responds(to: selector) else {
            return
        }
        
        view.perform(selector)
    }
    
    static public func hide(_ view: UIView?) {
        guard let view = view else {
            return
        }
        
        view.endEditing(true)
    }
    
    //MARK: - Sizes
    
    static public func getSize(from notification: Notification) -> CGSize {
        guard let userInfo = notification.userInfo else {
            return CGSize.zero
        }
        
        guard let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size else {
            return CGSize.zero
        }
        
        return keyboardSize
    }
    
    static public func getWidth(from notification: Notification) -> CGFloat {
        let size = getSize(from: notification)
        return size.width
    }
    
    static public func getHeight(from notification: Notification) -> CGFloat {
        let size = getSize(from: notification)
        return size.height
    }
}
