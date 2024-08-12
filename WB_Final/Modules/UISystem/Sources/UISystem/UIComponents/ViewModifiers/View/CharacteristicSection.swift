//
//  CharacteristicSection.swift
//
//
//  Created by Alina Potapova on 12.08.2024.
//

import SwiftUI

public struct CharacteristicSection: ViewModifier {
    public init() {}
    
    public func body(content: Content) -> some View {
        content
            .padding(16)
            .background(Color.theme.offWhite)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
