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
        
        static let linkStrokeWidth: CGFloat = 1.6
        static let linkHeight: CGFloat = 20
        static let linkWidth: CGFloat = 40

        static let linkImageSize: CGFloat = 10
    }
}

struct ChatMessageView: View {
    @EnvironmentObject var fetchedBreeds: FetchedBreeds

    var message: Message
    var positionInUserGroup: PositionInUserGroup
    var tapLike: () -> ()

    private var isCurrentUser: Bool {
        message.user.isCurrentUser
    }
    
    private var isBreedFavorite: Bool {
        fetchedBreeds.isBreedFavorite(message)
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
            
            HStack {
                createdAtView
                
                Spacer()
                
                like
            }
        }
        .scaledToFit()
        .padding(Constants.padding)
        .background(backgroundColor)
        .contextMenu { actionRow }
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
        switch message.replyMessage {
        case .some(let reply):
            ReplyMessageView(
                reply: reply,
                lineLimit: Constants.replyLineLimit,
                isCurrentUser: isCurrentUser
            )
        case .none:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private var textView: some View {
        switch message.text.isEmpty {
        case false:
            Text(message.text)
                .foregroundColor(textColor)
                .font(.bodyText2(Constants.fontSize))
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        case true:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private var imagesView: some View {
        switch message.attachments.isEmpty {
        case false:
            ForEach(message.attachments, id: \.id) { attachment in
                CachedAsyncImage(
                    url: attachment.thumbnail,
                    imageSize: (nil, height: Constants.imageHeight),
                    cornerRadius: Constants.imageCornerRadius
                )
            }
        case true:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private var recordingView: some View {
        switch message.recording {
        case .some(let recording):
            RecordWaveView(
                recording: recording,
                colorButton: message.user.isCurrentUser ? Color.white : Color.theme.active,
                colorWaveform: message.user.isCurrentUser ? Color.white : Color.theme.active
            )
            .padding(Constants.recordingPadding)
            .background(replyBackgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 4))
        case .none:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private var like: some View {
        switch isCurrentUser {
        case false:
            if isBreedFavorite {
                Circle()
                    .fill(Color.theme.offWhite)
                    .frame(width: 26, height: 26)
                    .overlay(Image(UI.Icons.heart))
            }
        case true:
            EmptyView()
        }
    }
    
    private var actionRow: some View {
        Button(action: tapLike) {
            Label(isBreedFavorite ? "Remove from favorites" : "Add to favorites", systemImage: isBreedFavorite ? "heart.fill" : "heart")
        }
    }
    
    private var createdAtView: some View {
        Text("\(message.createdAt.dateToString("HH:mm")) · \(messageStatusText)")
            .foregroundColor(timeColor)
            .font(.caption2)
    }
}
