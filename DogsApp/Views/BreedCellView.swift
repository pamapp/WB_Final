//
//  BreedCellView.swift
//  DogsApp
//
//  Created by Alina Potapova on 31.07.2024.
//

import SwiftUI
import DogsAPI

extension BreedCellView {
    enum Constants {
        static let opacity: CGFloat = 0.4
        static let cornerRadius: CGFloat = 16
        static let padding: CGFloat = 16
    }
}

struct BreedCellView: View {
    @EnvironmentObject var router: Router
    
    var breed: Breed
    var cellSize: (width: CGFloat, height: CGFloat)
    
    var body: some View {
        ZStack(alignment: .leading) {
            breedImageView
            
            Color.black.opacity(Constants.opacity)
            
            breedName
        }
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        .contentShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }
}

// MARK: - Subviews

extension BreedCellView {
    private var breedImageView: some View {
        BreedImageView(
            urlString: breed.image,
            imageSize: (width: cellSize.width, height: cellSize.height)
        )
    }
    
    private var breedName: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            Text(breed.name)
                .font(.headline)
                .foregroundStyle(.white)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, Constants.padding)
                .padding(.bottom, Constants.padding)
        }
    }
}
