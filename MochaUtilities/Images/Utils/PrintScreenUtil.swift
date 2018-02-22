//
//  PrintScreenUtils.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 05/06/17.
//
//

import UIKit

public class PrintScreenUtil {
    
    // MARK: - Get
    
    static public func get(of view: UIView?) -> UIImage? {
        guard let view = view else {
            return nil
        }
        
        let screenSize = UIScreen.main.applicationFrame.size
        let colorSpaceRef = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.none
        
        guard let context = CGContext(data: nil, width: Int(screenSize.width), height: Int(screenSize.height), bitsPerComponent: 8, bytesPerRow: 4 * Int(screenSize.width), space: colorSpaceRef, bitmapInfo: bitmapInfo.rawValue) else {
            return nil
        }
        
        context.translateBy(x: 0.0, y: screenSize.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        view.layer.render(in: context)
        
        guard let cgImage = context.makeImage() else {
            return nil
        }
        
        let image = UIImage(cgImage: cgImage)
        return image
    }
    
    // MARK: - Save
    
    static public func save(toJpgFile filename: String, of view: UIView?) {
        guard let image = get(of: view) else {
            return
        }
        
        var filename = filename
        if !filename.contains(".jpg") {
            filename.append(".jpg")
        }
        
        if let data = UIImageJPEGRepresentation(image, 1.0) {
            do {
                try data.write(to: URL(fileURLWithPath: filename), options: .withoutOverwriting)
            } catch {
                MochaLogger.log("Could not save printed screen on file \(filename).")
            }
        }
    }
    
    static public func save(toPngFile filename: String, of view: UIView?) {
        guard let image = get(of: view) else {
            return
        }
        
        var filename = filename
        if !filename.contains(".png") {
            filename.append(".png")
        }
        
        if let data = UIImagePNGRepresentation(image) {
            do {
                try data.write(to: URL(fileURLWithPath: filename), options: .withoutOverwriting)
            } catch {
                MochaLogger.log("Could not save printed screen on file \(filename).")
            }
        }
    }
}
