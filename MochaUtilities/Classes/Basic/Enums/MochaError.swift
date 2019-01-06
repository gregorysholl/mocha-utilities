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

        var localizedDescription: String {
            switch self {
            case .badRequest:
                return NSLocalizedString("Bad request", comment: "Bad request")
            case .unauthorized:
                return NSLocalizedString("Unauthorized", comment: "Unauthorized")
            case .forbidden:
                return NSLocalizedString("Forbidden", comment: "Forbidden")
            case .notFound:
                return NSLocalizedString("Not found", comment: "Not found")
            }
        }
    }
    
    case httpResponse(statusCode: Int, data: Data?)
    
    case appSecurityTransport
    
    case fileNotFound
    
    case notImplemented
    
    case serialization

    case invalidContentType
    
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
        case (.invalidContentType, .invalidContentType):
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
        case .httpResponse(let statusCode, _):
            guard let code = HttpStatusCode(rawValue: statusCode) else {
                return NSLocalizedString("Htpp response code is \(statusCode)",
                    comment: "Generic status code error")
            }

            return code.localizedDescription
        case .appSecurityTransport:
            return NSLocalizedString("Invalid Security Transport settings for request",
                                     comment: "Invalid Security Transport setting")
        case .fileNotFound:
            return NSLocalizedString("File not found",
                                     comment: "File not found")
        case .notImplemented:
            return NSLocalizedString("Method not implemented",
                                     comment: "Method not implemented")
        case .serialization:
            return NSLocalizedString("Serialization error",
                                     comment: "Serialization error")
        case .invalidContentType:
            return NSLocalizedString("Invalid Content-Type for pamaremeters",
                                     comment: "Invalid Content-Type")
        case .descriptive(let message):
            return message
        case .error(let error):
            return error.localizedDescription
        }
    }
}
