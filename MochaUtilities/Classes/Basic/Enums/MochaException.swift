//
//  Exception.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 05/06/17.
//
//

import Foundation

public enum MochaException : Error {
    
    case ioException
    case fileNotFoundException
    case appSecurityTransportException
    case notImplemented
    
    case illegalStateException(message: String)
    case domainException(message: String)
    case genericException(message: String)
}
