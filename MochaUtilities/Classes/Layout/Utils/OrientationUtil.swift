//
//  OrientationUtils.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 05/06/17.
//
//

import UIKit

// MARK: - Get-Only Properties

public class OrientationUtil {
    
    // MARK: Get
    
    public static var orientation: UIInterfaceOrientation {
        return UIApplication.shared.statusBarOrientation
    }
    
    // MARK: Validation
    
    public static var portrait: Bool {
        return orientation == .portrait
    }
    
    public static var upsideDown: Bool {
        return orientation == .portraitUpsideDown
    }
    
    public static var landscape: Bool {
        return orientation == .landscapeLeft || orientation == .landscapeRight
    }
}
