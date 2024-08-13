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
    
    let attachments: InputViewAttachments
    let inputViewStyle: InputViewStyle
    let inputViewState: InputViewState
    let inputViewActionClosure: (InputViewAction) -> Void
   
    private var textFieldAxis: Axis {
        inputViewStyle == .message ? .vertical : .horizontal
    }
    
    var body: some View {
        VStack {
            replyContent
            
            HStack(alignment: .bottom, spacing: Constants.spacing) {
                mediaButton
                
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
    @ViewBuilder
    private var replyContent: some View {
        if let reply = attachments.replyMessage {
            ReplyMessageView(reply: reply, lineLimit: Constants.replyLineLimit, isCurrentUser: false)
                .padding([.top, .horizontal], Constants.replyPadding)
        }
    }
    
    @ViewBuilder
    private var mediaButton: some View {
        switch inputViewStyle {
        case .message:
            Button(action: { inputViewActionClosure(.photo) }) {
                Image(UI.Icons.plus)
                    .foregroundColor(Color.theme.disabled)
            }
            .padding(.vertical, Constants.buttonVerticalPadding)
        case .signature:
            EmptyView()
        }
    }
    
    private var textField: some View {
        TextField(UI.Strings.command, text: $text, axis: textFieldAxis)
            .textFieldStyle(CommandFieldStyle())
    }
    
    private var actionButton: some View {
        Button(action: { inputViewActionClosure(.send) }) {
            Image(UI.Icons.paperplane)
                .foregroundColor(inputViewState == .empty ? Color.theme.disabled : Color.theme.defaultColor)
                .scaleEffect(inputViewState == .empty ? 0.9 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: inputViewState)
        }
        .padding(.vertical, Constants.buttonVerticalPadding)
    }
}
