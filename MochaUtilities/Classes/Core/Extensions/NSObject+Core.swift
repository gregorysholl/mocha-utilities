//
//  NSObject+Core.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 20/07/17.
//
//

import UIKit

public extension NSObject {
    
    public func uiThread(_ block: () -> Void) {
        DispatchQueue.main.sync(execute: block)
    }
}
