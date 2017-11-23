//
//  Result.swift
//  MochaUtilities
//
//  Created by Gregory Sholl e Santos on 23/11/17.
//

import Foundation

public enum Result<T> {
    case success(T)
    case failure(MochaException)
}

public extension Result {
    
    public func map<U>(_ transform: (T) -> U) -> Result<U> {
        switch self {
        case .failure(let fluigError):
            return .failure(fluigError)
        case .success(let value):
            return .success(transform(value))
        }
    }
    
    public func flatMap<U>(_ transform: (T) -> Result<U>) -> Result<U> {
        switch self {
        case .failure(let error):
            return .failure(error)
        case .success(let value):
            return transform(value)
        }
    }
}

public func ==<T: Equatable>(lhs: Result<T>, rhs: Result<T>) -> Bool {
    switch (lhs, rhs) {
    case (.failure(let leftError), .failure(let rightError)):
        return leftError == rightError
    case (.success(let leftValue), .success(let rightValue)):
        return leftValue == rightValue
    default:
        return false
    }
}

public func == (lhs: Result<Void>, rhs: Result<Void>) -> Bool {
    switch (lhs, rhs) {
    case (.failure(let leftError), .failure(let rightError)):
        return leftError == rightError
    case (.success, .success):
        return true
    default:
        return false
    }
}
