//
//  View+Extensions.swift
//  WB_Final
//
//  Created by Alina Potapova on 12.08.2024.
//

import SwiftUI
import UISystem

extension View {
    func characteristicSectionStyle() -> some View {
        self.modifier(CharacteristicSection())
    }
}

extension View {
    
    // - MARK: Text Modifiers
    
    func breedDetailTitle() -> some View {
        self.modifier(BreedDetailTitle())
    }
    
    func characteristicTitleStyle() -> some View {
        self.modifier(CharacteristicTitle())
    }
    
    func characteristicTextStyle(color: Color) -> some View {
        self.modifier(CharacteristicText(color: color))
    }
}
