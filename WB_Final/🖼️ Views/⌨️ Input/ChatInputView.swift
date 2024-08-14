//
//  CustomInputView.swift
//  WBApp
//
//  Created by Alina Potapova on 05.08.2024.
//

import SwiftUI
import UISystem
import ExyteChat

extension ChatInputView {
    private enum Constants {
        static let replyLineLimit: Int = 1
        static let spacing: CGFloat = 12
        static let buttonVerticalPadding: CGFloat = 6
        static let replyPadding: CGFloat = 16
        static let mainVerticalPadding: CGFloat = 10
    }
}

struct ChatInputView: View {
    @Binding var text: String
    
    var commandSectionView: (() -> AnyView)?
    let attachments: InputViewAttachments
    let inputViewStyle: InputViewStyle
    let inputViewState: InputViewState
    let inputViewActionClosure: (String) -> Void
   
    private var textFieldAxis: Axis {
        inputViewStyle == .message ? .vertical : .horizontal
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if let builder = commandSectionView {
                builder()
            }
            
            HStack(alignment: .bottom, spacing: Constants.spacing) {
                textField
                
                actionButton
            }
            .padding(.horizontal, Constants.spacing)
            .padding(.vertical, Constants.mainVerticalPadding)
        }
        .background(Color.theme.white)
    }
}

extension ChatInputView {
    
    private var textField: some View {
        TextField(UI.Strings.command, text: $text, axis: textFieldAxis)
            .textFieldStyle(CommandFieldStyle())
    }
    
    private var actionButton: some View {
        Button(action: { inputViewActionClosure(text) }) {
            Image(UI.Icons.paperplane)
                .foregroundColor(inputViewState == .empty ? Color.theme.disabled : Color.theme.defaultColor)
                .scaleEffect(inputViewState == .empty ? 0.9 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: inputViewState)
        }
        .padding(.vertical, Constants.buttonVerticalPadding)
    }
}

extension ChatInputView {
    func commandSectionView<V: View>(_ builder: @escaping ()->V) -> ChatInputView {
        var view = self
        view.commandSectionView = {
            AnyView(builder())
        }
        return view
    }
}
