//
//  MochaTask.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 18/07/17.
//
//

import Foundation

public typealias TaskBlock = () -> Void
public typealias ThrowableTaskBlock = () throws -> Void
public typealias ErrorTaskBlock = (_ error: Error) -> Void

public class MochaTask: NSObject {
    
    //MARK: - Variables
    
    var preExecute  : TaskBlock?
    var execute     : ThrowableTaskBlock!
    var updateView  : TaskBlock!
    
    var error       : ErrorTaskBlock?
    
    var operation   : BlockOperation!
    
    //MARK: - Inits
    
    override public init() {
        super.init()
    }
    
    public convenience init(execute: @escaping ThrowableTaskBlock, updateView: @escaping TaskBlock) {
        self.init()
        
        preExecute = nil
        self.execute = execute
        self.updateView = updateView
        error = nil
    }
    
    public convenience init(execute: @escaping ThrowableTaskBlock, updateView: @escaping TaskBlock, onError: @escaping ErrorTaskBlock) {
        self.init()
        
        preExecute = nil
        self.execute = execute
        self.updateView = updateView
        error = onError
    }
    
    public convenience init(preExecute: @escaping TaskBlock, execute: @escaping ThrowableTaskBlock, updateView: @escaping TaskBlock) {
        self.init()
        
        self.preExecute = preExecute
        self.execute = execute
        self.updateView = updateView
        error = nil
    }
    
    public convenience init(preExecute: @escaping TaskBlock, execute: @escaping ThrowableTaskBlock, updateView: @escaping TaskBlock, onError: @escaping ErrorTaskBlock) {
        self.init()
        
        self.preExecute = preExecute
        self.execute = execute
        self.updateView = updateView
        error = onError
    }
}
