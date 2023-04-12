//
//  Date+Extension.swift
//  Premier League
//
//  Created by Sherif Kamal on 08/04/2023.
//

import Foundation

extension DateFormatter {
    static func formatUTCDateToString(_ utcDate: Date, fromDateFormat: String = "yyyy-MM-dd'T'HH:mm:ssZ", toDateFormat: String = "MMMM dd, yyyy") -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = fromDateFormat
        formatter.timeZone = TimeZone(identifier: "UTC")
        
        formatter.dateFormat = toDateFormat
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        formatter.timeZone = TimeZone.current
        
        let formattedDate = formatter.string(from: utcDate)
        return formattedDate
    }
    
    static func formatUTCTimeToString(_ utcDate: Date, fromDateFormat: String = "yyyy-MM-dd'T'HH:mm:ssZ", toDateFormat: String = "hh:mm") -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = fromDateFormat
        formatter.timeZone = TimeZone(identifier: "UTC")
        
        formatter.dateFormat = toDateFormat
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        
        let formattedDate = formatter.string(from: utcDate)
        return formattedDate
    }
    
    static func dateFormat(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.timeZone = TimeZone(identifier: "UTC")
        let formattedDate = formatter.date(from: dateString)
        return formattedDate
    }
}

