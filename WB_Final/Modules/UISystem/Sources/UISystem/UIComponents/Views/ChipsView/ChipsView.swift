//
//  ChipsView.swift
//
//
//  Created by Alina Potapova on 12.08.2024.
//

import SwiftUI

extension ChipsView {
    private enum Constants {
        static let bottomPadding: CGFloat = 8
        static let trailingPadding: CGFloat = 4
        static let chipCornerRadius: CGFloat = 16
        static let chipHeight: CGFloat = 44
        static let chipPadding: CGFloat = 10

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
                            .padding(.trailing, 8)
                            .padding(.bottom, 4)
                            .alignmentGuide(.leading, computeValue: { d in
                                let isLastItem = index == values.count - 1
                                let exceedsWidth = abs(width - d.width) > geometry.size.width
                                
                                switch (exceedsWidth, isLastItem) {
                                case (true, _):
                                    width = 0
                                    height -= d.height
                                    return 0
                                case (false, true):
                                    let result = width
                                    width = 0
                                    return result
                                case (false, false):
                                    let result = width
                                    width -= d.width
                                    return result
                                }
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
