//
//  NSObject+Core.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 20/07/17.
//
//

import UIKit

// MARK: - Threads

public extension NSObject {
    
    public func sleep(for time: TimeInterval) {
        Thread.sleep(forTimeInterval: time)
    }
    
    public func uiThread(_ block: () -> Void) {
        DispatchQueue.main.sync {
            block()
        }
    }
    
    public func backgroundThread(_ block: @escaping (() -> Void)) {
        DispatchQueue.global().async {
            block()
        }
    }
}
