//
//  CommandFieldStyle.swift
//
//
//  Created by Alina Potapova on 13.08.2024.
//

import SwiftUI

public struct CommandFieldStyle: TextFieldStyle {
    public init() {}
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.bodyText1())
            .foregroundColor(Color.theme.active)
            .padding([.vertical, .horizontal], 8)
            .background(Color.theme.offWhite)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
