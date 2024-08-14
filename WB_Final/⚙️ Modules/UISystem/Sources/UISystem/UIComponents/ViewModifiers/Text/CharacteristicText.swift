//
//  CharacteristicText.swift
//
//
//  Created by Alina Potapova on 12.08.2024.
//

import SwiftUI

public struct CharacteristicText: ViewModifier {
    private var color: Color
    
    public init(color: Color) {
        self.color = color
    }
    
    public func body(content: Content) -> some View {
        content
            .font(.subheading2())
            .foregroundColor(color)
            .multilineTextAlignment(.trailing)
    }
}
