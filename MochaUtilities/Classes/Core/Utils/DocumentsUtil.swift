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
    
    internal init() {}
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

//MARK: - Exists

public extension DocumentsUtil {
    
    public func fileExists(_ filename: String?) -> Bool {
        do {
            let path = try self.path(of: filename)
            return FileManager.default.fileExists(atPath: path)
        } catch {
            return false
        }
    }
    
    public func fileExists(atPath path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
}

//MARK: - Get

public extension DocumentsUtil {
    
    public func file(_ filename: String?) throws -> Data {
        let path = try self.path(of: filename)
        return try file(atPath: path)
    }
    
    public func file(atPath path: String) throws -> Data {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            throw MochaException.genericException(message: "")
        }
        return data
    }
}

//MARK: - Read

public extension DocumentsUtil {
    
    public func read(_ filename: String, withEncoding encoding: String.Encoding = .utf8) throws -> String {
        let path = try self.path(of: filename, with: .allDomainsMask)
        return try read(atPath: path, withEncoding: encoding)
    }
    
    public func read(atPath path: String, withEncoding encoding: String.Encoding = .utf8) throws -> String {
        do {
            return try String(contentsOfFile: path, encoding: encoding)
        } catch {
            throw MochaException.fileNotFoundException
        }
    }
}
