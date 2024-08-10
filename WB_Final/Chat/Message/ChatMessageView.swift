//
//  CustomChatMessageView.swift
//  WB_Final
//
//  Created by Alina Potapova on 06.08.2024.
//

import SwiftUI
import ExyteChat
import UISystem

extension ChatMessageView {
    private enum Constants {
        static let replyLineLimit: Int = 10
        static let fontSize: CGFloat = 14
        static let imageHeight: CGFloat = 150
        static let imageCornerRadius: CGFloat = 4
        static let recordingPadding: CGFloat = 16
        static let recordingCornerRadius: CGFloat = 16
        static let spacing: CGFloat = 12
        static let padding: CGFloat = 10
        static let topCornerRadius: CGFloat = 16
    }
}

struct ChatMessageView: View {
    var message: Message
    var positionInUserGroup: PositionInUserGroup
    
    private var isCurrentUser: Bool {
        message.user.isCurrentUser
    }
    
    private var topPadding: CGFloat {
        positionInUserGroup == .single || positionInUserGroup == .first ? 12 : 6
    }
    
    private var bottomPadding: CGFloat {
        positionInUserGroup == .single || positionInUserGroup == .last ? 12 : 6
    }
    
    private var messageAlignment: Alignment {
        isCurrentUser ? .trailing : .leading
    }
    
    private var messageContentAlignment: HorizontalAlignment {
        isCurrentUser ? .trailing : .leading
    }
    
    private var textAlignment: TextAlignment {
        isCurrentUser ? .trailing : .leading
    }
    
    private var leadingPadding: CGFloat {
        isCurrentUser ? 77 : 16
    }
    
    private var trailingPadding: CGFloat {
        isCurrentUser ? 16 : 77
    }
    
    private var leadingCornerRadius: CGFloat {
        isCurrentUser ? 16 : 0
    }
    
    private var trailingCornerRadius: CGFloat {
        isCurrentUser ? 0 : 16
    }
    
    private var textColor: Color {
        isCurrentUser ? Color.white : Color.theme.active
    }
    
    private var timeColor: Color {
        isCurrentUser ? Color.white : Color.theme.disabled
    }
    
    private var replyLineColor: Color {
        isCurrentUser ? Color.theme.white : Color.theme.defaultColor
    }
    
    private var replyBackgroundColor: Color {
        isCurrentUser ? Color.theme.darkColor : Color.theme.offWhite
    }
    
    private var backgroundColor: Color {
        isCurrentUser ? Color.theme.defaultColor : Color.theme.white
    }
    
    private var messageStatusText: String {
        switch message.status {
        case .sending: UI.Strings.sending
        case .sent: UI.Strings.send
        case .read: UI.Strings.read
        default: UI.Strings.error
        }
    }
    
    var body: some View {
        VStack(alignment: messageContentAlignment, spacing: Constants.spacing) {
            replyMessage
            
            imagesView
            
            recordingView
            
            textView
            
            createdAtView
        }
        .scaledToFit()
        .padding(Constants.padding)
        .background(backgroundColor)
        .clipShape(
            .rect(
                topLeadingRadius: Constants.topCornerRadius,
                bottomLeadingRadius: leadingCornerRadius,
                bottomTrailingRadius: trailingCornerRadius,
                topTrailingRadius: Constants.topCornerRadius
            )
        )
        .padding(.top, topPadding)
        .padding(.bottom, bottomPadding)
        .padding(.leading, leadingPadding)
        .padding(.trailing, trailingPadding)
        .frame(maxWidth: .infinity, alignment: messageAlignment)
    }
}

extension ChatMessageView {
    @ViewBuilder
    private var replyMessage: some View {
        if let reply = message.replyMessage {
            ReplyMessageView(reply: reply,
                             lineLimit: Constants.replyLineLimit,
                             isCurrentUser: isCurrentUser
            )
        }
    }
    
    @ViewBuilder
    private var textView: some View {
        if !message.text.isEmpty {
            Text(message.text)
                .foregroundColor(textColor)
                .font(.bodyText2(Constants.fontSize))
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    @ViewBuilder
    private var imagesView: some View {
        if !message.attachments.isEmpty {
            ForEach(message.attachments, id: \.id) { attachment in
                AttachmentImageView(attachment: attachment,
                                    imageSize: (nil, height: Constants.imageHeight),
                                    cornerRadius: Constants.imageCornerRadius
                )
            }
        }
    }
    
    @ViewBuilder
    private var recordingView: some View {
        if let recording = message.recording {
            RecordWaveView(
                recording: recording,
                colorButton: message.user.isCurrentUser ? Color.white : Color.theme.active,
                colorWaveform: message.user.isCurrentUser ? Color.white : Color.theme.active
            )
            .padding(Constants.recordingPadding)
            .background(replyBackgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 4))
        }
    }
    
    private var createdAtView: some View {
        Text("\(message.createdAt.dateToString("HH:mm")) · \(messageStatusText)")
            .foregroundColor(timeColor)
            .font(.caption2)
    }
}
