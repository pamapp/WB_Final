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
        static let textFieldCornerRadius: CGFloat = 8
        static let textFieldPadding: CGFloat = 8
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
    
    private var buttonAction: Void {
        switch inputViewState {
        case .empty:
            inputViewActionClosure(.recordAudioTap)
        default:
            inputViewActionClosure(.send)
        }
    }
    
    private var buttonIcon: String {
        switch inputViewState {
        case .empty, .isRecordingTap:
            UI.Icons.mic
        default:
            UI.Icons.paperplane
        }
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
                .padding(.horizontal, Constants.replyPadding)
                .padding(.top, Constants.replyPadding)
        }
    }
    
    @ViewBuilder
    private var mediaButton: some View {
        switch inputViewStyle {
        case .message:
            Button(action: {
                inputViewActionClosure(.photo)
            }) {
                Image(UI.Icons.plus)
                    .foregroundColor(Color.theme.disabled)
            }
            .padding(.vertical, Constants.buttonVerticalPadding)
        case .signature:
            EmptyView()
        }
    }
    
    private var textField: some View {
        TextField("Aa", text: $text, axis: textFieldAxis)
            .font(.bodyText1())
            .foregroundColor(Color.theme.active)
            .padding(.horizontal, Constants.textFieldPadding)
            .padding(.vertical, Constants.textFieldPadding)
            .background(Color.theme.offWhite)
            .clipShape(RoundedRectangle(cornerRadius: Constants.textFieldCornerRadius))

    }
    
    private var actionButton: some View {
        Button(action: { buttonAction }) {
            Image(buttonIcon)
                .foregroundColor(Color.theme.disabled)
                .background(
                    Circle()
                        .fill(inputViewState == .isRecordingTap ? Color.theme.defaultColor : Color.clear)
                        .scaleEffect(inputViewState == .isRecordingTap ? 1.5 : 1)
                        .animation(
                            inputViewState == .isRecordingTap ?
                            Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true) :
                                    .default,
                            value: inputViewState
                        )
                )
        }
        .padding(.vertical, Constants.buttonVerticalPadding)
    }
}
