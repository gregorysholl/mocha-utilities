//
//  MochaLogger.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 05/06/17.
//
//

import UIKit

public final class MochaLogger: NSObject {
    
    //MARK: - Variables
    
    static private let shared = MochaLogger()
    
    private var tag : String?
    
    //MARK: - Inits
    
    private override init() {
        super.init()
        
        tag = "Mocha"
    }
    
    //MARK: - Tag Formatting
    
    static public func changeTag(to newTag: String) {
        shared.tag = newTag
    }
    
    static public func removeTag() {
        shared.tag = nil
    }
    
    //MARK: - Logging
    
    static public func log(_ nullableMessage: String?) {
        guard let message = nullableMessage else {
            return
        }
        shared.log(message)
    }
    
    private func log(_ message: String) {
        print(getFormattedMessage(message))
    }
    
    //MARK: - Helpers
    
    private func getFormattedMessage(_ message: String) -> String {
        guard let tag = self.tag else {
            return message
        }
        return "[\(tag)] \(message)"
    }
}
