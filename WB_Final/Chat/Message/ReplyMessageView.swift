//
//  ReplyMessageView.swift
//  WBApp
//
//  Created by Alina Potapova on 09.08.2024.
//

import SwiftUI
import ExyteChat
import UISystem

extension ReplyMessageView {
    private enum Constants {
        static let fontSize: CGFloat = 14
        static let imageSize: (width: CGFloat, height: CGFloat) = (30, 30)
        static let imageCornerRadius: CGFloat = 4
        static let replyLineWidth: CGFloat = 4
        static let spacing: CGFloat = 4
        static let padding: CGFloat = 8
        static let cornerRadius: CGFloat = 4
    }
}

struct ReplyMessageView: View {
    var reply: ReplyMessage
    var lineLimit: Int
    var isCurrentUser: Bool
    
    private var replyLineColor: Color {
        isCurrentUser ? Color.theme.white : Color.theme.defaultColor
    }
    
    private var replyBackgroundColor: Color {
        isCurrentUser ? Color.theme.darkColor : Color.theme.offWhite
    }
    
    var body: some View {
        HStack(spacing: 0) {
            lineView
            
            VStack(alignment: .leading, spacing: Constants.spacing) {
                userName
                
                userAttachments
                
                userTextMessage
            }
            .padding(Constants.padding)
            
            Spacer()
        }
        .background(replyBackgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        .fixedSize(horizontal: false, vertical: true)
    }
}

extension ReplyMessageView {
    private var lineView: some View {
        Rectangle()
            .foregroundColor(replyLineColor)
            .frame(width: Constants.replyLineWidth)
    }
    
    private var userName: some View {
        Text(reply.user.name)
            .foregroundStyle(replyLineColor)
            .font(.metadata3())
    }
    
    @ViewBuilder
    private var userTextMessage: some View {
        if !reply.text.isEmpty {
            Text(reply.text)
                .foregroundColor(isCurrentUser ? Color.white : Color.theme.active)
                .font(.bodyText2(Constants.fontSize))
                .lineLimit(lineLimit)
                .truncationMode(.tail)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    @ViewBuilder
    private var userAttachments: some View {
        if !reply.attachments.isEmpty {
            ForEach(reply.attachments, id: \.id) { attachment in
                CachedAsyncImage(
                    url: attachment.thumbnail,
                    imageSize: Constants.imageSize,
                    cornerRadius: Constants.imageCornerRadius
                )
            }
        }
    }
}
