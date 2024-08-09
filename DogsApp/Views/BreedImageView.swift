//
//  BreedImageView.swift
//  DogsApp
//
//  Created by Alina Potapova on 31.07.2024.
//

import SwiftUI
import DogsAPI

struct BreedImageView: View {
    var urlString: String?
    var imageSize: (width: CGFloat?, height: CGFloat)

    var body: some View {
        AsyncImage(url: URL(string: urlString ?? ""), transaction: Transaction(animation: .default)) { phase in
            switch phase {
            case .success(let image):
                image
                    .interpolation(.low)
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageSize.width, height: imageSize.height)
            default:
                Image(systemName: UI.Icons.dog)
                    .frame(width: imageSize.width, height: imageSize.height)
                    .foregroundColor(.white)
            }
        }
    }
}
