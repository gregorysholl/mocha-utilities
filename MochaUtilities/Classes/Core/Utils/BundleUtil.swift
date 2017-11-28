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
    
    public func file(_ filename: String?, ofType type: String?) -> Result<Data> {
        let path = try self.path(of: filename, ofType: type)
        guard let fileData = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return .failure(.fileNotFoundException)
        }
        return .success(fileData)
    }
}

// MARK: - Path

public extension BundleUtil {
    
    public func path(of filename: String?, ofType type: String?) -> Result<String> {
        guard let path = bundle.path(forResource: filename, ofType: type) else {
            return .failure(.fileNotFoundException)
        }
        return .success(path)
    }
    
    public func resourcePath(of filename: String) -> Result<String> {
        guard let resourcePath = bundle.resourcePath else {
            return .failure(.fileNotFoundException)
        }
        return .success(resourcePath.appendingPathComponent(filename))
    }
}

// MARK: - Read

public extension BundleUtil {
    
    public func read(_ filename: String?, ofType type: String?, withEncoding encoding: String.Encoding = .utf8) -> Result<String> {
        let path = self.path(of: filename, ofType: type)
        return path.flatMap { read(atPath: $0) }
    }
    
    public func read(atPath filePath: String,
                     withEncoding encoding: String.Encoding = .utf8) -> Result<String> {
        do {
            return try .success(String(contentsOfFile: filePath, encoding: encoding))
        } catch {
            return .failure(.genericException(message: ""))
        }
    }
}
