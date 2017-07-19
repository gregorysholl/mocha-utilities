//
//  NSObject+Tasks.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 18/07/17.
//
//

import Foundation

fileprivate var queueAssociationKey: UInt8 = 0

//MARK: - Queue

public extension NSObject {
    
    fileprivate (set) public var queue: OperationQueue? {
        get {
            return objc_getAssociatedObject(self, &queueAssociationKey) as? OperationQueue
        }
        set {
            objc_setAssociatedObject(self, &queueAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public var maxConcurrentOperationCount: Int {
        get {
            MochaLogger.log("You must call the method setupQueue() before obtaining maxConcurrentOperationCount.")
            return queue?.maxConcurrentOperationCount ?? -1
        }
        set {
            MochaLogger.log("You must call the method setupQueue() before changing maxConcurrentOperationCount.")
            queue?.maxConcurrentOperationCount = newValue
        }
    }
    
    public final func setupQueue() {
        queue = OperationQueue()
        queue?.maxConcurrentOperationCount = 3
    }
}

//MARK: - Start

public extension NSObject {
    
    @discardableResult
    public func startTask(_ task: MochaTask, with activityIndicator: UIActivityIndicatorView? = nil) -> BlockOperation? {
        let manager = MochaTaskManager.Builder().setTask(task).setActivityIndicator(activityIndicator).build()
        return startTask(withManager: manager)
    }
    
    @discardableResult
    public func startTask(withManager taskManager: MochaTaskManager) -> BlockOperation? {
        if queue == nil {
            MochaLogger.log("Before using tasks, be sure to call the method setupQueue().")
            return nil
        }
        
        guard let blockOperation = taskManager.start() else {
            return nil
        }
        
        queue?.addOperation(blockOperation)
        return blockOperation
    }
}

//MARK: - Cancel

public extension NSObject {
    
    public func cancelTasks() {
        queue?.cancelAllOperations()
    }
    
    public func cancelTask(withOperation operation: BlockOperation?) {
        if let operation = operation {
            operation.cancel()
        }
    }
}
