//
//  BreedDetailView.swift
//  WB_Final
//
//  Created by Alina Potapova on 11.08.2024.
//

import SwiftUI
import DogsAPI
import UISystem

extension BreedDetailView {
    enum Constants {
        static let spacing: CGFloat = 24
        static let navigationSpacing: CGFloat = 3
        static let cornerRadius: CGFloat = 30
        static let scrollCoordinateSpace = "detailScroll"
    }
}

struct BreedDetailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var fetchedBreeds: FetchedBreeds

    var breed: Breed
    var tapLike: () -> ()

    var body: some View {
        ZStack {
            ScrollView {
                breedImageView
                
                VStack(spacing: 0) {
                    breedInfoTitle
                        .padding(.bottom, 24)
                    
                    sectionTitle(UI.Strings.basicCharacteristics)
                        .padding(.bottom, 8)
                    
                    basicCharacteristicsSection
                        .padding(.bottom, 24)
                    
                    temperamentSection
                }
                .padding(.horizontal, Constants.spacing)
                .padding(.top, Constants.spacing)
                .background(Color.theme.white)
                .clipShape(
                    .rect(
                        topLeadingRadius: Constants.cornerRadius,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: Constants.cornerRadius
                    )
                )
                .offset(y: -30)
                .padding(.bottom, 96)
            }
            .coordinateSpace(name: Constants.scrollCoordinateSpace)
            
            bottomBar
        }
        .ignoresSafeArea()
    }
}

// MARK: - Subviews

extension BreedDetailView {
    private var bottomBar: some View {
        VStack {
            Spacer()
            
            HStack {
                closeButton
                
                likeButton
            }
            .padding(.top, 16)
            .padding(.bottom, 24)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Color.theme.white)
            .tabBarShadow()
        }
    }
    
    private var closeButton: some View {
        Button(action: { dismiss() }) {
            Text(UI.Strings.awesome)
                .font(.heading2())
                .foregroundColor(Color.theme.white)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(AwesomeButtonStyle())
    }
    
    private var likeButton: some View {
        Button(action: tapLike) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.theme.offWhite)
                .frame(width: 64, height: 64)
                .overlay(
                    Circle()
                        .fill(Color.theme.white)
                        .frame(width: 36, height: 36)
                        .overlay (
                            heart
                        )
                )
        }
    }
    
    @ViewBuilder
    private var breedImageView: some View {
        if let image = breed.image, let url = URL(string: image) {
            ParallaxHeader(coordinateSpace: Constants.scrollCoordinateSpace, defaultHeight: 270) {
                CachedAsyncImage(url: url, imageSize: (width: nil, height: 300), cornerRadius: 0)
            }
        }
    }
    
    @ViewBuilder
    private var heart: some View {
        switch fetchedBreeds.isBreedFavorited(breed.referenceImageId) {
        case true:
            Image(UI.Icons.heart)
        case false:
            Image(systemName: "heart")
                .foregroundColor(Color.theme.defaultColor)
        }
    }

    private var breedInfoTitle: some View {
        HStack {
            Text(breed.name)
                .breedDetailTitle()
            
            Spacer()
        }
    }

    private func sectionTitle(_ title: String) -> some View {
        HStack {
            Text(title)
                .characteristicTitleStyle()
            
            Spacer()
        }
    }
    
    private var basicCharacteristicsSection: some View {
        VStack(spacing: 16) {
            VStack(spacing: 16) {
                if let weight = breed.weight?.metric {
                    characteristicRow(characteristic: .weight, value: weight)
                }
                
                if let height = breed.height?.metric {
                    characteristicRow(characteristic: .height, value: height)
                }
                
                if let lifeSpan = breed.lifeSpan {
                    characteristicRow(characteristic: .lifeSpan, value: lifeSpan)
                }
            }
            .characteristicSectionStyle()
            
            if let breedGroup = breed.breedGroup {
                characteristicRow(characteristic: .breedGroup, value: breedGroup)
                    .characteristicSectionStyle()
            }
            
            if let bredFor = breed.bredFor {
                characteristicRow(characteristic: .bredFor, value: bredFor)
                    .characteristicSectionStyle()
            }
        }
    }
    
    @ViewBuilder
    private var temperamentSection: some View {
        if let temperament = breed.temperament {
            VStack(spacing: 8) {
                sectionTitle(UI.Strings.temperament)
                
                ChipsView(values: temperament.components(separatedBy: ", "))
            }
        }
    }

    private func characteristicRow(characteristic: Characteristics, value: String) -> some View {
        VStack {
            HStack {
                Circle()
                    .fill(Color.theme.white)
                    .frame(width: 36, height: 36)
                    .overlay(
                        Text(characteristic.emoji)
                            .font(.metadata1())
                    )
                
                Text(characteristic.title + ":")
                    .characteristicTextStyle(color: Color.theme.active)
                
                Spacer()
                
                Text(value)
                    .characteristicTextStyle(color: Color.theme.disabled)
            }
            
            if let color = characteristic.color {
                let maxValue = fetchedBreeds.maximumValue(for: characteristic)
                let progress = breed.progress(for: characteristic, maxValue: maxValue)
                
                ProgressLineView(progress: progress, color: color)
            }
        }
    }
}
