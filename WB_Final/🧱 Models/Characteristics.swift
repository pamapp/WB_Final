//
//  Characteristics.swift
//  WB_Final
//
//  Created by Alina Potapova on 12.08.2024.
//

import SwiftUI

enum Characteristics {
    case weight
    case height
    case lifeSpan
    case breedGroup
    case bredFor
    
    var emoji: String {
        switch self {
        case .height: "📏"
        case .weight: "⚖️"
        case .lifeSpan: "⏳"
        case .breedGroup: "🐶"
        case .bredFor: "🦮"
        }
    }
    
    var title: String {
        switch self {
        case .height: UI.Strings.height
        case .weight: UI.Strings.weight
        case .lifeSpan: UI.Strings.lifeSpan
        case .breedGroup: UI.Strings.breedGroup
        case .bredFor: UI.Strings.bredFor
        }
    }
    
    var color: Color? {
        switch self {
        case .height: Color.theme.safe
        case .weight: Color.theme.warning
        case .lifeSpan: Color.theme.success
        default: nil
        }
    }
}
