//
//  HttpClient.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 05/06/17.
//
//

import UIKit

public typealias HttpCompletionHandler = (_ result: Result<Data>) -> Void

public class HttpClient: NSObject {
    
    // MARK: Variables
    
    static public var builder   : HttpClient.Builder {
        return HttpClient.Builder()
    }
    
    //Http Properties
    
    fileprivate var contentType : String!
    fileprivate var timeout     : TimeInterval!
    fileprivate var encoding    : String.Encoding!
    
    fileprivate var header      : [String: String]!
    fileprivate var parameters  : [String: Any]!
    
    //Basic Authorization
    
    fileprivate var username    : String?
    fileprivate var password    : String?
    
    //Certificates
    
    fileprivate var certificateMode     : CertificateMode = .none
    
    fileprivate var certificate         : Data?
    fileprivate var certificatePassword : String?
    
    fileprivate var trustAllSSL         : Bool = false
    
    fileprivate var hostDomain          : String?
    
    //Request
    
    fileprivate var url : String?
    
    //Response
    
    fileprivate var completionHandler   : HttpCompletionHandler?
    
    // MARK: Inits
    
    fileprivate override init() {
        super.init()
        
        contentType = "application/json"
        timeout = 60
        encoding = .utf8
        
        header = [:]
        parameters = [:]
    }
    
    // MARK: Conversions
    
    private func convertBasicAuthToBase64(username: String, password: String) throws -> String {
        let credentials = "\(username):\(password)"
        
        guard let data = credentials.data(using: encoding) else {
            throw MochaError.descriptive(message: "Error formatting the basic authentication provided.")
        }
        
        let base64Credential = data.base64EncodedString(options: .lineLength64Characters)
        let authValue = "Basic \(base64Credential)"
        return authValue
    }
    
    private func string(fromDictionary dictionary: [String: Any]) -> String {
        var resource = ""
        
        for (key, value) in dictionary {
            resource = resource.isEmpty ? "" : resource + "&"
            resource += key + "=" + "\(value)"
        }
        
        return resource
    }
    
    // MARK: Requests
    
    public func get() {
        send(httpMethod: "get")
    }
    
    public func delete() {
        send(httpMethod: "delete")
    }
    
    public func post() {
        send(httpMethod: "post")
    }
    
    public func update() {
        send(httpMethod: "update")
    }
    
    private func handleGenericError(with message: String) {
        completionHandler?(.failure(.descriptive(message: message)))
    }
    
