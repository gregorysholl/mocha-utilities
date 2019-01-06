//
//  MochaEmailAttachment.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 18/07/17.
//
//

import UIKit

// MARK: -

public class MochaEmailAttachment {

    // MARK: Variables

    let data    : Data
    let type    : String
    let filename: String

    // MARK: Inits

    ///compressionQuality is a number between 0.0 and 1.0
    public init?(jpegImage: UIImage, compressionQuality: CGFloat = 1.0, filename filenameParam: String) {
        guard let jpegData = jpegImage.jpegData(compressionQuality: compressionQuality) else {
            return nil
        }
        data = jpegData
        type = "image/jpeg"
        filename = filenameParam
    }

    public init?(pngImage: UIImage, filename filenameParam: String) {
        guard let pgnData = pngImage.pngData() else {
            return nil
        }
        data = pgnData
        type = "image/png"
        filename = filenameParam
    }

    public init(data dataParam: Data, type typeParam: String, filename filenameParam: String) {
        data = dataParam
        type = typeParam
        filename = filenameParam
    }
}
