//
//  UIViewController+Core.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 21/07/17.
//
//

import UIKit

// MARK: - Alert Controller

public extension UIViewController {
    
    public func alert(title: String? = nil, message: String? = nil, actions: [UIAlertAction] = []) -> UIAlertController {
        let alertController = createAlertController(title: title, message: message, style: .alert, actions: actions)
        present(alertController, animated: true, completion: nil)
        return alertController
    }
    
    public func actionSheet(title: String? = nil, message: String? = nil, actions: [UIAlertAction] = []) -> UIAlertController {
        let alertController = createAlertController(title: title, message: message, style: .actionSheet, actions: actions)
        present(alertController, animated: true, completion: nil)
        return alertController
    }
    
    private func createAlertController(title: String?, message: String?, style: UIAlertControllerStyle, actions: [UIAlertAction]) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        for action in actions {
            alertController.addAction(action)
        }
        
        return alertController
    }
}