    private func send(httpMethod: String) {
        
        guard let url = self.url else {
            handleGenericError(with: "URL cannot be `nil`")
            return
        }
        
        guard let nsurl = URL(string: url) else {
            handleGenericError(with: "Invalid URL.")
            return
        }
        
        var request = URLRequest(url: nsurl, cachePolicy: .useProtocolCachePolicy)
        request.httpMethod = httpMethod
        
        if let username = self.username, username.isNotEmpty, let password = self.password, password.isNotEmpty {
            do {
                let encodedBasicAuth = try convertBasicAuthToBase64(username: username, password: password)
                request.setValue(encodedBasicAuth, forHTTPHeaderField: "Authorization")
            } catch MochaError.descriptive(let message) {
                MochaLogger.log(message)
            } catch {}
        }
        
        if header.count > 0 {
            for (key, value) in header {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if httpMethod.equalsIgnoreCase("post") || httpMethod.equalsIgnoreCase("update") {
            if parameters.isEmpty {
                handleGenericError(with: "Http request (\(httpMethod.lowercased()) without parameters.")
                return
            }
            
            if request.value(forHTTPHeaderField: "Content-Type") == nil {
                request.setValue(contentType, forHTTPHeaderField: "Content-Type")
            }
            
            if contentType == "application/x-www-form-urlencoded" {
                let formString = string(fromDictionary: parameters)
                let length = "\(formString.length)"
                
                request.setValue(length, forHTTPHeaderField: "Content-Length")
                request.httpBody = formString.data(using: encoding)
            } else {
                do {
                    let data = try JSONSerialization.data(withJSONObject: parameters, options: [])
                    request.httpBody = data
                } catch {
                    completionHandler?(.failure(.serialization))
                    return
                }
            }
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeout
        
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        let dataTask = session.dataTask(with: request, completionHandler: {
            (data: Data?, response: URLResponse?, error: Error?) in
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == -1022 {
                    self.completionHandler?(.failure(.appSecurityTransport))
                } else if httpResponse.statusCode != 200 {
                    self.completionHandler?(
                        .failure(
                        MochaError.httpResponse(statusCode: httpResponse.statusCode,
                                                data: nil)))
                }
            }
            
            if let error = error {
                MochaLogger.log("Http error: \(error.localizedDescription)")
                self.completionHandler?(.failure(.error(error: error)))
            }
            
            if let data = data {
                self.completionHandler?(.success(data))
            }
        })
        
        dataTask.resume()
        
        session.finishTasksAndInvalidate()
    }
    
    // MARK: Certificate Handlers
    
    fileprivate func shoultTrustProtectionSpace(_ protectionSpace: URLProtectionSpace) -> Bool {
        
        guard let certificate = certificate else {
            return false
        }
        
        guard let serverTrust = protectionSpace.serverTrust else {
            return false
        }
        
        let cfCertificate = certificate as CFData
        let secCertificate = SecCertificateCreateWithData(kCFAllocatorDefault, cfCertificate)
        
        var certRawPointer : UnsafeRawPointer? = UnsafeRawPointer([secCertificate])
        
        guard let cfArray = CFArrayCreate(kCFAllocatorDefault, &certRawPointer, 1, nil) else {
            return false
        }
        
        SecTrustSetAnchorCertificates(serverTrust, cfArray)
        
        var trustResult: SecTrustResultType = .invalid
        SecTrustEvaluate(serverTrust, &trustResult)
        
        if trustResult == .recoverableTrustFailure {
            let errDataRef = SecTrustCopyExceptions(serverTrust)
            SecTrustSetExceptions(serverTrust, errDataRef)
            
            SecTrustEvaluate(serverTrust, &trustResult)
        }
        
        return trustResult == .unspecified || trustResult == .proceed
    }
    
    fileprivate func loadCredential() -> URLCredential? {
        
        guard let certificate = certificate else {
            return nil
        }
        
        guard let password = certificatePassword else {
            return nil
        }
        
        let keys    : [CFString] = [kSecImportExportPassphrase]
        let values  : [String] = [password]
        
        var keysPointer : UnsafeRawPointer? = UnsafeRawPointer(keys)
        var valuesPointer : UnsafeRawPointer? = UnsafeRawPointer(values)
        
        guard let optionsDictionary = CFDictionaryCreate(kCFAllocatorDefault, &keysPointer, &valuesPointer, 1, nil, nil) else {
            return nil
        }
        
        var p12Items : CFArray?
        
        let result = SecPKCS12Import(certificate as CFData, optionsDictionary, &p12Items)
        
        guard result == noErr else {
            MochaLogger.log("Http error: Invalid certificate or password.")
            return nil
        }
        
        let identityDict = CFArrayGetValueAtIndex(p12Items, 0) as! CFDictionary
        let identityApp = CFDictionaryGetValue(identityDict, Unmanaged.passRetained(kSecImportItemIdentity).toOpaque()) as! SecIdentity
        
        var certRef : SecCertificate?
        
        SecIdentityCopyCertificate(identityApp, &certRef)
        
        guard let newCertRef = certRef else {
            MochaLogger.log("Http error: Invalid certificate or password.")
            return nil
        }
        
        let certArray : [SecCertificate] = [newCertRef]
        var certArrayPointer : UnsafeRawPointer? = UnsafeRawPointer(certArray)
        
        CFArrayCreate(kCFAllocatorDefault, &certArrayPointer, 1, nil)
        
        let credential = URLCredential(identity: identityApp, certificates: nil, persistence: .none)
        return credential
    }
}

// MARK: - Enums

public extension HttpClient {
    
    public enum CertificateMode {
        case none
        case publicKey
    }
}

// MARK: - Builder

public extension HttpClient {
    
    public class Builder {
        
        private var helper : HttpClient
        
        public init() {
            helper = HttpClient()
        }
        
        public func url(_ url: String) -> Builder {
            helper.url = url
            return self
        }

        public func completionHandler(_ handler: @escaping HttpCompletionHandler) -> Builder {
            helper.completionHandler = handler
            return self
        }

        public func parameters(_ parameters: [String: Any]) -> Builder {
            helper.parameters = parameters
            return self
        }

        public func contentType(_ contentType: String) -> Builder {
            helper.contentType = contentType
            return self
        }

        public func timeout(_ timeout: TimeInterval) -> Builder {
            helper.timeout = timeout
            return self
        }

        public func encoding(_ encoding: String.Encoding) -> Builder {
            helper.encoding = encoding
            return self
        }

        public func header(_ header: [String: String]) -> Builder {
            helper.header = header
            return self
        }

        public func basicAuth(username: String, password: String) -> Builder {
            helper.username = username
            helper.password = password
            return self
        }

        public func certificate(_ certificate: Data?, with password: String? = nil) -> Builder {
            if certificate != nil {
                helper.certificateMode = .publicKey
            }

            helper.certificate = certificate
            helper.certificatePassword = password
            return self
        }

        public func trustAll(_ trustAll: Bool) -> Builder {
            helper.trustAllSSL = trustAll
            return self
        }

        public func hostDomain(_ hostDomain: String) -> Builder {
            helper.hostDomain = hostDomain
            return self
        }
        
        public func build() -> HttpClient {
            return helper
        }
    }
}

// MARK: - URL Session Delegate

extension HttpClient: URLSessionDelegate {
    
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        guard let error = error else {
            return
        }
        
        MochaLogger.log(error.localizedDescription)
    }
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if let hostDomain = hostDomain, !hostDomain.equalsIgnoreCase(challenge.protectionSpace.host) {
            completionHandler(.rejectProtectionSpace, nil)
        }
        
        if trustAllSSL {
            if let serverTrust = challenge.protectionSpace.serverTrust {
                let credential = URLCredential(trust: serverTrust)
                completionHandler(.useCredential, credential)
            } else {
                completionHandler(.performDefaultHandling, nil)
            }
        } else if certificateMode == .publicKey {
            if shoultTrustProtectionSpace(challenge.protectionSpace) {
                if certificatePassword != nil {
                    let credential = loadCredential()
                    completionHandler(.useCredential, credential)
                } else {
                    if let serverTrust = challenge.protectionSpace.serverTrust {
                        let credential = URLCredential(trust: serverTrust)
                        completionHandler(.useCredential, credential)
                    } else {
                        completionHandler(.performDefaultHandling, nil)
                    }
                }
            } else {
                completionHandler(.cancelAuthenticationChallenge, nil)
            }
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}

