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
    func tabBarShadow() -> some View {
        self.modifier(TabBarShadow())
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

public struct TabBarShadow: ViewModifier {
    public init() {}
    
    public func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(0.04), radius: 20)
    }
}


public struct AwesomeButtonStyle: ButtonStyle {
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 64)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(configuration.isPressed ? Color.theme.darkColor : Color.theme.defaultColor)
            )
    }
}
