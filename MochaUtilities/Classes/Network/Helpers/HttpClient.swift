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
    
    fileprivate var handler : Handler?
    
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
    
    private func createBasicAuth() -> Result<String> {
        guard let username = self.username, username.isNotEmpty else {
            return .failure(.descriptive(message:
                "Username not informed for Basic Authorization"))
        }
        
        guard let password = self.password, password.isNotEmpty else {
            return .failure(.descriptive(message:
                "Password not informed for Basic Authorization"))
        }
        
        let credentials = "\(username):\(password)"
        
        guard let data = credentials.data(using: encoding) else {
            return .failure(.descriptive(message:
                "Error formatting the basic authentication provided."))
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
    
    private func handleGenericError(with message: String) {
        handler?(.failure(.descriptive(message: message)))
    }
    
    private func handleError(_ error: MochaError) {
        handler?(.failure(error))
    }
    
    private func createHttpBody(for method: Method) -> Result<Data> {
        guard !parameters.isEmpty else {
            return .failure(.descriptive(message:
                "HttpClient cannot request (\(method.rawValue.uppercased())) without parameters."))
        }
        
        switch contentType {
        case "application/x-www-form-urlencoded":
            let form = string(fromDictionary: parameters)
            return form.data(using: encoding).map {
                Result.success($0)
            } ?? .failure(.serialization)
        default:
            do {
                let data = try JSONSerialization.data(withJSONObject: parameters,
                                                      options: [])
                return .success(data)
            } catch {
                return .failure(.serialization)
            }
        }
    }
    
    private func send(httpMethod: String) {
        
        //prerequisites
        guard let url = self.url else {
            return handleError(.descriptive(message: "URL cannot be `nil`."))
        }
        
        guard let nsurl = URL(string: url) else {
            return handleError(.descriptive(message: "Invalid URL."))
        }
        
        //request
        var request = URLRequest(url: nsurl, cachePolicy: .useProtocolCachePolicy)
        request.httpMethod = httpMethod
        
        //basic auth
        let basicAuthResult = createBasicAuth()
        switch basicAuthResult {
        case .success(let basicAuth):
            request.setValue(basicAuth, forHTTPHeaderField: "Authorization")
        case .failure(let error):
            MochaLogger.log(error.description)
        }
        
        //headers
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
        
        //configuration
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeout
        
        //session
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        let dataTask = session.dataTask(with: request, completionHandler: {
            (data: Data?, response: URLResponse?, error: Error?) in
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == -1022 {
                    self.handler?(.failure(.appSecurityTransport))
                } else if httpResponse.statusCode != 200 {
                    self.handler?(.failure(.httpResponse(statusCode: httpResponse.statusCode,
                                                         data: data)))
                }
            }
            
            if let error = error {
                MochaLogger.log("Http error: \(error.localizedDescription)")
                self.handler?(.failure(.error(error: error)))
            }
            
            if let data = data {
                self.handler?(.success(data))
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
        
        public func handler(_ handler: @escaping Handler) -> Builder {
            helper.handler = handler
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

