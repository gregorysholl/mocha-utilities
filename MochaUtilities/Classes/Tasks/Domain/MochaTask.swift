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

//MARK: -

public class MochaTask: NSObject {
    
    //MARK: Variables
    
    var preExecute  : TaskBlock?
    var execute     : ThrowableTaskBlock!
    var updateView  : TaskBlock!
    
    var error       : ErrorTaskBlock?
    
    var operation   : BlockOperation!
    
    //MARK: Inits
    
    override public init() {
        super.init()
    }
    
    public convenience init(preExecute: TaskBlock? = nil, execute: @escaping ThrowableTaskBlock, updateView: @escaping TaskBlock, error: ErrorTaskBlock? = nil) {
        self.init()
        
        self.preExecute = preExecute
        self.execute = execute
        self.updateView = updateView
        self.error = error
    }
}
