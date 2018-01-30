//
//  UrlSessionHandler.swift
//  MochaUtilities
//
//  Created by Gregory Sholl e Santos on 30/01/18.
//

import UIKit

internal class UrlSessionHandler: NSObject {
    
    fileprivate var certificateMode: HttpClient.CertificateMode = .none
    
    fileprivate var trustAllSSL: Bool = false
    
    fileprivate var hostDomain: String?
    
    fileprivate var certificate: Data?
    
    fileprivate var pkcs12Passphrase: String?

    internal init(certificateMode: HttpClient.CertificateMode = .none,
                  trustAllSSL: Bool = false,
                  hostDomain: String? = nil,
                  certificate: Data? = nil,
                  passphrase: String? = nil) {
        super.init()
        
        self.certificateMode = certificateMode
        self.trustAllSSL = trustAllSSL
        self.certificate = certificate
        pkcs12Passphrase = passphrase
    }
}

extension UrlSessionHandler {
    
    fileprivate func shoultTrustProtectionSpace(_ protectionSpace: URLProtectionSpace) -> Bool {
        
        guard let certificate = certificate else {
            return false
        }
        
        guard let serverTrust = protectionSpace.serverTrust else {
            return false
        }
        
        let cfCertificate = certificate as CFData
        let secCertificate = SecCertificateCreateWithData(kCFAllocatorDefault,
                                                          cfCertificate)
        
        var certRawPointer : UnsafeRawPointer? = UnsafeRawPointer([secCertificate])
        
        guard let cfArray = CFArrayCreate(kCFAllocatorDefault,
                                          &certRawPointer,
                                          1,
                                          nil) else {
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
        
        guard let passphrase = pkcs12Passphrase else {
            return nil
        }
        
        let keys    : [CFString] = [kSecImportExportPassphrase]
        let values  : [String] = [passphrase]
        
        var keysPointer : UnsafeRawPointer? = UnsafeRawPointer(keys)
        var valuesPointer : UnsafeRawPointer? = UnsafeRawPointer(values)
        
        guard let optionsDictionary = CFDictionaryCreate(kCFAllocatorDefault,
                                                         &keysPointer,
                                                         &valuesPointer,
                                                         1,
                                                         nil,
                                                         nil) else {
            return nil
        }
        
        var p12Items : CFArray?
        
        let result = SecPKCS12Import(certificate as CFData,
                                     optionsDictionary,
                                     &p12Items)
        
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
        
        let credential = URLCredential(identity: identityApp,
                                       certificates: nil,
                                       persistence: .none)
        return credential
    }
}

extension UrlSessionHandler: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        
    }
    
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
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
                if pkcs12Passphrase != nil {
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
