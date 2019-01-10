//
//  NumberUtils.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 05/06/17.
//
//

import UIKit

// MARK: - Convertions

public class NumberUtil {
    
    // MARK: Int
    
    public static func toInteger(_ string: String?, with defaultValue: Int = 0) -> Int {
        guard let s = string, !s.isEmpty else {
            return defaultValue
        }
        
        guard let intString = Int(s) else {
            return defaultValue
        }
        
        return intString
    }
    
    // MARK: Float
    
    public static func toFloat(_ string: String?, with defaultValue: Float = 0.0) -> Float {
        guard let s = string, !s.isEmpty else {
            return defaultValue
        }
        
        guard let floatString = Float(s) else {
            return defaultValue
        }
        
        return floatString
    }
    
    // MARK: Double
    
    public static func toDouble(_ string: String?, with defaultValue: Double = 0.0) -> Double {
        guard let s = string, !s.isEmpty else {
            return defaultValue
        }
        
        guard let doubleString = Double(s) else {
            return defaultValue
        }
        
        return doubleString
    }
    
    // MARK: Number
    
    public static func toNumber(_ string: String?, with defaultValue: Double = 0.0) -> NSNumber {
        guard let s = string, !s.isEmpty else {
            return NSNumber(floatLiteral: defaultValue)
        }
        
        guard let numberString = NumberFormatter().number(from: s) else {
            return NSNumber(floatLiteral: defaultValue)
        }
        
        return numberString
    }
}
