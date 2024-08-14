//
//  NavigationBarView.swift
//
//  Created by Alina Potapova on 11.06.2024.
//

import SwiftUI

public struct NavigationBarView: View {
    var title: String?
    var leadingIcon: String?
    var trailingIcon: String?
    var leadingAction: (() -> ())?
    var trailingAction: (() -> ())?
    var additionalTrailingIcon: String?
    var additionalTrailingAction: (() -> Void)?
    
    public init(title: String? = nil,
                leadingIcon: String? = nil,
                trailingIcon: String? = nil,
                additionalTrailingIcon: String? = nil,
                leadingAction: ( () -> Void)? = nil,
                trailingAction: ( () -> Void)? = nil,
                additionalTrailingAction: ( () -> Void)? = nil
    ) {
        self.title = title
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.leadingAction = leadingAction
        self.trailingAction = trailingAction
        self.additionalTrailingIcon = additionalTrailingIcon
        self.additionalTrailingAction = additionalTrailingAction
    }
    
    public var body: some View {
        HStack {
            if let leadingIcon, let leadingAction {
                Button(action: { leadingAction() }, label: {
                    getImage(named: leadingIcon)
                        .foregroundColor(Color.theme.active)
                        .padding(.trailing, 8)
                })
            }
            
            if let title {
                Text(title)
                    .font(.subheading1())
                    .padding(.leading, leadingIcon != nil ? 0 : 8)
            }
            
            Spacer()

            if let trailingIcon, let trailingAction {
                Button(action: { trailingAction() }, label: {
                    getImage(named: trailingIcon)
                        .foregroundColor(Color.theme.active)
                })
            }
            
            if let additionalTrailingIcon, let additionalTrailingAction {
                Button(action: { additionalTrailingAction() }, label: {
                    getImage(named: additionalTrailingIcon)
                        .foregroundColor(Color.theme.active)
                })
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .background(Color.theme.white)
    }
}

extension NavigationBarView {
    @ViewBuilder
    private func getImage(named: String) -> some View {
        switch UIImage(systemName: named) != nil {
        case true:
            Image(systemName: named)
                .font(.system(size: 18, weight: .semibold))
        case false:
            Image(named)
        }
    }
}
