//
//  MochaLogger.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 05/06/17.
//
//

import UIKit

//MARK: - Declaration

public final class MochaLogger {
    
    //MARK: - Variables
    
    static fileprivate let shared = MochaLogger()
    
    fileprivate var tag : String?
    
    //MARK: - Inits
    
    private init() {
        tag = "Mocha"
    }
}

//MARK: - Tag Formatting

public extension MochaLogger {
    
    static public func changeTag(to newTag: String) {
        if newTag.isEmpty {
            return
        }
        shared.tag = newTag
    }
    
    static public func removeTag() {
        shared.tag = nil
    }
}

//MARK: - Logging

public extension MochaLogger {
    
    static public func log(_ nullableMessage: String?) {
        guard let message = nullableMessage else {
            return
        }
        shared.log(message)
    }
    
    private func log(_ message: String) {
        print(getFormattedMessage(message))
    }
    
    private func getFormattedMessage(_ message: String) -> String {
        guard let tag = self.tag else {
            return message
        }
        return "[\(tag)] \(message)"
    }
}
