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
    
    private var _data    : Data!
    private var _type    : String!
    private var _filename: String!
    
    public var data : Data {
        return _data
    }
    
    public var type : String {
        return _type
    }
    
    public var filename : String {
        return _filename
    }
    
    // MARK: Inits
    
    ///compressionQuality is a number between 0.0 and 1.0
    public init(jpegImage: UIImage, compressionQuality: CGFloat = 1.0, filename: String) {
        _data = UIImageJPEGRepresentation(jpegImage, compressionQuality)
        _type = "image/jpeg"
        _filename = filename
    }
    
    public init(pngImage: UIImage, filename: String) {
        _data = UIImagePNGRepresentation(pngImage)
        _type = "image/png"
        _filename = filename
    }
    
    public init(data: Data, type: String, filename: String) {
        _data = data
        _type = type
        _filename = filename
    }
}
