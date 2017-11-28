//
//  DocumentsUtil.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 19/07/17.
//
//

import UIKit

// MARK: - Variables & Accessors

public class DocumentsUtil {
    
    internal init() {}
}

// MARK: - Path

public extension DocumentsUtil {
    
    public func path(forDomainMask domainMask: FileManager.SearchPathDomainMask = .userDomainMask) -> Result<String> {
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, domainMask, true)
        if documentPaths.isEmpty {
            return .failure(.fileNotFoundException)
        }
        return .success(documentPaths[0])
    }
    
    public func path(of filename: String?, with domainMask: FileManager.SearchPathDomainMask = .userDomainMask) -> Result<String> {
        guard let filename = filename, filename.isNotEmpty else {
            return .failure(.fileNotFoundException)
        }
        return path(forDomainMask: domainMask).map {
            $0.appendingPathComponent(filename)
        }
    }
}

// MARK: - Exists

public extension DocumentsUtil {
    
    public func fileExists(_ filename: String?) -> Result<Bool> {
        let pathResult = self.path(of: filename)
        return pathResult.map {
            FileManager.default.fileExists(atPath: $0)
        }
    }
    
    public func fileExists(atPath path: String) -> Result<Bool> {
        return .success(FileManager.default.fileExists(atPath: path))
    }
}

// MARK: - Get

public extension DocumentsUtil {
    
    public func file(_ filename: String?) -> Result<Data> {
        let pathResult = self.path(of: filename)
        return pathResult.flatMap {
            self.file(atPath: $0)
        }
    }
    
    public func file(atPath path: String) -> Result<Data> {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            return .success(data)
        } catch(let error) {
            return .failure(.genericException(message: error.localizedDescription))
        }
    }
}

// MARK: - Read

public extension DocumentsUtil {
    
    public func read(_ filename: String?,
                     withEncoding encoding: String.Encoding = .utf8) -> Result<String> {
        let pathResult = self.path(of: filename, with: .allDomainsMask)
        return pathResult.flatMap {
            self.read(atPath: $0, withEncoding: encoding)
        }
    }
    
    public func read(atPath path: String,
                     withEncoding encoding: String.Encoding = .utf8) -> Result<String> {
        do {
            return try .success(String(contentsOfFile: path, encoding: encoding))
        } catch {
            return .failure(.fileNotFoundException)
        }
    }
}

// MARK: - Write

public extension DocumentsUtil {
    
    public func write(_ text: String,
                      in filename: String?,
                      withEncoding encoding: String.Encoding = .utf8) -> Result<Void> {
        let pathResult = self.path(of: filename, with: .allDomainsMask)
        return pathResult.flatMap {
            write(text, atPath: $0, withEncoding: encoding)
        }
    }
    
    public func write(_ text: String,
                      atPath path: String,
                      withEncoding encoding: String.Encoding = .utf8) -> Result<Void> {
        do {
            try text.write(toFile: path, atomically: false, encoding: encoding)
            return .success()
        } catch {
            return .failure(.genericException(message: ""))
        }
    }
}

// MARK: - Append

public extension DocumentsUtil {

    public func append(_ text: String,
                       in filename: String?,
                       ofType type: String?) -> Result<Void> {
        guard let filename = filename, filename.isNotEmpty else {
            return .failure(.fileNotFoundException)
        }

        var fullFileName = ""
        if let type = type {
            fullFileName = "\(filename).\(type)"
        } else {
            fullFileName = filename
        }

        let readResult = read(fullFileName)
        
        return readResult.flatMap { (value) -> Result<Void> in
            let newText = "\(value)\n\(text)"
            return write(newText, in: fullFileName)
        }
    }

    public func append(_ text: String, atPath path: String) -> Result<Void> {
        let readResult = read(atPath: path)
        
        return readResult.flatMap { (currentText) -> Result<Void> in
            let newText = "\(currentText)\n\(text)"
            return write(newText, atPath: path)
        }
    }
}

// MARK: - Remove

public extension DocumentsUtil {

    public func remove(atPath path: String) -> Result<Void> {
        do {
            try FileManager.default.removeItem(atPath: path)
            return .success()
        } catch {
            return .failure(.genericException(message: ""))
        }
    }

    public func remove(_ filename: String?) -> Result<Void> {
        let pathResult = self.path(of: filename)
        return pathResult.flatMap { (path) -> Result<Void> in
            return self.remove(atPath: path)
        }
    }

    public func removeAll(in filenames: [String]) -> Result<Void> {
        if filenames.isEmpty {
            return .failure(.fileNotFoundException)
        }

        for filename in filenames {
            let removeResult = remove(filename)
            switch removeResult {
            case .failure(let error):
                return .failure(error)
            default:
                break
            }
        }
        
        return .success()
    }
}

// MARK: - Directories

public extension DocumentsUtil {
    
    public func createDirectories(atPath path: String) -> Result<Void> {
        let existsResult = fileExists(path)
        switch existsResult {
        case .failure(let error):
            return .failure(error)
        case .success(let exists):
            if !exists {
                return .failure(.fileNotFoundException)
            }
        }
        
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            return .success()
        } catch {
            return .failure(.genericException(message: ""))
        }
    }
}

