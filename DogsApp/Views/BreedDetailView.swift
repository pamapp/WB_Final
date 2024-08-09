//
//  BreedDetailView.swift
//  DogsApp
//
//  Created by Alina Potapova on 31.07.2024.
//

import SwiftUI
import DogsAPI

extension BreedDetailView {
    enum Constants {
        static let spacing: CGFloat = 16
        static let navigationSpacing: CGFloat = 3
    }
}

struct BreedDetailView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var fetchedBreeds: FetchedBreeds

    @State private var isLiked: Bool = false

    var breed: Breed

    var body: some View {
        ScrollView {
            VStack(spacing: Constants.spacing) {
                breedImageView
                breedInfoTitle
                breedInfoGrid
                breedInfoView(title: UI.Strings.breedFor, value: breed.bredFor ?? "-")
                breedInfoView(title: UI.Strings.temperament, value: breed.temperament ?? "-")
            }
            .padding(.horizontal, Constants.spacing)
        }
        .onAppear(perform: checkIfLiked)
        .navigationTitle(breed.name)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                likeButton
            }
        }
    }
}

// MARK: - Subviews

extension BreedDetailView {
    private var breedImageView: some View {
        BreedImageView(
            urlString: breed.image,
            imageSize: (width: UIScreen.main.bounds.width - 32, height: 270)
        )
        .background(Color.black.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(.vertical, 16)
    }

    private var breedInfoTitle: some View {
        HStack {
            Text(UI.Strings.info)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)

            Spacer()
        }
    }

    private var breedInfoGrid: some View {
        VStack(spacing: Constants.spacing) {
            HStack(spacing: Constants.spacing) {
                breedInfoView(title: UI.Strings.weight, value: "\(breed.weight?.metric ?? "-") kg")
                breedInfoView(title: UI.Strings.height, value: "\(breed.height?.metric ?? "-") cm")
            }
            HStack(spacing: Constants.spacing) {
                breedInfoView(title: UI.Strings.lifeSpan, value: breed.lifeSpan ?? "-")
                breedInfoView(title: UI.Strings.breedGroup, value: breed.breedGroup ?? "-")
            }
        }
    }

    private func breedInfoView(title: String, value: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.indigo)
                Text(value)
                    .font(.subheadline)
            }
            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var backButton: some View {
        Button(action: { router.goBack() }) {
            HStack(spacing: Constants.navigationSpacing) {
                Image(systemName: UI.Icons.chevronLeft)
                    .foregroundColor(Color(UIColor.label))
                Text(UI.Strings.breeds)
                    .foregroundColor(Color(UIColor.label))
            }
        }
    }

    private var likeButton: some View {
        Button(action: toggleLikeStatus) {
            Image(systemName: isLiked ? "heart.fill" : "heart")
                .foregroundColor(isLiked ? .red : Color(UIColor.systemGray5))
                .font(.system(size: 20))
        }
    }
}

// MARK: - Actions

extension BreedDetailView {
    private func checkIfLiked() {
        isLiked = fetchedBreeds.favoriteBreeds.contains { $0.imageId == breed.referenceImageId }
    }

    private func toggleLikeStatus() {
        isLiked.toggle()
        
        Task {
            let success = isLiked ? await addFavorite() : await removeFavorite()
            if !success {
                isLiked.toggle()
            }
        }
    }

    private func addFavorite() async -> Bool {
        await fetchedBreeds.addFavorite(imageId: breed.referenceImageId ?? "", subId: "user")
    }

    private func removeFavorite() async -> Bool {
        guard let favorite = fetchedBreeds.favoriteBreeds.first(where: { $0.imageId == breed.referenceImageId }) else {
            return false
        }
        
        return await fetchedBreeds.removeFavorite(id: favorite.id)
    }
}
