//
//  OrientationUtils.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 05/06/17.
//
//

import UIKit

//MARK: - Get-Only Properties

public class OrientationUtil {
    
    //MARK: Get
    
    static public var orientation: UIInterfaceOrientation {
        return UIApplication.shared.statusBarOrientation
    }
    
    //MARK: Validation
    
    static public var portrait: Bool {
        return orientation == .portrait
    }
    
    static public var upsideDown: Bool {
        return orientation == .portraitUpsideDown
    }
    
    static public var landscape: Bool {
        return orientation == .landscapeLeft || orientation == .landscapeRight
    }
}
