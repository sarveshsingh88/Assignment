//
//  DateFormater.swift
//  NewsReader
//
//  Created by Sarvesh on 25/09/24.
//

import Foundation


class DateFormater {
    
    
    class func getDate(from string: String) -> String {
        
        let dateString = string//"2024-09-22T13:37:00Z"
        var outputDate: String = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // Input format
        if let date = dateFormatter.date(from: dateString) {
            // Create another DateFormatter to format the date to the desired format
            dateFormatter.dateFormat = "dd-MMM-yyyy" // Desired output format
            let formattedDate = dateFormatter.string(from: date)
            print(formattedDate) // Output: 22-Sep-2024
            outputDate = formattedDate
        } else {
            print("Invalid date format")
            outputDate = ""
        }
        return outputDate
    }
}
