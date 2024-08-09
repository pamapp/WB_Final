//
//  BreedsScreen.swift
//  DogsApp
//
//  Created by Alina Potapova on 30.07.2024.
//

import SwiftUI
import DogsAPI

extension BreedsScreen {
    enum Constants {
        static let columns = 2
        static let spacing: CGFloat = 16
        static let verticalPadding: CGFloat = 8
        static let buttonPaddingHorizontal: CGFloat = 10
        static let buttonPaddingVertical: CGFloat = 4
        static let cornerRadius: CGFloat = 8
        static let cellWidthRatio: CGFloat = 24
        static let cellHeight: CGFloat = 200
    }
}

struct BreedsScreen: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var fetchedBreeds: FetchedBreeds

    @State var listType: ListType = .all
    @State var sortBy: SortBy = .name
    @State var searchText: String = ""
    
    var body: some View {
        VStack {
            ScrollView {
                listTypePickerView
                
                sortByView
                    .padding(.vertical, Constants.verticalPadding)
                
                switch fetchedBreeds.isLoading {
                case true:
                    ProgressView()
                case false:
                    LazyVGrid(columns: Array(repeating: .init(spacing: Constants.spacing), count: Constants.columns), spacing: Constants.spacing) {
                        breedListView(type: listType)
                    }
                }
            }
            .padding(.horizontal)
            .scrollIndicators(.hidden)
            .searchable(text: $searchText)
            .task {
                fetchedBreeds.loadBreeds { data, error in
                    fetchedBreeds.breeds = data ?? []
                }
               
                fetchedBreeds.loadFavorites { data, error in
                    fetchedBreeds.favoriteBreeds = data ?? []
                }
            }
        }
        .navigationTitle(UI.Strings.dogBreeds)
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: - Subviews

extension BreedsScreen {
    private var listTypePickerView: some View {
        Picker("", selection: $listType) {
            ForEach(ListType.allCases, id: \.self) { type in
                Text(type.string).tag(type)
            }
        }
        .pickerStyle(.segmented)
    }
    
    private var sortByView: some View {
        HStack {
            Text(UI.Strings.sortBy)
                .font(.headline)
            
            Spacer()
            
            Picker("", selection: $sortBy) {
                ForEach(SortBy.allCases, id: \.self) { criteria in
                   Text(criteria.string).tag(criteria)
               }
            }
            .pickerStyle(.menu)
            .accentColor(.white)
            .background(Color.indigo.clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius)))
        }
    }
    
    private func breedListView(type: ListType) -> some View {
        let breedsToShow: [Breed]
        
        switch type {
        case .all:
            breedsToShow = fetchedBreeds.breeds
                .filtered(by: searchText)
                .sorted(by: sortBy)
        case .favorites:
            breedsToShow = fetchedBreeds.breeds
                .favoriteBreeds(from: fetchedBreeds.favoriteBreeds)
                .filtered(by: searchText)
                .sorted(by: sortBy)
        }
        
        return ForEach(breedsToShow) { breed in
            Button(action: { router.push(.detail(breed)) }) {
                BreedCellView(
                    breed: breed,
                    cellSize: (
                        width: UIScreen.main.bounds.width / CGFloat(Constants.columns) - Constants.cellWidthRatio,
                        height: Constants.cellHeight
                    )
                )
            }
            .buttonStyle(.plain)
        }
    }
}
