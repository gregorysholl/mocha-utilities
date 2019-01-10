//
//  TabBarUtils.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 05/06/17.
//
//

import UIKit

// MARK: - Information

public class TabBarUtil {
    
    ///Returns the `UITabBar` of the given `UIViewController` if possible, or `nil` otherwise.
    public static func tabBar(for viewController: UIViewController) -> UITabBar? {
        guard let tabBarController = viewController.tabBarController else {
            return nil
        }
        return tabBarController.tabBar
    }
    
    public static func height(for viewController:UIViewController) -> CGFloat {
        guard let tabBar = tabBar(for: viewController) else {
            return 0.0
        }
        let height = tabBar.frame.size.height
        return height
    }
}

// MARK: - Layout

public extension TabBarUtil {
    
    public static func setTextColor(_ color: UIColor, for state: UIControl.State) {
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: color], for: state)
    }
    
    public static func setBackgroundColor(_ color: UIColor){
        UITabBar.appearance().barTintColor = color
    }
}
