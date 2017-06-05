//
//  Preferences.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 05/06/17.
//
//

import UIKit

///Class responsible for saving information at `UserDefaults.standard`.
public class Preferences {
    
    //MARK: - Get
    
    ///Returns the standard UserDefaults reference.
    static public func getStandard() -> UserDefaults {
        return UserDefaults.standard
    }
    
    //MARK: - Synchronize
    
    static public func synchronize() {
        getStandard().synchronize()
    }
    
    //MARK: - String
    
    static public func setString(_ string: String, forKey key: String) {
        getStandard().set(string, forKey: key)
        synchronize()
    }
    
    static public func string(forKey key: String) -> String {
        if let s = getStandard().string(forKey: key) {
            return s
        }
        return ""
    }
    
    //MARK: - Int
    
    static public func setInteger(_ int: Int, forKey key: String) {
        getStandard().set(int, forKey: key)
        synchronize()
    }
    
    static public func int(forKey key: String) -> Int {
        let i = getStandard().integer(forKey: key)
        return i
    }
    
    //MARK: - Float
    
    static public func setFloat(_ float: Float, forKey key: String) {
        getStandard().set(float, forKey: key)
        synchronize()
    }
    
    static public func float(forKey key: String) -> Float {
        let f = getStandard().float(forKey: key)
        return f
    }
    
    //MARK: - Double
    
    static public func setDouble(_ double: Double, forKey key: String) {
        getStandard().set(double, forKey: key)
        synchronize()
    }
    
    static public func double(forKey key: String) -> Double {
        let d = getStandard().double(forKey: key)
        return d
    }
    
    //MARK: - Boolean
    
    static public func setBool(_ bool: Bool, forKey key: String) {
        getStandard().set(bool, forKey: key)
        synchronize()
    }
    
    static public func boolean(forKey key: String) -> Bool {
        let b = getStandard().bool(forKey: key)
        return b
    }
    
    //MARK: - Object
    
    static public func setObject(_ object: Any, forKey key: String) {
        let objectData = NSKeyedArchiver.archivedData(withRootObject: object)
        getStandard().set(objectData, forKey: key)
        synchronize()
    }
    
    static public func object(forKey key: String) -> Any? {
        if let data = getStandard().object(forKey: key) as? Data {
            let o = NSKeyedUnarchiver.unarchiveObject(with: data)
            return o
        }
        return nil
    }
    
    //MARK: - Clear
    
    ///Deltes all information saved.
    static public func clearAll() {
        guard let appDomain = Bundle.main.bundleIdentifier else {
            MochaLogger.log("Unable to find reference to the application's bundleIdentifier.")
            return
        }
        
        getStandard().removePersistentDomain(forName: appDomain)
    }
}
