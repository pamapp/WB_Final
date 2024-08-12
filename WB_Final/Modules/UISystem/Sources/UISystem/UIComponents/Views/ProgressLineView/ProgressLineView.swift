//
//  ProgressLineView.swift
//
//
//  Created by Alina Potapova on 12.08.2024.
//

import SwiftUI

public struct ProgressLineView: View {
    var progress: CGFloat
    var color: Color
    
    public init(progress: CGFloat, color: Color) {
        self.progress = progress
        self.color = color
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(.gray)
                
                Rectangle()
                    .frame(width: geometry.size.width * progress, height: geometry.size.height)
                    .foregroundColor(color)
                    .cornerRadius(45.0)
            }
            .cornerRadius(45.0)
        }
    }
}
