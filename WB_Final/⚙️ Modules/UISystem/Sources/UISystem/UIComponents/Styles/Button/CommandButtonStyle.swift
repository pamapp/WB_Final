//
//  CommandButtonStyle.swift
//
//
//  Created by Alina Potapova on 14.08.2024.
//

import SwiftUI

public struct CommandButtonStyle: ButtonStyle {
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.bodyText1())
            .foregroundColor(Color.theme.active)
            .padding([.vertical, .horizontal], 8)
            .background(Color.theme.offWhite)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
