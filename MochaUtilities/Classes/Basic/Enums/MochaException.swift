//
//  Exception.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 05/06/17.
//
//

import Foundation

public enum MochaException : Error, Equatable {
    
    case ioException
    case fileNotFoundException
    case appSecurityTransportException
    case notImplemented
    
    case illegalStateException(message: String)
    case domainException(message: String)
    case genericException(message: String)
    
    public static func ==(lhs: MochaException, rhs: MochaException) -> Bool {
        switch (lhs, rhs) {
        case (.ioException, .ioException): return true
        case (.fileNotFoundException, .fileNotFoundException): return true
        case (.appSecurityTransportException, .appSecurityTransportException): return true
        case (.notImplemented, .notImplemented): return true
        case (.illegalStateException(let lmsg),
              .illegalStateException(let rmsg)): return lmsg == rmsg
        case (.domainException(let lmsg),
              .domainException(let rmsg)): return lmsg == rmsg
        case (.genericException(let lmsg),
              .genericException(let rmsg)): return lmsg == rmsg
        default: return false
        }
    }
}
