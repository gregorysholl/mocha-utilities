//
//  NumberUtils.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 05/06/17.
//
//

import UIKit

public class NumberUtils {
    
    //MARK: - Int
    
    static public func toInteger(_ string: String?, with defaultValue: Int = 0) -> Int {
        guard let s = string, s.isNotEmpty else {
            return defaultValue
        }
        
        guard let intString = Int(s) else {
            return defaultValue
        }
        
        return intString
    }
    
    //MARK: - Float
    
    static public func toFloat(_ string: String?, with defaultValue: Float = 0.0) -> Float {
        guard let s = string, s.isNotEmpty else {
            return defaultValue
        }
        
        guard let floatString = Float(s) else {
            return defaultValue
        }
        
        return floatString
    }
    
    //MARK: - Double
    
    static public func toDouble(_ string: String?, with defaultValue: Double = 0.0) -> Double {
        guard let s = string, s.isNotEmpty else {
            return defaultValue
        }
        
        guard let doubleString = Double(s) else {
            return defaultValue
        }
        
        return doubleString
    }
    
    //MARK: - Number
    
    static public func toNumber(_ string: String?, with defaultValue: Double = 0.0) -> NSNumber {
        guard let s = string, s.isNotEmpty else {
            return NSNumber(floatLiteral: defaultValue)
        }
        
        guard let numberString = NumberFormatter().number(from: s) else {
            return NSNumber(floatLiteral: defaultValue)
        }
        
        return numberString
    }
    
    //MARK: - Verification
    
    static public func isNumber(_ string: String?) -> Bool {
        return string?.isNumber ?? false
    }
}
