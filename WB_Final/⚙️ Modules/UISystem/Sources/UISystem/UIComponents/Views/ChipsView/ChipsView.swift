//
//  ChipsView.swift
//
//
//  Created by Alina Potapova on 12.08.2024.
//

import SwiftUI

public extension ChipsView {
    enum Constants {
        static var trailingPadding: CGFloat = 8
        static var bottomPadding: CGFloat = 4
        static var chipCornerRadius: CGFloat = 16
        static var chipHeight: CGFloat = 44
        static var chipPadding: CGFloat = 10
    }
}

public struct ChipsView: View {
    @State private var totalHeight: CGFloat = CGFloat.zero
    private var values: [String]
    
    public init(values: [String]) {
        self.values = values
    }
    
    public var body: some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        VStack(spacing: 0) {
            GeometryReader { geometry in
                ZStack(alignment: .topLeading) {
                    ForEach(Array(values.enumerated()), id: \.element) { index, word in
                        chipItem(value: word)
                            .padding(.trailing, Constants.trailingPadding)
                            .padding(.bottom, Constants.bottomPadding)
                            .alignmentGuide(.leading, computeValue: { d in
                                if (abs(width - d.width) > geometry.size.width) {
                                    width = 0
                                    height -= d.height
                                }
                                let result = width
                                if index == values.count - 1 {
                                    width = 0
                                } else {
                                    width -= d.width
                                }
                                return result
                            })
                            .alignmentGuide(.top, computeValue: { d in
                                let result = height
                                if index == values.count - 1 {
                                    height = 0
                                }
                                return result
                            })
                    }
                }
                .background(viewHeightReader($totalHeight))
            }
        }
        .frame(height: totalHeight)
    }
}

extension ChipsView {
    private func chipItem(value: String) -> some View {
        HStack {
            Text(("\(value)").capitalized)
                .font(.subheading2())
                .foregroundColor(Color.theme.active)
                .lineLimit(1)
        }
        .padding(Constants.chipPadding)
        .background(Color.theme.offWhite)
        .clipShape(RoundedRectangle(cornerRadius: Constants.chipCornerRadius))
        .frame(height: Constants.chipHeight)
    }
}

extension ChipsView {
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}
