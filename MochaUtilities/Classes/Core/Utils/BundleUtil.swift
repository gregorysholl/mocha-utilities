//
//  BundleUtil.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 19/07/17.
//
//

import UIKit

// MARK: - Variables & Accessors

public class BundleUtil {
    
    fileprivate var bundle: Bundle!
    
    static public var main: BundleUtil {
        return BundleUtil(bundle: .main)
    }
    
    static public func custom(_ bundle: Bundle) -> BundleUtil {
        return BundleUtil(bundle: bundle)
    }
    
    internal init(bundle: Bundle) {
        self.bundle = bundle
    }
}

// MARK: - File

public extension BundleUtil {
    
    public func file(_ filename: String?, ofType type: String?) throws -> Data {
        let path = try self.path(of: filename, ofType: type)
        guard let fileData = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            throw MochaException.fileNotFoundException
        }
        return fileData
    }
}

// MARK: - Path

public extension BundleUtil {
    
    public func path(of filename: String?, ofType type: String?) throws -> String {
        guard let path = bundle.path(forResource: filename, ofType: type) else {
            throw MochaException.fileNotFoundException
        }
        return path
    }
    
    public func resourcePath(of filename: String) throws -> String {
        guard let resourcePath = bundle.resourcePath else {
            throw MochaException.fileNotFoundException
        }
        return resourcePath.appendingPathComponent(filename)
    }
}

// MARK: - Read

public extension BundleUtil {
    
    public func read(_ filename: String?, ofType type: String?, withEncoding encoding: String.Encoding = .utf8) throws -> String {
        let path = try self.path(of: filename, ofType: type)
        return try read(atPath: path)
    }
    
    public func read(atPath filePath: String, withEncoding encoding: String.Encoding = .utf8) throws -> String {
        do {
            return try String(contentsOfFile: filePath, encoding: encoding)
        } catch {
            throw MochaException.genericException(message: "")
        }
    }
}
