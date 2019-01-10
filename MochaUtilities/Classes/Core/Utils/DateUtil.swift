//
//  DateUtil.swift
//  Pods
//
//  Created by Gregory Sholl e Santos on 18/07/17.
//
//

import UIKit

// MARK: - Date Components

public class DateUtil {
    
    public static func getDay(from date: Date, with calendar: Calendar = Calendar.current) -> Int {
        let day = calendar.component(.day, from: date)
        return day
    }
    
    public static func getMonth(from date: Date, with calendar: Calendar = Calendar.current) -> Int {
        let month = calendar.component(.month, from: date)
        return month
    }
    
    public static func getYear(from date: Date, with calendar: Calendar = Calendar.current) -> Int {
        let year = calendar.component(.year, from: date)
        return year
    }
}

// MARK: - Date

public extension DateUtil {
    
    public static func getDate(withDay day: Int, month: Int, year: Int, of calendar: Calendar = Calendar.current) -> Date? {
        let components = DateComponents(year: year, month: month, day: day)
        let date = calendar.date(from: components)
        return date
    }
    
    public static func getDate(from string: String?, with format: String = "dd/MM/yyyy") -> Date? {
        guard let string = string else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        let date = formatter.date(from: string)
        return date
    }
}

// MARK: - String

public extension DateUtil {
    
    public static func getString(from date: Date?, with format: String = "dd/MM/yyyy") -> String {
        guard let date = date else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        let string = formatter.string(from: date)
        return string
    }
    
    public static func getString(from date: Date?, with dateStyle: DateFormatter.Style, and timeStyle: DateFormatter.Style) -> String {
        guard let date = date else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        
        let string = formatter.string(from: date)
        return string
    }
}
