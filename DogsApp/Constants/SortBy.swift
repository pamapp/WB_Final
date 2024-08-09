//
//  SortBy.swift
//  DogsApp
//
//  Created by Alina Potapova on 04.08.2024.
//

import SwiftUI

enum SortBy: CaseIterable {
    case name
    case weight
    case height
    case lifespan
    
    var string: String {
        switch self {
        case .name: return UI.Strings.name
        case .weight: return UI.Strings.weight
        case .height: return UI.Strings.height
        case .lifespan: return UI.Strings.lifeSpan
        }
    }
    
    func criteriaToInt(_ lifespan: String?) -> Int {
        guard let lifespan = lifespan else {
            return 1000
        }

        let regex = try! NSRegularExpression(pattern: "\\d+", options: [])
        let nsString = lifespan as NSString
        let results = regex.matches(in: lifespan, options: [], range: NSRange(location: 0, length: nsString.length))
        
        let numbers = results.compactMap { result in
            Int(nsString.substring(with: result.range))
        }
        
        return numbers.min() ?? 1000
    }
}
