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
    }
}
