//
//  Commands.swift
//  WB_Final
//
//  Created by Alina Potapova on 14.08.2024.
//

import Foundation
import SwiftUI

enum Commands: Equatable, Identifiable {
    case favorite
    case all(Bool)
    case heaviest(Bool)
    case tallest(Bool)
    case search(String)
    
    var id: Self { self }
    
    var name: String {
        switch self {
        case .all: "All"
        case .favorite: "Favorite"
        case .heaviest(let ascending): ascending ? "Heaviest" : "Lightest"
        case .tallest(let ascending): ascending ? "Tallest" : "Smallest"
        default: ""
        }
    }
    
    var icon: some View {
        switch self {
        case .all(let ascending):
            AnyView(Text(ascending ?"↗" : "↘"))
        case .favorite:
            AnyView(Image(UI.Icons.heart))
        case .heaviest(let ascending):
            AnyView(Text(ascending ? "🪨" : "🎈"))
        case .tallest(let ascending):
            AnyView(Text(ascending ?"↗" : "↘"))
        default: 
            AnyView(EmptyView())
        }
    }
}

extension Commands: CaseIterable, Hashable {
    static var allCases: [Commands] {
        return [.favorite, .all(true), .all(false), .heaviest(true), .heaviest(false), .tallest(true), .tallest(false)]
    }
}
