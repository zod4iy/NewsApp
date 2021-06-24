//
//  Date+Extensions.swift
//  UptechTest
//
//  Created by Alex Kurylenko on 5/16/21.
//

import Foundation

extension Date {
    struct DateFormats {
        static let apiResponse = "yyyy-MM-dd'T'HH:mm:ssZZ"
    }
    
    static var dateFormatterApiResponse: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.apiResponse
        return dateFormatter
    }()
}
