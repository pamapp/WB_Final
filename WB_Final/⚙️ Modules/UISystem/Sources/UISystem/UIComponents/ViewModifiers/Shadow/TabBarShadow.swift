//
//  TabBarShadow.swift
//
//
//  Created by Alina Potapova on 12.08.2024.
//

import SwiftUI

public struct TabBarShadow: ViewModifier {
    public init() {}
    
    public func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(0.04), radius: 20)
    }
}
