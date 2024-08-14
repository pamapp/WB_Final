//
//  ProgressLineView.swift
//
//
//  Created by Alina Potapova on 12.08.2024.
//

import SwiftUI

public extension ProgressLineView {
    enum Constants {
        static var lineOpacity: CGFloat = 0.3
        static var cornerRadius: CGFloat = 45
        static var animationDuration: CGFloat = 0.8
    }
}

public struct ProgressLineView: View {
    @State private var animatedProgress: CGFloat = 0

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
                    .opacity(Constants.lineOpacity)
                    .foregroundColor(.gray)
                
                Rectangle()
                    .frame(width: geometry.size.width * animatedProgress, height: geometry.size.height)
                    .foregroundColor(color)
                    .cornerRadius(Constants.cornerRadius)
            }
            .cornerRadius(Constants.cornerRadius)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: Constants.animationDuration)) {
                animatedProgress = progress
            }
        }
    }
}
