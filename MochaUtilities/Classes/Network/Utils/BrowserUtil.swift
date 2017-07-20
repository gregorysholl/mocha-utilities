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
        guard let url = nullableUrl else {
            return
        }
        
        guard let nsurl = URL(string: url) else {
            return
        }
        
        UIApplication.shared.openURL(nsurl)
    }
}
