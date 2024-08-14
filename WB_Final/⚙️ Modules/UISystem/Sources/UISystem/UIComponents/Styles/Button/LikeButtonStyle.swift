//
//  LikeButtonStyle.swift
//  
//
//  Created by Alina Potapova on 12.08.2024.
//

import SwiftUI

public struct LikeButtonStyle: ButtonStyle {
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.theme.offWhite)
            .frame(width: 64, height: 64)
            .overlay(
                Circle()
                    .fill(Color.theme.white)
                    .frame(width: 36, height: 36)
                    .overlay(configuration.label)
            )
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.bouncy(duration: 0.2), value: configuration.isPressed)
    }
}
