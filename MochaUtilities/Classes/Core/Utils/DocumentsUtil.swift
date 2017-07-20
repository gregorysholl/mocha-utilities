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
    
    public func read(_ filename: String?, withEncoding encoding: String.Encoding = .utf8) throws -> String {
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

//MARK: - Write

public extension DocumentsUtil {
    
    public func write(_ text: String, in filename: String?, withEncoding encoding: String.Encoding = .utf8) throws {
        let path = try self.path(of: filename, with: .allDomainsMask)
        try write(text, atPath: path, withEncoding: encoding)
    }
    
    public func write(_ text: String, atPath path: String, withEncoding encoding: String.Encoding = .utf8) throws {
        do {
            try text.write(toFile: path, atomically: false, encoding: encoding)
        } catch {
            throw MochaException.genericException(message: "")
        }
    }
}

//MARK: - Append

public extension DocumentsUtil {
    
    public func append(_ text: String, in filename: String?, ofType type: String?) throws {
        guard let filename = filename, filename.isNotEmpty else {
            throw MochaException.fileNotFoundException
        }
        
        var fullFileName = ""
        if let type = type {
            fullFileName = "\(filename).\(type)"
        } else {
            fullFileName = filename
        }
        
        let currentText = try read(fullFileName)
        let newText = "\(currentText)\n\(text)"
        try write(newText, in: fullFileName)
    }
    
    public func append(_ text: String, atPath path: String) throws {
        let currentText = try read(atPath: path)
        let newText = "\(currentText)\n\(text)"
        try write(newText, atPath: path)
    }
}

//MARK: - Remove

public extension DocumentsUtil {
    
    public func remove(atPath path: String) throws {
        do {
            try FileManager.default.removeItem(atPath: path)
        } catch {
            throw MochaException.genericException(message: "")
        }
    }
    
    public func remove(_ filename: String?) throws {
        let path = try self.path(of: filename)
        try remove(atPath: path)
    }
    
    public func removeAll(in filenames: [String]) throws {
        if filenames.isEmpty {
            throw MochaException.fileNotFoundException
        }
        
        for filename in filenames {
            try remove(filename)
        }
    }
}

//MARK: - Directories

public extension DocumentsUtil {
    
    public func createDirectories(atPath path: String) throws {
        guard !fileExists(path) else {
            return
        }
        
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            throw MochaException.genericException(message: "")
        }
    }
}
