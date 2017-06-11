//
//  String+Core.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 05/06/17.
//
//

import Foundation

// MARK: - String Operations

public extension String {
    
    // MARK: Contains
    
    public func containsIgnoreCase(_ other: String) -> Bool {
        return uppercased().contains(other.uppercased())
    }
    
    public func begins(with other: String) -> Bool {
        guard let range = range(of: other, options: [.anchored, .caseInsensitive]) else {
            return false
        }
        return range.lowerBound == startIndex
    }
    
    // MARK: Replace
    
    public func replacingFirstOccurrence(of target: String, with newString: String) -> String {
        if let range = range(of: target) {
            return replacingCharacters(in: range, with: newString)
        }
        return self
    }
    
    // MARK: Substring
    
    public func substring(from index: Int) -> String {
        return substring(from: self.index(startIndex, offsetBy: index))
    }
    
    public func substring(to index: Int) -> String {
        return substring(to: self.index(startIndex, offsetBy: index))
    }
    
    public func substring(from startIndex: Int, to endIndex: Int) -> String {
        let length = self.length
        if endIndex >= length || (endIndex - startIndex) >= length || startIndex > endIndex {
            return ""
        }
        return self.substring(with: self.index(self.startIndex, offsetBy: startIndex) ..< self.index(self.startIndex, offsetBy: endIndex + 1))
    }
    
    // MARK: Insert
    
    public mutating func insert(str: String, at index: Int) {
        if (length - index) < 0 {
            return
        }
        
        let prefix = characters.prefix(index)
        let suffix = characters.suffix(length - index)
        
        self = String(prefix) + str + String(suffix)
    }
    
    // MARK: Trim
    
    public func trim() -> String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    public func trimDuplicates() -> String {
        let components = self.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        let filtered = components.filter({
            !$0.isEmpty
        })
        return filtered.joined(separator: " ")
    }
    
    // MARK: Split
    
    public func split(with separator: String) -> [String] {
        return components(separatedBy: separator)
    }
}

// MARK: - Numbers Operations

public extension String {
    
    // MARK: Check
    
    public var isNumber: Bool {
        guard isNotEmpty else {
            return false
        }
        
        let notDigits = CharacterSet.decimalDigits.inverted
        if rangeOfCharacter(from: notDigits) != nil {
            return false
        }
        
        return true
    }
}

// MARK: - Conversions

public extension String {
    
    // MARK: UTF-8
    
    public var utf8String: UnsafePointer<Int8>? {
        if self.isEmpty {
            return nil
        }
        return (self as NSString).utf8String
    }
    
    // MARK: Data
    
    public func toData() -> Data? {
        return data(using: .utf8)
    }
    
    // MARK: Json Object
    
    public func toJsonObject() -> [NSObject: Any] {
        guard let data = toData() else {
            MochaLogger.log("Unable to convert given string into a dictionary.")
            return [:]
        }
        
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [NSObject: Any] else {
            MochaLogger.log("Unable to convert given string into a dictionary.")
            return [:]
        }
        
        return jsonObject!
    }
}

// MARK: - File Accessors

public extension String {
    
    public func appendingPathComponent(_ str: String) -> String {
        return (self as NSString).appendingPathComponent(str)
    }
}
