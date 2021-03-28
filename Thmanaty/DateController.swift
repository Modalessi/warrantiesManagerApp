//
//  DateController.swift
//  Thmanat
//
//  Created by Mohammed Alessi on 27/01/1442 AH.
//  Copyright © 1442 Mohammed Alessi. All rights reserved.
//

import Foundation

class DateController {
    
    let calander = Calendar.current
    
    
    // convert date to a readable string
    func stringFromDate(date: Date)-> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let stringFromDate = dateFormatter.string(from: date)
        
        return stringFromDate
    }
    
    
    // add years  to another date
    func addToDate(date1: Date, years: Int?, months: Int?, days: Int?)-> Date {
        var dateComponents: DateComponents = DateComponents()
        
        if years != nil {
            dateComponents.year = years
        }
        if months != nil {
            dateComponents.month = months
        }
        if days != nil {
            dateComponents.day = days
        }
        
        let newDate = calander.date(byAdding: dateComponents, to: date1)
        
        return newDate!
    }
    
    // calculate days between dates
    func intervalBetweenDates(date1: Date, date2: Date)->Int{
        let days = calander.dateComponents([.day], from: calander.startOfDay(for: date1), to: calander.startOfDay(for: date2))
        
        return days.day!
    }
    
}
