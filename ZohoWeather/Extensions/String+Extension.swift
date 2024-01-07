//
//  String+Extension.swift
//  ZohoWeather
//
//  Created by Yuvaraj Selvam on 06/01/24.
//

import Foundation

/**
 String+Extension

 An extension for the String class providing utility methods.
 */
extension String {
/**
     Converts the string to a Date object using the specified date format.
     
     - Parameters:
        - format: A string representing the date format of the string.
     
     - Returns: A Date object representing the parsed date from the string, or nil if conversion fails.
     */
    func toDate(withFormat format: String) -> Date? {
        let dateFormatter = DateUtils.formatter
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}
