//
//  HttpClient.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 05/06/17.
//
//

import UIKit

public class HttpClient: NSObject {
    
    public typealias Handler = (_ result: Result<Data>) -> Void
    
    public typealias SuccessHandler = (_ data: Data) -> Void
    
    public typealias FailureHandler = (_ result: MochaError) -> Void
    
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
    
    //Request
    
    fileprivate var url : String?
    
    //Response
    
    @available(iOS, deprecated: 0.7.0, message: "Use `success` and `failure` closures instead.")
    fileprivate var responseHandler   : Handler?
    
    fileprivate var success : SuccessHandler?
    fileprivate var failure : FailureHandler?
    
    // MARK: Inits
    
    override fileprivate init() {
        super.init()
        
        contentType = "application/json"
        timeout = 60
        encoding = .utf8
        
        header = [:]
        parameters = [:]
    }
    
    // MARK: Conversions
    
    private func convertBasicAuthToBase64(username: String,
                                          password: String) -> Result<String> {
        let credentials = "\(username):\(password)"
        
        guard let data = credentials.data(using: encoding) else {
            return .failure(.descriptive(message: "Error formatting the basic authentication provided."))
        }
        
        let base64Credential = data.base64EncodedString(options: .lineLength64Characters)
        return .success("Basic \(base64Credential)")
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
    
    private func send(httpMethod: String) {
        
        guard let url = self.url else {
            failure?(.descriptive(message: "URL cannot be `nil`."))
            return
        }
        
        guard let nsurl = URL(string: url) else {
            failure?(.descriptive(message: "Invalid URL."))
            return
        }
        
        var request = URLRequest(url: nsurl, cachePolicy: .useProtocolCachePolicy)
        request.httpMethod = httpMethod
        
        if let username = self.username, username.isNotEmpty,
            let password = self.password, password.isNotEmpty {
            let convertResult = convertBasicAuthToBase64(username: username,
                                                         password: password)
            
            switch convertResult {
            case .success(let encodedAuth):
                request.setValue(encodedAuth, forHTTPHeaderField: "Authorization")
            default:
                break
            }
        }
        
        if header.count > 0 {
            for (key, value) in header {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if httpMethod.equalsIgnoreCase("post") || httpMethod.equalsIgnoreCase("update") {
            if parameters.isEmpty {
                failure?(.descriptive(message:
                    "Http request (\(httpMethod.uppercased()) without parameters."))
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
                    failure?(.serialization)
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
                if httpResponse.statusCode != 200 {
                    self.failure?(.httpResponse(statusCode: httpResponse.statusCode,
                                                data: data))
                }
            }
            
            if let error = error {
                MochaLogger.log("Http error: \(error.localizedDescription)")
                self.failure?(.error(error: error))
            }
            
            if let data = data {
                self.success?(data)
            }
        })
        
        dataTask.resume()
        
        session.finishTasksAndInvalidate()
    }
}

// MARK: - Certificate

public extension HttpClient {
    
    public enum CertificateMode {
        case none
        case publicKey
    }
    
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

// MARK: - Builder

public extension HttpClient {
    
    public class Builder {
        
        // MARK: Variables
        
        //Http Properties
        
        public var contentType: String {
            get { return helper.contentType }
            set { helper.contentType = newValue }
        }
        
        public var timeout: TimeInterval {
            get { return helper.timeout }
            set { helper.timeout = newValue }
        }
        
        public var encoding: String.Encoding {
            get { return helper.encoding }
            set { helper.encoding = newValue }
        }
        
        public var header: [String: String] {
            get { return helper.header }
            set { helper.header = newValue }
        }
        
        public var parameters: [String: Any] {
            get { return helper.parameters }
            set { helper.parameters = newValue }
        }
        
        //Certificates
        
        public var trustAllSSL: Bool {
            get { return helper.trustAllSSL }
            set { helper.trustAllSSL = newValue }
        }
        
        public var hostDomain: String? {
            get { return helper.hostDomain }
            set { helper.hostDomain = newValue }
        }
        
        //Request
        
        public var url : String? {
            get { return helper.url }
            set { helper.url = newValue }
        }
        
        //Response
        
        @available(iOS, deprecated: 0.7.0, message: "Use `success` and `failure` closures instead.")
        public var responseHandler   : Handler? {
            get { return helper.responseHandler }
            set { helper.responseHandler = newValue }
        }
        
        public var success  : SuccessHandler? {
            get { return helper.success }
            set { helper.success = newValue }
        }
        
        public var failure  : FailureHandler? {
            get { return helper.failure }
            set { helper.failure = newValue }
        }
        
        private var helper : HttpClient!
        
        // MARK: Inits
        
        public init() {
            helper = HttpClient()
        }
        
        public convenience init(build: (Builder) -> Void) {
            self.init()
            build(self)
        }
        
        // MARK: Methods
        
        public func set(_ build: (Builder) -> Void) -> Builder {
            build(self)
            return self
        }

        public func basicAuth(username: String, password: String) {
            helper.username = username
            helper.password = password
        }

        public func certificate(_ certificate: Data?, with password: String? = nil) {
            if certificate != nil {
                helper.certificateMode = .publicKey
            }

            helper.certificate = certificate
            helper.certificatePassword = password
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

