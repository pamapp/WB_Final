//
//  String+Extensions.swift
//  WB_Final
//
//  Created by Андрей on 12.08.2024.
//

import Foundation

extension String {
    var criteriaToInt: Int {
        let regex = try! NSRegularExpression(pattern: "\\d+", options: [])
        let nsString = self as NSString
        let results = regex.matches(in: self, options: [], range: NSRange(location: 0, length: nsString.length))
        
        let numbers = results.compactMap { result in
            Int(nsString.substring(with: result.range))
        }
        
        return numbers.max() ?? 0
    }
}
