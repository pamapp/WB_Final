//
//  CharacteristicTitle.swift
//
//
//  Created by Alina Potapova on 12.08.2024.
//

import SwiftUI

public struct CharacteristicTitle: ViewModifier {
    public init() {}
    
    public func body(content: Content) -> some View {
        content
            .font(.subheading1())
            .foregroundColor(Color.theme.active)
            .multilineTextAlignment(.leading)
    }
}
