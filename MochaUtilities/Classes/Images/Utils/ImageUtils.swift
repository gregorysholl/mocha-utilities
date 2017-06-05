//
//  ImageUtils.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 05/06/17.
//
//

import UIKit

public class ImageUtils {
    
    static public func resize(_ image: UIImage?, withMaxWidthOrHeight max:CGFloat) -> UIImage? {
        let newSize = self.newSize(forImage: image, with: max)
        
        if newSize.width == 0 && newSize.height == 0 {
            return nil
        }
        
        return self.resize(image, to: newSize)
    }
    
    static public func resize(_ image: UIImage?, to newSize: CGSize) -> UIImage? {
        guard let image = image else {
            return nil
        }
        
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    static public func newSize(forImage image: UIImage?, with maximumWidthOrHeight: CGFloat) -> CGSize {
        var size = CGSize(width: 0, height: 0)
        
        guard let image = image else {
            return size
        }
        
        let max = maximumWidthOrHeight
        if image.size.width > image.size.height {
            let propotion = image.size.height / image.size.width
            size.width = max
            size.height = max * propotion
        } else {
            let propotion = image.size.width / image.size.height
            size.height = max
            size.width = max * propotion
        }
        
        return size
    }
}
