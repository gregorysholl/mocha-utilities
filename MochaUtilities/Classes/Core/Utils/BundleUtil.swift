//
//  BundleUtil.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 19/07/17.
//
//

import UIKit

public class BundleUtil {
    
    fileprivate var bundle: Bundle!
    
    static public var main: BundleUtil {
        return BundleUtil(bundle: .main)
    }
    
    static public func custom(_ bundle: Bundle) -> BundleUtil {
        return BundleUtil(bundle: bundle)
    }
    
    internal init(bundle: Bundle) {
        self.bundle = bundle
    }
}

