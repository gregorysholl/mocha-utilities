//
//  HttpHelper.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 05/06/17.
//
//

import UIKit

public typealias HttpCompletionHandler = (_ data: Data?, _ error: Error?) -> Void

public class HttpHelper: NSObject {
    
    // MARK: Variables
    
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
    
    //Request Type
    
//    fileprivate var synchronous : Bool = false
    
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
            throw MochaException.domainException(message: "Error formatting the basic authentication provided.")
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
    
    private func handleDomainException(_ message: String) {
        completionHandler?(nil, MochaException.domainException(message: message))
    }
    
    private func send(httpMethod: String) {
        
        guard let url = self.url else {
            handleDomainException("URL cannot be `nil`")
            return
        }
        
        guard let nsurl = URL(string: url) else {
            handleDomainException("Invalid URL.")
            return
        }
        
        var request = URLRequest(url: nsurl, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeout)
        request.httpMethod = httpMethod
        
        if let username = self.username, username.isNotEmpty, let password = self.password, password.isNotEmpty {
            do {
                let encodedBasicAuth = try convertBasicAuthToBase64(username: username, password: password)
                request.setValue(encodedBasicAuth, forHTTPHeaderField: "Authorization")
            } catch MochaException.domainException(let message) {
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
                handleDomainException("Http request (\(httpMethod.lowercased()) without parameters.")
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
                    handleDomainException("Error formatting the data to be sent.")
                }
            }
        }
        
        let configuration = URLSessionConfiguration.default
        
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        let dataTask = session.dataTask(with: request, completionHandler: {
            (data: Data?, response: URLResponse?, error: Error?) in
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == -1022 {
                    self.completionHandler?(nil, MochaException.appSecurityTransportException)
                } else if httpResponse.statusCode != 200 {
                    self.completionHandler?(nil, error)
//                    throw Exception.ioException
                }
            }
            
            if let error = error {
                MochaLogger.log("Http error: \(error.localizedDescription)")
                self.completionHandler?(nil, error)
            }
            
            if let data = data {
                self.completionHandler?(data, nil)
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

public extension HttpHelper {
    
    public enum CertificateMode {
        case none
        case publicKey
    }
}

// MARK: - Builder

public extension HttpHelper {
    
    public class Builder {
        
        private var helper : HttpHelper
        
        public init() {
            helper = HttpHelper()
        }
        
        public func setUrl(_ url: String) -> Builder {
            helper.url = url
            return self
        }
        
        public func setCompletionHandler(_ handler: @escaping HttpCompletionHandler) -> Builder {
            helper.completionHandler = handler
            return self
        }
        
//        public func setSynchronous(_ synchronous: Bool) -> Builder {
//            helper.synchronous = synchronous
//            return self
//        }
        
        public func setParameters(_ parameters: [String: Any]) -> Builder {
            helper.parameters = parameters
            return self
        }
        
        public func setContentType(_ contentType: String) -> Builder {
            helper.contentType = contentType
            return self
        }
        
        public func setTimeout(_ timeout: TimeInterval) -> Builder {
            helper.timeout = timeout
            return self
        }
        
        public func setEncoding(_ encoding: String.Encoding) -> Builder {
            helper.encoding = encoding
            return self
        }
        
        public func setHeader(_ header: [String: String]) -> Builder {
            helper.header = header
            return self
        }
        
        public func setBasicAuth(username: String, password: String) -> Builder {
            helper.username = username
            helper.password = password
            return self
        }
        
        public func setCertificate(_ certificate: Data?, with password: String? = nil) -> Builder {
            if certificate != nil {
                helper.certificateMode = .publicKey
            }
            
            helper.certificate = certificate
            helper.certificatePassword = password
            return self
        }
        
        public func setTrustAll(_ trustAll: Bool) -> Builder {
            helper.trustAllSSL = trustAll
            return self
        }
        
        public func setHostDomain(_ hostDomain: String) -> Builder {
            helper.hostDomain = hostDomain
            return self
        }
        
        public func build() -> HttpHelper {
            return helper
        }
    }
}

// MARK: - URL Session Delegate

extension HttpHelper: URLSessionDelegate {
    
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        guard let error = error else {
            return
        }
        
//        responseError = error
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

