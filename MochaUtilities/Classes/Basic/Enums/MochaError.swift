//
//  Exception.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 05/06/17.
//
//

import Foundation

public enum MochaError : Error {
    
    public enum HttpStatusCode: Int, Equatable {
        case badRequest = 400
        case unauthorized = 401
        case forbidden = 403
        case notFound = 404
    }
    
    case httpResponse(statusCode: Int, data: Data?)
    
    case appSecurityTransport
    
    case fileNotFound
    
    case notImplemented
    
    case serialization
    
    case descriptive(message: String)
    
    case error(error: Error)
}

extension MochaError: Equatable {
    
    public static func ==(lhs: MochaError, rhs: MochaError) -> Bool {
        switch (lhs, rhs) {
        case (.httpResponse(let lstatus, _), .httpResponse(let rstatus, _)):
            return lstatus == rstatus
        case (.appSecurityTransport, .appSecurityTransport):
            return true
        case (.fileNotFound, .fileNotFound):
            return true
        case (.notImplemented, .notImplemented):
            return true
        case (.serialization, .serialization):
            return true
        case (.descriptive(let lmsg), .descriptive(let rmsg)):
            return lmsg == rmsg
        case (.error(let le), .error(let re)):
            return le.localizedDescription == re.localizedDescription
        default: return false
        }
    }
}

extension MochaError: CustomStringConvertible {
    
    public var description: String {
        switch self {
        default:
            return "Uncategorized MochaError"
        }
    }
}
