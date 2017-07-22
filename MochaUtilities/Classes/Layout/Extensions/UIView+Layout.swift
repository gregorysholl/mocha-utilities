//
//  UIView+Layout.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 21/07/17.
//
//

import UIKit

// MARK: - Gradient

public extension UIView {
    
    public func gradientLayer(withStartColor startColor: UIColor, endColor: UIColor, andDirection direction: GradientDirection = .leftRight) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.frame = bounds
        
        switch direction {
        case .leftRight:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        case .topBottom:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        case .rightLeft:
            gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
        case .bottomUp:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        default:
            break
        }
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    public enum GradientDirection {
        case leftRight
        case topBottom
        case rightLeft
        case bottomUp
    }
}
