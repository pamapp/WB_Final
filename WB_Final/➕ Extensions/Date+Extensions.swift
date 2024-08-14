//
//  Date+Extensions.swift
//  WB_Final
//
//  Created by Alina Potapova on 10.08.2024.
//

import Foundation

extension Date {
    func dateToString(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: self)
    }
}
