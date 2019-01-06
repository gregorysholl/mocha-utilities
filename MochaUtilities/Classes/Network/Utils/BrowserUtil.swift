//
//  BrowserUtils.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 05/06/17.
//
//

import UIKit

public class BrowserUtil {
    
    // MARK: - Open

    static public func openUrl(_ nullableUrl: String?) {
        guard let urlString = nullableUrl else {
            return
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
