//
//  Date+Extension.swift
//  ZohoWeather
//
//  Created by Yuvaraj Selvam on 06/01/24.
//

import Foundation

/**
 Date+Extension

 An extension for the Date class providing utility methods.
 */
extension Date {
/**
     Converts the date to a string representation using the specified format.
     
     - Parameters:
        - format: A string representing the desired date format.
     
     - Returns: A string representation of the date in the specified format.
     */
    func toString(withFormat format: String) -> String {
        let dateFormatter = DateUtils.formatter
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
