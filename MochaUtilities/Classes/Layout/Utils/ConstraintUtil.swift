//
//  ConstraintUtil.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 21/07/17.
//
//

import UIKit

// MARK: - Multiplier

public class ConstraintUtil {
    
    static public func changeMultiplier(of constraint: NSLayoutConstraint, to value: CGFloat, in view: UIView?) -> NSLayoutConstraint {
        let newConstraint = NSLayoutConstraint(item: constraint.firstItem, attribute: constraint.firstAttribute, relatedBy: constraint.relation, toItem: constraint.secondItem, attribute: constraint.secondAttribute, multiplier: value, constant: constraint.constant)
        
        newConstraint.priority = constraint.priority
        
        if #available(iOS 9.0, *) {
            view?.removeConstraint(constraint)
            view?.addConstraint(newConstraint)
        } else {
            NSLayoutConstraint.deactivate([constraint])
            NSLayoutConstraint.activate([newConstraint])
        }
        
        return newConstraint
    }
}
