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
        static let bottomPadding: CGFloat = 100
        static let offset: CGFloat = -30
        
        static let headerHeight: CGFloat = 270
        static let imageHeight: CGFloat = 300

        static let cornerRadius: CGFloat = 30
        
        static let barMainPadding: CGFloat = 24
        static let barTopPadding: CGFloat = 16
        
        static let scrollCoordinateSpace = "detailScroll"
    }
}

struct BreedDetailView: View {
    @EnvironmentObject var fetchedBreeds: FetchedBreeds
    @Environment(\.dismiss) private var dismiss

    var breed: Breed
    var tapLike: () -> ()

    private var isLiked: Bool {
        fetchedBreeds.isBreedFavorited(breed.referenceImageId)
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                breedImageView
                
                VStack(spacing: 0) {
                    breedInfoTitle
                        .padding(.bottom, Constants.spacing)
                    
                    basicCharacteristicsSection
                        .padding(.bottom, Constants.spacing)
                    
                    temperamentSection
                }
                .padding([.horizontal, .top], Constants.spacing)
                .background(Color.theme.white)
                .clipShape(
                    .rect(
                        topLeadingRadius: Constants.cornerRadius,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: Constants.cornerRadius
                    )
                )
                .offset(y: Constants.offset)
                .padding(.bottom, Constants.bottomPadding)
            }
            .coordinateSpace(name: Constants.scrollCoordinateSpace)
            
            bottomBar
        }
        .background(Color.theme.white)
        .ignoresSafeArea()
    }
}

// MARK: - Subviews

extension BreedDetailView {
    
    @ViewBuilder
    private var breedImageView: some View {
        if let image = breed.image, let url = URL(string: image) {
            ParallaxHeader(coordinateSpace: Constants.scrollCoordinateSpace, defaultHeight: Constants.headerHeight) {
                CachedAsyncImage(url: url, imageSize: (width: nil, height: Constants.imageHeight))
            }
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
        VStack(spacing: 10) {
            sectionTitle(UI.Strings.basicInfo)
            
            VStack(spacing: 16) {
                if let weight = breed.weight?.metric {
                    characteristicRow(characteristic: .weight, value: weight + UI.Strings.kg)
                }
                
                if let height = breed.height?.metric {
                    characteristicRow(characteristic: .height, value: height + UI.Strings.cm)
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
            VStack(spacing: 10) {
                sectionTitle(UI.Strings.temperament)
                
                ChipsView(values: temperament.components(separatedBy: ", "))
            }
        }
    }
    
    private func characteristicIcon(for emoji: String) -> some View {
        Circle()
            .fill(Color.theme.white)
            .frame(width: 36, height: 36)
            .overlay(
                Text(emoji)
                    .font(.metadata1())
            )
    }


    private func characteristicRow(characteristic: Characteristics, value: String) -> some View {
        VStack {
            HStack {
                characteristicIcon(for: characteristic.emoji)
                
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
    
    private var closeButton: some View {
        Button(action: { dismiss() }) {
            Text(UI.Strings.awesome)
                .font(.heading2())
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(AwesomeButtonStyle())
    }
    
    @ViewBuilder
    private var likeButton: some View {
        Button(action: tapLike) {
            switch isLiked {
            case true:
                Image(UI.Icons.heart)
            case false:
                Image(systemName: UI.Icons.heart)
                    .foregroundColor(Color.theme.defaultColor)
            }
        }
        .buttonStyle(LikeButtonStyle())
    }
    
    private var bottomBar: some View {
        VStack {
            Spacer()
            
            HStack {
                closeButton
                
                likeButton
            }
            .padding(.top, Constants.barTopPadding)
            .padding([.bottom, .horizontal], Constants.barMainPadding)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Color.theme.white)
            .tabBarShadow()
        }
    }
}
