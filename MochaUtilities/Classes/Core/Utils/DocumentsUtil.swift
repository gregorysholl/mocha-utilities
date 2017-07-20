//
//  DocumentsUtil.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 19/07/17.
//
//

import UIKit

//MARK: - Variables & Accessors

public class DocumentsUtil {
    
    private init() {}
}

//MARK: - Path

public extension DocumentsUtil {
    
    public func path(forDomainMask domainMask: FileManager.SearchPathDomainMask = .userDomainMask) throws -> String {
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, domainMask, true)
        if documentPaths.isEmpty {
            throw MochaException.fileNotFoundException
        }
        return documentPaths[0]
    }
    
    public func path(of filename: String?, with domainMask: FileManager.SearchPathDomainMask = .userDomainMask) throws -> String {
        guard let filename = filename, filename.isNotEmpty else {
            throw MochaException.fileNotFoundException
        }
        let documentPath = try path(forDomainMask: domainMask)
        return documentPath.appendingPathComponent(filename)
    }
}
