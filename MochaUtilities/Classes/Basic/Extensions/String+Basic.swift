//
//  String+Basic.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 05/06/17.
//
//

import Foundation

// MARK: - Get-only Properties

public extension String {
    
    public var length: Int {
        return characters.count
    }
    
    public var isNotEmpty: Bool {
        return !isEmpty
    }
}

// MARK: - Equals

public extension String {
    
    public func equalsIgnoreCase(_ otherString: String) -> Bool {
        return localizedCaseInsensitiveCompare(otherString) == .orderedSame
    }
}
