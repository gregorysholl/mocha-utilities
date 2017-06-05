//
//  OrientationUtils.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 05/06/17.
//
//

import UIKit

public class OrientationUtils {
    
    //MARK: - Get
    
    static public func get() -> UIInterfaceOrientation {
        return UIApplication.shared.statusBarOrientation
    }
    
    //MARK: - Validation
    
    static public func isPortrait() -> Bool {
        let orientation = get()
        return orientation == .portrait
    }
    
    static public func isUpsideDown() -> Bool {
        let orientation = get()
        return orientation == .portraitUpsideDown
    }
    
    static public func isLandscape() -> Bool {
        let orientation = get()
        return orientation == .landscapeLeft || orientation == .landscapeRight
    }
}
