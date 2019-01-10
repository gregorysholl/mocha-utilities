//
//  EmailUtil.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 18/07/17.
//
//

import UIKit

import MobileCoreServices
import MessageUI

// MARK: - Main

public class EmailUtil: NSObject {
    
    // MARK: Variables
    
    private static var instance : EmailUtil?
    
    private var delegate : EmailUtilDelegate?
    
    // MARK: Inits
    
    private override init() {
        super.init()
    }
}

// MARK: - Valid

public extension EmailUtil {
    
    public static func isValid(_ string: String?, strictRules strict: Bool = false) -> Bool {
        let emailRegex = strict ? "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$" : "^.+@.+\\.[A-Za-z]{2}[A-Za-z]*$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: string)
    }
}

// MARK: - Send

public extension EmailUtil {
    
    public static func canSend() -> Bool {
        return MFMailComposeViewController.canSendMail()
    }
    
    public static func send(to destinationEmail: String, withSubject subject: String = "", andBody body: String = "") {
        
        if !canSend() {
            return
        }
        
        var email = "mailto:\(destinationEmail)"
        
        if !subject.isEmpty {
            email = "\(email)?subject=\(subject)"
        }
        
        if !body.isEmpty {
            email = "\(email)&body=\(body)"
        }
        
        if let addedPercent = email.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            if let url = URL(string: addedPercent) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    public static func open(with delegate: EmailUtilDelegate, on viewController: UIViewController, withRecipients recipients: [String] = [], subject: String = "", body: String = "", isBodyHtml: Bool = false, andAttachments attachments: [MochaEmailAttachment] = []) -> EmailUtil? {
        
        if !canSend() {
            return nil
        }
        
        let emailUtils = EmailUtil()
        emailUtils.delegate = delegate
        
        let mailCompose = MFMailComposeViewController()
        mailCompose.mailComposeDelegate = emailUtils
        mailCompose.setToRecipients(recipients)
        mailCompose.setSubject(subject)
        mailCompose.setMessageBody(body, isHTML: isBodyHtml)
        
        for attachment in attachments {
            mailCompose.addAttachmentData(attachment.data, mimeType: attachment.type, fileName: attachment.filename)
        }
        
        viewController.present(mailCompose, animated: true, completion: nil)
        
        EmailUtil.instance = emailUtils
        
        return emailUtils
    }
}

// MARK: - Mail Compose View Controller Delegate

extension EmailUtil: MFMailComposeViewControllerDelegate {
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        EmailUtil.instance = nil
        
        controller.dismiss(animated: true, completion: {
            DispatchQueue.main.async {
                switch result {
                    case .cancelled:
                        self.delegate?.onEmailCancelled()
                    case .sent:
                        self.delegate?.onEmailSuccessful()
                    default:
                        break
                }
            }
        })
    }
}
