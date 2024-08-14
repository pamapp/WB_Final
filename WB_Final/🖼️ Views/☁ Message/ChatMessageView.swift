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
        static let fontSize: CGFloat = 14
        static let imageHeight: CGFloat = 150
        static let imageCornerRadius: CGFloat = 4
        static let likeSize: CGFloat = 26
        static let spacing: CGFloat = 12
        static let padding: CGFloat = 10
        static let topCornerRadius: CGFloat = 16
    }
}

struct ChatMessageView: View {
    @EnvironmentObject var fetchedBreeds: DogBreedService
    @EnvironmentObject var breedMessageManager: BreedMessageManager

    var message: Message
    var positionInUserGroup: PositionInUserGroup
    var tapLike: () -> ()

    private var isCurrentUser: Bool {
        message.user.isCurrentUser
    }
    
    private var isBreedFavorite: Bool {
        return fetchedBreeds.isBreedFavorite(breedMessageManager.getImageId(for: message.id))
    }
    
    private var topPadding: CGFloat {
        positionInUserGroup == .single || positionInUserGroup == .first ? 12 : 6
    }
    
    private var bottomPadding: CGFloat {
        positionInUserGroup == .single || positionInUserGroup == .last ? 12 : 6
    }
    
    private var leadingPadding: CGFloat {
        isCurrentUser ? 77 : 16
    }
    
    private var trailingPadding: CGFloat {
        isCurrentUser ? 16 : 77
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
    
    private var backgroundColor: Color {
        isCurrentUser ? Color.theme.defaultColor : Color.theme.white
    }
    
    private var messageStatusText: String {
        switch message.status {
        case .read: UI.Strings.read
        default: UI.Strings.error
        }
    }
    
    var body: some View {
        VStack(alignment: messageContentAlignment, spacing: Constants.spacing) {
            imagesView
            
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
    private var like: some View {
        switch isCurrentUser {
        case false:
            if isBreedFavorite {
                Circle()
                    .fill(Color.theme.offWhite)
                    .frame(width: Constants.likeSize, height: Constants.likeSize)
                    .overlay(Image(UI.Icons.heart))
            }
        case true:
            EmptyView()
        }
    }
    
    private var actionRow: some View {
        Button(action: tapLike) {
            Label(
                isBreedFavorite ? UI.Strings.removeFav :  UI.Strings.addFav,
                systemImage: isBreedFavorite ? UI.Icons.heartFill : UI.Icons.heart
            )
        }
    }
    
    private var createdAtView: some View {
        Text("\(message.createdAt.dateToString("HH:mm")) · \(messageStatusText)")
            .font(.caption2)
            .foregroundColor(timeColor)
    }
}
