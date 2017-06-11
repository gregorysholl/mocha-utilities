//
//  TabBarUtils.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 05/06/17.
//
//

import UIKit

public class TabBarUtil {
    
    //MARK: - Get
    
    ///Returns the `UITabBar` of the given `UIViewController` if possible, or `nil` otherwise.
    static public func tabBar(for viewController: UIViewController) -> UITabBar? {
        guard let tabBarController = viewController.tabBarController else {
            return nil
        }
        
        return tabBarController.tabBar
    }
    
    static public func height(for viewController:UIViewController) -> CGFloat {
        guard let tabBar = tabBar(for: viewController) else {
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
