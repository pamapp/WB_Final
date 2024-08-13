//
//  AwesomeButtonStyle.swift
//
//
//  Created by Alina Potapova on 12.08.2024.
//

import SwiftUI

public struct AwesomeButtonStyle: ButtonStyle {
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 64)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(configuration.isPressed ? Color.theme.darkColor : Color.theme.defaultColor)
            )
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.bouncy(duration: 0.1), value: configuration.isPressed)
    }
}
