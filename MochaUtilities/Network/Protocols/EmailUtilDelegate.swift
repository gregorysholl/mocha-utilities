//
//  EmailUtilDelegate.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 18/07/17.
//
//

import UIKit

public protocol EmailUtilDelegate {
    func onEmailSuccessful()
    func onEmailCancelled()
    func onEmailFailed()
}
