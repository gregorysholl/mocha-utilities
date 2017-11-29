//
//  UIImage+Images.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 21/07/17.
//
//

import UIKit

// MARK: - Blur

public extension UIImage {
    
    public func blurEffect(with radius: Int) -> UIImage? {
        guard let currentFilter = CIFilter(name: "CIGaussianBlur") else {
            return nil
        }
        
        guard let beginImage = CIImage(image: self) else {
            return nil
        }
        
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter.setValue(radius, forKey: kCIInputRadiusKey)
        
        guard let cropFilter = CIFilter(name: "CICrop") else {
            return nil
        }
        
        cropFilter.setValue(currentFilter.outputImage, forKey: kCIInputImageKey)
        cropFilter.setValue(CIVector(cgRect: beginImage.extent), forKey: "inputRectangle")
        
        guard let output = cropFilter.outputImage else {
            return nil
        }
        
        let context = CIContext(options: nil)
        
        guard let cgimg = context.createCGImage(output, from: output.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgimg)
    }
}
