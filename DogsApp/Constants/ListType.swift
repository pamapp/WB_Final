//
//  ListType.swift
//  DogsApp
//
//  Created by Alina Potapova on 04.08.2024.
//

import SwiftUI

enum ListType: CaseIterable, Equatable {
    case all
    case favorites
    
    var string: String {
        switch self {
        case .all: return UI.Strings.all
        case .favorites: return UI.Strings.favorites
        }
    }
}
