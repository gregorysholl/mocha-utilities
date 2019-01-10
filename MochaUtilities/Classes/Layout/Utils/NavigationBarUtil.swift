//
//  NavigationBarUtils.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 05/06/17.
//
//

import UIKit

// MARK: - Get

public class NavigationBarUtil {
    
    public static func navigationBar(for viewController: UIViewController) -> UINavigationBar? {
        guard let navigationController = viewController.navigationController else {
            return nil
        }
        return navigationController.navigationBar
    }
}

// MARK: - Information

public extension NavigationBarUtil {
    
    public static func height(for viewController: UIViewController) -> CGFloat {
        guard let navigationBar = navigationBar(for: viewController) else {
            return 0
        }
        return navigationBar.frame.height
    }
}

// MARK: - Show & Hide

public extension NavigationBarUtil {
    
    public static func show(_ viewController: UIViewController) {
        guard let navigationBar = navigationBar(for: viewController) else {
            return
        }
        navigationBar.isHidden = false
    }
    
    public static func hide(_ viewController: UIViewController) {
        guard let navigationBar = navigationBar(for: viewController) else {
            return
        }
        navigationBar.isHidden = true
    }
    
    public static func showBorder(for viewController: UIViewController) {
        guard let navigationBar = navigationBar(for: viewController) else {
            return
        }
        navigationBar.setBackgroundImage(nil, for: .default)
        navigationBar.shadowImage = nil
    }
    
    public static func hideBorder(for viewController: UIViewController) {
        guard let navigationBar = navigationBar(for: viewController) else {
            return
        }
        navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationBar.shadowImage = UIImage()
    }
}

// MARK: - Layout

public extension NavigationBarUtil {
    
    public static func setTranslucent(for viewController: UIViewController) {
        guard let navigationBar = navigationBar(for: viewController) else {
            return
        }
        navigationBar.isTranslucent = true
        navigationBar.isOpaque = false
    }
    
    public static func setOpaque(for viewController: UIViewController) {
        guard let navigationBar = navigationBar(for: viewController) else {
            return
        }
        navigationBar.isTranslucent = false
        navigationBar.isOpaque = true
    }
    
    public static func setTitle(_ title: String, for viewController: UIViewController) {
        viewController.navigationItem.title = title
    }
    
    public static func setTitleColor(_ color: UIColor, andFont font: UIFont = UIFont.systemFont(ofSize: 17), for viewController: UIViewController) {
        setTitleAttributes([.foregroundColor: color, .font: font], for: viewController)
    }
    
    public static func setTitleAttributes(_ titleAttributes: [NSAttributedString.Key: Any], for viewController: UIViewController) {
        guard let navigationBar = navigationBar(for: viewController) else {
            return
        }
        navigationBar.titleTextAttributes = titleAttributes
    }
    
    public static func setTintColor(_ color: UIColor, for viewController: UIViewController) {
        guard let navigationBar = navigationBar(for: viewController) else {
            return
        }
        navigationBar.tintColor = color
    }
    
    public static func setBackgroundColor(_ color: UIColor, for viewController: UIViewController) {
        guard let navigationBar = navigationBar(for: viewController) else {
            return
        }
        navigationBar.barTintColor = color
    }
}

// MARK: - Bar Button

private extension NavigationBarUtil {
    
    private static func barButton(with object: Any?, action: Selector, for target: UIViewController) -> UIBarButtonItem? {
        var barButton : UIBarButtonItem?
        
        if let title = object as? String {
            barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: action)
        } else if let image = object as? UIImage {
            barButton = UIBarButtonItem(image: image, style: .plain, target: target, action: action)
        } else if let systemItem = object as? UIBarButtonItem.SystemItem {
            barButton = UIBarButtonItem(barButtonSystemItem: systemItem, target: target, action: action)
        }
        
        return barButton
    }
}

// MARK: - Back Button

public extension NavigationBarUtil {
    
    public static func setBackButton(withString title: String, for viewController: UIViewController) {
        let backButton = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = backButton
    }
    
    public static func setBackButton(withImage image: UIImage?, for viewController: UIViewController) {
        guard let navigationBar = navigationBar(for: viewController) else {
            return
        }
        
        navigationBar.backIndicatorImage = image
        navigationBar.backIndicatorTransitionMaskImage = image
        
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

// MARK: - Left Button

public extension NavigationBarUtil {
    
    public static func setLeftButton(with object: Any?, andAction action: Selector, for target: UIViewController) {
        guard let leftButton = barButton(with: object, action: action, for: target) else {
            return
        }
        
        target.navigationItem.leftBarButtonItem = leftButton
    }
    
    public static func setLeftButtons(with objects: [Any?], andActions actions: [Selector], for target: UIViewController) {
        guard objects.count == actions.count else {
            return
        }
        
        var leftBarButtons = [UIBarButtonItem]()
        
        for i in 0 ..< objects.count {
            guard let leftBarButton = barButton(with: objects[i], action: actions[i], for: target) else {
                continue
            }
            leftBarButtons.append(leftBarButton)
        }
        
        target.navigationItem.leftBarButtonItems = leftBarButtons
    }
    
    public static func setLeftImage(_ image: UIImage?, for viewController: UIViewController) {
        guard let image = image else {
            return
        }
        
        let leftButton = UIBarButtonItem(image: image.withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
        leftButton.isEnabled = false
        
        viewController.navigationItem.leftBarButtonItem = leftButton
    }
}

// MARK: - Right Button

public extension NavigationBarUtil {
    
    public static func setRightButton(with object: Any?, andAction action: Selector, for target: UIViewController) {
        guard let rightButton = barButton(with: object, action: action, for: target) else {
            return
        }
        
        target.navigationItem.rightBarButtonItem = rightButton
    }
    
    public static func setRightButtons(with objects: [Any?], andActions actions: [Selector], for target: UIViewController) {
        guard objects.count == actions.count else {
            return
        }
        
        var rightBarButtons = [UIBarButtonItem]()
        
        for i in 0 ..< objects.count {
            guard let rightBarButton = barButton(with: objects[i], action: actions[i], for: target) else {
                continue
            }
            rightBarButtons.append(rightBarButton)
        }
        
        target.navigationItem.rightBarButtonItems = rightBarButtons
    }
    
    public static func setRightImage(_ image: UIImage?, for viewController: UIViewController) {
        guard let image = image else {
            return
        }
        
        let rightButton = UIBarButtonItem(image: image.withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
        rightButton.isEnabled = false
        
        viewController.navigationItem.rightBarButtonItem = rightButton
    }
}
