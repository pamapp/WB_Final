//
//  ParallaxHeader.swift
//
//
//  Created by Alina Potapova on 12.08.2024.
//

import SwiftUI

public struct ParallaxHeader<Content: View, Space: Hashable>: View {
    private let content: () -> Content
    private let coordinateSpace: Space
    private let defaultHeight: CGFloat
    
    public init(
        coordinateSpace: Space,
        defaultHeight: CGFloat,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
        self.coordinateSpace = coordinateSpace
        self.defaultHeight = defaultHeight
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let frame = geometry.frame(in: .named(coordinateSpace))
            let size = geometry.size

            let minY = frame.minY
            let additionalHeight = max(0, minY)
            
            content()
                .edgesIgnoringSafeArea(.horizontal)
                .frame(width: size.width, height: size.height + additionalHeight)
                .offset(y: -minY * 0.8)
                .scaleEffect(calculateScale(minY: minY, additionalHeight: additionalHeight))
                .blur(radius: calculateBlurRadius(minY: minY))
        }
        .frame(height: defaultHeight)
    }
    
    private func calculateScale(minY: CGFloat, additionalHeight: CGFloat) -> CGFloat {
        minY >= 0 ? 1 + additionalHeight / defaultHeight : 1
    }
    
    private func calculateBlurRadius(minY: CGFloat) -> CGFloat {
        minY < 0 ? min(-minY / 20, 5) : 0
    }
}
