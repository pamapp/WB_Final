//
//  ParallaxHeader.swift
//
//
//  Created by Alina Potapova on 12.08.2024.
//

import SwiftUI

public struct ParallaxHeader<Content: View, Space: Hashable>: View {
    let content: () -> Content
    let coordinateSpace: Space
    let defaultHeight: CGFloat

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
        GeometryReader { proxy in
            let frame = proxy.frame(in: .named(coordinateSpace))
            let minY = frame.minY
            let heightModifier = heightModifier(for: proxy)
            
            let blurRadius: CGFloat = minY < 0 ? min(-minY / 10, 5) : 0
            let scale: CGFloat = minY >= 0 ? 1 + heightModifier / defaultHeight : 1
            
            content()
                .edgesIgnoringSafeArea(.horizontal)
                .frame(
                    width: proxy.size.width,
                    height: proxy.size.height + heightModifier
                )
                .offset(y: -minY * 0.8)
                .scaleEffect(scale, anchor: .center)
                .blur(radius: blurRadius)
        }
        .frame(height: defaultHeight)
    }
    
    private func heightModifier(for proxy: GeometryProxy) -> CGFloat {
        let frame = proxy.frame(in: .named(coordinateSpace))
        return max(0, frame.minY)
    }
}
