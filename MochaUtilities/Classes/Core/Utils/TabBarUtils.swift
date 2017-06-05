//
//  TabBarUtils.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 05/06/17.
//
//

import UIKit

public class TabBarUtils {
    
    //MARK: - Get
    
    ///Returns the `UITabBar` of the given `UIViewController` if possible, or `nil` otherwise.
    static public func get(for viewController: UIViewController) -> UITabBar? {
        guard let tabBarController = viewController.tabBarController else {
            return nil
        }
        
        return tabBarController.tabBar
    }
    
    static public func getHeight(for viewController:UIViewController) -> CGFloat {
        guard let tabBar = get(for: viewController) else {
            return 0.0
        }
        
        let height = tabBar.frame.size.height
        return height
    }
    
    //MARK: - Layout
    
    static public func setTextColor(_ color: UIColor, for state: UIControlState) {
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: color], for: state)
    }
    
    static public func setBackgroundColor(_ color: UIColor){
        UITabBar.appearance().barTintColor = color
    }
}
