//
//  Color+Extensions.swift
//
//
//  Created by Alina Potapova on 10.08.2024.
//

import SwiftUI

public extension Color {
    static let theme = ColorTheme()
}

public struct ColorTheme {
    
    //Brand Colors
    public let darkColor = Color("color_dark")
    public let defaultColor = Color("color_default")
    public let offWhite = Color("color_off_white")
    
    //Neutral
    public let white = Color("color_white")
    public let active = Color("color_active")
    public let disabled = Color("color_disabled")
    public let weakColor = Color("color_weak")
    
    //Accent
    public let success = Color("color_success")
    public let danger = Color("color_danger")
    public let warning = Color("color_warning")
    public let safe = Color("color_safe")
    
    public init() {}
}
