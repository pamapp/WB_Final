//
//  CommandsView.swift
//
//
//  Created by Alina Potapova on 14.08.2024.
//

import SwiftUI

public struct CommandsView<Item: Identifiable, Icon: View>: View {
    private var items: [Item]
    private var iconBuilder: (Item) -> Icon
    private var titleBuilder: (Item) -> Text
    private var action: (Item) -> Void

    public init(
        items: [Item],
        iconBuilder: @escaping (Item) -> Icon,
        titleBuilder: @escaping (Item) -> Text,
        action: @escaping (Item) -> Void
    ) {
        self.items = items
        self.iconBuilder = iconBuilder
        self.titleBuilder = titleBuilder
        self.action = action
    }
    
    public var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(items) { item in
                    button(for: item)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 30)
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .background(Color.theme.white)
        }
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder
    private func button(for item: Item) -> some View {
        Button(action: { action(item) }) {
            HStack {
                iconBuilder(item)
                titleBuilder(item)
            }
        }
        .buttonStyle(CommandButtonStyle())
    }
}
