//
//  AttachmentImageView.swift
//  WB_Final
//
//  Created by Alina Potapova on 10.08.2024.
//

import SwiftUI
import ExyteChat

struct AttachmentImageView: View {
    var attachment: Attachment
    var imageSize: (width: CGFloat?, height: CGFloat?)
    var cornerRadius: CGFloat

    var body: some View {
        AsyncImage(url: attachment.thumbnail) { phase in
            switch phase {
            case .empty:
                HStack {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(width: imageSize.width, height: imageSize.height)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageSize.width, height: imageSize.height)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            default:
                Image(systemName: "photo")
            }
        }
    }
}
