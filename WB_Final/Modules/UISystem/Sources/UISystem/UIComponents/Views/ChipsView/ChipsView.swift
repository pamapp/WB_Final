//
//  ChipsView.swift
//
//
//  Created by Alina Potapova on 12.08.2024.
//

import SwiftUI

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
                            .padding([.horizontal, .vertical], 4)
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
        .frame(height: totalHeight).padding(.trailing, 8)
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
        .padding(10)
        .background(Color.theme.offWhite)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .frame(height: 44)
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
